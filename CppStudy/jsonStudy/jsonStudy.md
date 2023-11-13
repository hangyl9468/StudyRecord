jsonStudy：vscode运行C++环境下，脚本文件task.json和launch.json的编写

主要注意：

- launch.json生成配置时，注意更改program的路径和运行的文件，若启用gdb调试，也需注意gdbpath是需要自己补充完整路径的
- tasks.json生成，可通过在对应运行文件下按Ctrl + Shift + P，输入tasks configuration，配置对应文件的task，最后稍作修改即可
- 同时注意workspaceFolder和fileDirname的区别，前者是根目录，后者是当前打开文件所在目录