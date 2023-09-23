# 分布式文件系统(DFS)

## 论文阅读

- Raft (ATC' 14) 读了大部分流程

## CubeFS部分

### Metanode总体架构介绍

https://mp.weixin.qq.com/s/_PwSANyJZZuFst1SOolNGQ

> 在CubeFS中元数据集群由多个metanode组成，可以做到横向扩展。单个metanode管理多个metapatiton,每个mp管理一段固定范围的inode。一台metanode上有多metapartion，每个mp与另外的2个meta节点组成一个copyset,既raft group。metanode间使用multiraft算法减少多个raft group之间的网络连接开销。所有的元数据全部在内存中，这样可以保证百us延迟的元数据操作。
>
> mp会定时snapshot保存在磁盘上，配合wal log进行元数据的持久化和快速恢复。
>
> 在mp中，主要有两个关键数据结构：dentryBtree及inodeBtree.
>
> dentryBtree主要记录了文件与父目录的关系信息，btree的key：父节点的inodeId/fnamevalue:inodeID
>
> inodeBtree主要记录了当前mp管理的inode信息：key：inodeId value:文件相关属性信息。

![metanode-arch](/Users/xuruida/Work/Research/DFS/assets/metanode-arch.jpeg)

### 实现的结构

#### B-Tree实现

`util/btree/btree.go`

- 使用Google基于Go开发的B-Tree https://github.com/google/btree。其并不支持并发写
- 为了支持并发写，CubeFS在`metanode/btree.go中使用sync库中的RWMutex对接口进行封装实现安全并发读写（只是套了个锁）。

#### MetaNode实现

`metanode/metanode.go`

```go
// The MetaNode manages the dentry and inode information of the meta partitions on a meta node.
// The data consistency is ensured by Raft.
type MetaNode struct {
	nodeId            uint64
	listen            string
	bindIp            bool
	metadataDir       string // root dir of the metaNode
	raftDir           string // root dir of the raftStore log
	metadataManager   MetadataManager // 注意：这里metadataManager存储了对应的partition
	localAddr         string
	clusterId         string
	raftStore         raftstore.RaftStore
	raftHeartbeatPort string
	raftReplicatePort string
	zoneName          string
	httpStopC         chan uint8
	smuxStopC         chan uint8
	metrics           *MetaNodeMetrics
	tickInterval      int
	raftRecvBufSize   int
	connectionCnt     int64
	clusterUuid       string
	clusterUuidEnable bool

	control common.Control
}
```

其中，MetadataManager管理了所有的meta分片（Meta Partition)

#### metadataManager实现

```go
type metadataManager struct {
	nodeId               uint64
	zoneName             string
	rootDir              string
	raftStore            raftstore.RaftStore
	connPool             *util.ConnectPool
	state                uint32
	mu                   sync.RWMutex
	partitions           map[uint64]MetaPartition // Key: metaRangeId, Val: metaPartition
	metaNode             *MetaNode
	flDeleteBatchCount   atomic.Value
	fileStatsEnable      bool
	curQuotaGoroutineNum int32
	maxQuotaGoroutineNum int32
}
```

查找通过`getPartition(id uint64) MetaPartition`

根据Golang的实现map是哈希表实现，从ID映射到MetaPartition。

#### metaPartition实现

**存储了dentryTree，inodeTree两个树的指针**

```go
// metaPartition manages the range of the inode IDs.
// When a new inode is requested, it allocates a new inode id for this inode if possible.
// States:
//  +-----+             +-------+
//  | New | → Restore → | Ready |
//  +-----+             +-------+
type metaPartition struct {
	config                 *MetaPartitionConfig
	size                   uint64                // For partition all file size
	applyID                uint64                // Inode/Dentry max applyID, this index will be update after restoring from the dumped data.
  dentryTree             *BTree                // !!! btree for dentries 
	inodeTree              *BTree                // !!! btree for inodes
	extendTree             *BTree                // btree for inode extend (XAttr) management
	multipartTree          *BTree                // collection for multipart management
	txProcessor            *TransactionProcessor // transction processor
	raftPartition          raftstore.Partition
	stopC                  chan bool
	storeChan              chan *storeMsg
	state                  uint32
	delInodeFp             *os.File
	freeList               *freeList // free inode list
	extDelCh               chan []proto.ExtentKey
	extReset               chan struct{}
	vol                    *Vol
	manager                *metadataManager
	isLoadingMetaPartition bool
	summaryLock            sync.Mutex
	ebsClient              *blobstore.BlobStoreClient
	volType                int
	isFollowerRead         bool
	uidManager             *UidManager
	xattrLock              sync.Mutex
	fileRange              []int64
	mqMgr                  *MetaQuotaManager
}
```

#### freeList

存储了空闲的`ino uint64`，是一个链表+HashMap的结构，可以常数时间remove，插入等。

#### Inode实现

`metanode/inode.go`

```go
// Inode wraps necessary properties of `Inode` information in the file system.
// Marshal exporterKey:
//  +-------+-------+
//  | item  | Inode |
//  +-------+-------+
//  | bytes |   8   |
//  +-------+-------+
// Marshal value:
//  +-------+------+------+-----+----+----+----+--------+------------------+
//  | item  | Type | Size | Gen | CT | AT | MT | ExtLen | MarshaledExtents |
//  +-------+------+------+-----+----+----+----+--------+------------------+
//  | bytes |  4   |  8   |  8  | 8  | 8  | 8  |   4    |      ExtLen      |
//  +-------+------+------+-----+----+----+----+--------+------------------+
// Marshal entity:
//  +-------+-----------+--------------+-----------+--------------+
//  | item  | KeyLength | MarshaledKey | ValLength | MarshaledVal |
//  +-------+-----------+--------------+-----------+--------------+
//  | bytes |     4     |   KeyLength  |     4     |   ValLength  |
//  +-------+-----------+--------------+-----------+--------------+
type Inode struct {
	sync.RWMutex
	Inode      uint64 // Inode ID
	Type       uint32
	Uid        uint32
	Gid        uint32
	Size       uint64
	Generation uint64
	CreateTime int64
	AccessTime int64
	ModifyTime int64
	LinkTarget []byte // SymLink target name
	NLink      uint32 // NodeLink counts
	Flag       int32
	Reserved   uint64 // reserved space
	//Extents    *ExtentsTree
	Extents    *SortedExtents
	ObjExtents *SortedObjExtents
}
```

#### Dentry实现



### 从metaPartition.getInode(ino)看起

```go
// metanode/partition_fsmop_inode.go: 119
func (mp *metaPartition) getInode(ino *Inode) (resp *InodeResponse) {
	resp = NewInodeResponse()
	resp.Status = proto.OpOk
	item := mp.inodeTree.Get(ino) // ! Called inodeTree.Get
	...
	i := item.(*Inode)
  ...
 	resp.Msg = i
	return
}
// 根据btree.go，实现Less()与Copy()即可传入BTree.Item接口
// 通过ino找到对应的item

// metanode/partition_op_inode.go： 308
// InodeGet executes the inodeGet command from the client.
func (mp *metaPartition) InodeGet(req *InodeGetReq, p *Packet) (err error) {
	...
	ino := NewInode(req.Inode, 0)
	retMsg := mp.getInode(ino) // Get inode with inode number.
	ino = retMsg.Msg
  ...
	p.PacketErrorWithBody(status, reply)
	return
}
// 一句话：根据req.Inode, 在p中返回了对应Inode信息
```

接下来两条引用路线：

#### api_handler

```go
// metanode/api_handler.go: 220
// 从
func (m *MetaNode) getInodeHandler(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	resp := NewAPIResponse(http.StatusBadRequest, "")
	defer func() {
		data, _ := resp.Marshal()
		if _, err := w.Write(data); err != nil {
			log.LogErrorf("[getInodeHandler] response %s", err)
		}
	}()
	pid, err := strconv.ParseUint(r.FormValue("pid"), 10, 64)
	...
	id, err := strconv.ParseUint(r.FormValue("ino"), 10, 64)
	...
	mp, err := m.metadataManager.GetPartition(pid)
	...
	req := &InodeGetReq{
		PartitionID: pid,
		Inode:       id,
	}
	p := &Packet{}
	err = mp.InodeGet(req, p)
	...
	resp.Code = http.StatusSeeOther // 返回了HTTP 303
	resp.Msg = p.GetResultMsg()
	if len(p.Data) > 0 {
		resp.Data = json.RawMessage(p.Data)
	}
	return
}

// metanode/api_handler.go: 55
// register the APIs
// 把上面的handler注册到"/getInode"
func (m *MetaNode) registerAPIHandler() (err error) {
	...
	http.HandleFunc("/getInode", m.getInodeHandler)
	...
	return
}

// metanode.go
// doStart()
// - 注册了APIHandler
// - startServer监听TCP端口，在收到close前监听新连接。
```

`Inode.md`

> # Inode管理
>
> ## 获取指定Inode基本信息
>
> ``` bash
> curl -v http://192.168.0.22:17210/getInode?pid=100&ino=1024
> ```
>
> 请求参数：
>
> | 参数  | 类型  | 描述       |
> |-----|-----|----------|
> | pid | 整型  | 分片id     |
> | ino | 整型  | inode的id |

#### manager_op.go

```go
// metanode/manager_op.go: 778
func (m *metadataManager) opMetaInodeGet(conn net.Conn, p *Packet,
	remoteAddr string) (err error) {
	req := &InodeGetReq{}
	if err = json.Unmarshal(p.Data, req); err != nil {
		...
	}
	mp, err := m.getPartition(req.PartitionID)
	if err != nil {
		...
	}
	if !mp.IsFollowerRead() && !m.serveProxy(conn, mp, p) {
		return
	}
	if err = mp.InodeGet(req, p); err != nil {
		err = errors.NewErrorf("[%v],req[%v],err[%v]", p.GetOpMsgWithReqAndResult(), req, string(p.Data))
	}
	m.respondToClient(conn, p)
	log.LogDebugf("%s [opMetaInodeGet] req: %d - %v; resp: %v, body: %s",
		remoteAddr, p.GetReqID(), req, p.GetResultMsg(), p.Data)
	return
}

// metanode/manager.go: 103
// HandleMetadataOperation handles the metadata operations.
func (m *metadataManager) HandleMetadataOperation(conn net.Conn, p *Packet, remoteAddr string) (err error) {
	// 注册了proto.OpMetaInodeGet操作
    switch p.Opcode {
    ...
    case proto.OpMetaInodeGet:
		err = m.opMetaInodeGet(conn, p, remoteAddr)
    ...
    }
    ...
}

// 处理TCP连接(conn)的请求
func (m *MetaNode) handlePacket(conn net.Conn, p *Packet,
	remoteAddr string) (err error) {
	// Handle request
	err = m.metadataManager.HandleMetadataOperation(conn, p, remoteAddr)
	return
}

// 
// Read data from the specified tcp connection until the connection is closed by the remote or the tcp service is down.
// 1. 从连接中读取数据，存到p *Packet中
// 2. 处理Packet
func (m *MetaNode) serveConn(conn net.Conn, stopC chan uint8) {
	defer func() {
		conn.Close()
		m.RemoveConnection()
	}()
	...
	remoteAddr := conn.RemoteAddr().String()
	for {
		select {
		case <-stopC:
			return
		default:
		}
		p := &Packet{}
		if err := p.ReadFromConn(conn, proto.NoReadDeadlineTime); err != nil {
			if err != io.EOF {
				log.LogError("serve MetaNode: ", err.Error())
			}
			return
		}
		if err := m.handlePacket(conn, p, remoteAddr); err != nil {
			log.LogErrorf("serve handlePacket fail: %v", err)
		}
	}
}
```

ReadFromConn，handlePacket从TCP连接中读取packet，而发送者在sdk/meta中，TODO：



Q:

- Why B-Tree
- 



#### Dentry

#### Lookup Operation

```go
BTree.get
func (mp *metaPartition) getDentry(dentry *Dentry) (*Dentry, uint8)
func (mp *metaPartition) Lookup(req *LookupReq, p *Packet) (err error)
func (m *metadataManager) opMetaLookup(conn net.Conn, p *Packet, remoteAddr string) (err error)
func (m *metadataManager) HandleMetadataOperation(conn net.Conn, p *Packet, remoteAddr string) (err error)

network

func (mw *MetaWrapper) lookup(mp *MetaPartition, parentID uint64, name string) (status int, inode uint64, mode uint32, err error)
func (mw *MetaWrapper) Lookup_ll(parentID uint64, name string) (inode uint64, mode uint32, err error)

// LookupPath: 从Root开始查询一个Ino ID
// Looks up absolute path and returns the ino
func (mw *MetaWrapper) LookupPath(subdir string) (uint64, error) {
	ino := proto.RootIno
	if subdir == "" || subdir == "/" {
		return ino, nil
	}

	dirs := strings.Split(subdir, "/")
	for _, dir := range dirs {
		if dir == "/" || dir == "" {
			continue
		}
		child, _, err := mw.Lookup_ll(ino, dir)
		if err != nil {
			return 0, err
		}
		ino = child
	}
	return ino, nil
}


```



从Client端的Lookup看起：

- 客户端使用用户空间文件系统bazil.org/fuse，挂载到某个文件夹，调用Serve接口开始循环接收请求：

```go
// client/fuse.go 262:
// main函数入口，最后调用fs.Serve启动服务
func main() {
	flag.Parse()
	// ...
    // Line 469:
    if err = fs.Serve(fsConn, super, opt); err != nil {
		log.LogFlush()
		syslog.Printf("fs Serve returns err(%v)", err)
		os.Exit(1)
	}
	// ...
}

// depends/bazil.org/fuse/fs/serve.go: 959

// Serve serves a FUSE connection with the default settings. See
// Server.Serve.

// 新建一个server，并启动服务
func Serve(c *fuse.Conn, fs FS, opt *proto.MountOptions) error {
	server := New(c, nil)
	return server.Serve(fs, opt)
}

// depends/bazil.org/fuse/fs/serve.go: 897
// Serve serves the FUSE connection by making calls to the methods
// of fs and the Nodes and Handles it makes available.  It returns only
// when the connection has been closed or an unexpected error occurs.

// 循环不断接收信息读取conn中的信息，取出req进行处理
func (s *Server) Serve(fs FS, opt *proto.MountOptions) error {
	defer s.wg.Wait() // Wait for worker goroutines to complete before return
    // ...
    // 循环轮训读取Requests
	for {
		if s.TrySuspend(fs) {
			break
		}

        // 从conn中读出req
		req, err := s.conn.ReadRequest()
		// ...
        // 并发执行s.serve(req)
		go func() {
			defer s.wg.Done()
			if opt != nil && opt.RequestTimeout > 0 {
				s.serveWithTimeOut(req, opt.RequestTimeout)
			} else {
				s.serve(req)
			}
		}()
	}
	return nil
}

// depends/bazil.org/fuse/fs/serve.go: 1295
func (c *Server) serve(r fuse.Request) {
	ctx, cancel := context.WithCancel(context.Background())
    // ...
    // 处理请求
    if err := c.handleRequest(ctx, node, snode, r, done); err != nil {
		// ...
	}
}
    
// depends/bazil.org/fuse/fs/serve.go: 1530
// handleRequest will either a) call done(s) and r.Respond(s) OR b) return an error.
// 处理请求，执行done对应的函数
func (c *Server) handleRequest(ctx context.Context, node Node, snode *serveNode, r fuse.Request, done func(resp interface{})) error {
   	// 根据类型进行处理
	switch r := r.(type) {
    // ...
    // 以 LookupRequest 为例
    case *fuse.LookupRequest:
		var n2 Node
		var err error
		s := &fuse.LookupResponse{}
		initLookupResponse(s)
        
        // 执行Lookup
		if n, ok := node.(NodeStringLookuper); ok {
			n2, err = n.Lookup(ctx, r.Name)
		} else if n, ok := node.(NodeRequestLookuper); ok {
            // PS: 上面那个没实现，只实现了下面的，后面继续看这个n.Lookup
			n2, err = n.Lookup(ctx, r, s)
		} else {
			return fuse.ENOENT
		}
		if err != nil {
			return err
		}
        
        // 向s中保存respond
		if err := c.saveLookup(ctx, s, snode, r.Name, n2); err != nil {
			return err
		}
		done(s)
        // respond
		r.Respond(s)
		return nil
        
	// ... Other cases
    }
}

// client/fs/dir.go: 286
// Lookup handles the lookup request.
func (d *Dir) Lookup(ctx context.Context, req *fuse.LookupRequest, resp *fuse.LookupResponse) (fs.Node, error) {
	var (
		ino      uint64
		err      error
		dcachev2 bool
	)
    
    // 在给定文件夹下找对应名称的文件，分为三步：
    // PS：下面没有考虑：
    // - 存在dcachev2，dcache的情况（dentry的缓存）
    // - 存在super.nodeCache的情况
    // - 除去了错误处理
    // 1. 通过parentID + 名称，从dentryTree中找到对应的cino（文件的inode number）
    ino, _, err = d.super.mw.Lookup_ll(d.info.Inode, req.Name)
   
    // 2. 调用InodeGet，根据ino，从inodeTree中找到对应的具体inode（info）
    info, err := d.super.InodeGet(ino)

    // 3. 根据是否是文件夹，新建child并返回
    if mode.IsDir() {
        child = NewDir(d.super, info, d.info.Inode, req.Name)
    } else {
        child = NewFile(d.super, info, DefaultFlag, d.info.Inode, req.Name)
    }
    
    resp.EntryValid = LookupValidDuration
    return child, nil
}
```

接下来便对应了上面关于Lookup_ll与InodeGet的分析，流程如上

- TODO：明天整理一下，这就是一个从fuse LookupRequest对源数据访问的全部流程，做个PPT^^



- FUSE收到Lookup Request
- 使用client/fs/dir.go的Lookup函数处理
- 通过SDK中MetaWrapper查询对应inode number
  - 组织packet发送到meta部分的leader节点
  - TCP。。。
  - 得到数据
- 得到对应文件inode number
- 调用SDK/meta中的InodeGet_ll得到具体的Inode信息
- 返回给fuse中的接口



另外的点：

Inode+Dentry条目占的比较大，把这部分的内容放到kv里去

初衷：快速上线，B Tree的KV分离，是否可以做一些结合

- 关键路径存在磁盘访问，OPPO在想是否有优化手段，没有明确的思路
- 一个MP下耦合冷热，MP单个很大，16000000个inode，只有一点点是热的



- 不管B树，直接使用RocksDB去做KV（问题：完全KV分离需要磁盘I/O读速度太慢）
- 结合文件系统inode的关系细化冷热分离甚至预读等
- KV分离
- 热Value放到内存中去
