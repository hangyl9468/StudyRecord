#include<iostream>
#include<string>
#include<easyx.h> //(注意命令行运行gcc要链接easyx库，即加上-leasyx)
#include<tchar.h>
#include<time.h>
#include"include/tools.hpp"

// 音乐播放头文件(注意命令行运行gcc要链接winmm库，即加上-lwinmm)
#include<windows.h>
#include<mmsystem.h>

using namespace std;

ExMessage msg = {0};

//简单图形
void showgraph(){
    putpixel(50,50,RED);

    setlinestyle(PS_SOLID,3);
    setlinecolor(BLUE);
    line(0,0,640,480);

    setfillcolor(YELLOW);
    fillrectangle(100,0,200,50);

    solidcircle(150,150,50);
}

//文字输出(居中)
void showtext(){

    int x = 200,y = 100, h = 50, w = 100;

    setfillcolor(RGB(195,195,195));
    fillroundrect(x,y,x+w,y+h,10,10);

    char text[] = "start game";
    int x_start =  x + (w - textwidth(LPCTSTR(text)))/2;
    int y_start =  y + (h - textheight(LPCTSTR(text)))/2;

    settextcolor(BLACK);
    outtextxy(x_start,y_start,LPCTSTR(text));

    //char str2[50] = "55.5";
    // settextcolor(YELLOW);
    // settextstyle(50,0,_T("微软黑体"));

    //int data = 68;
    //sprintf(str2,"%d",data);
    //outtextxy(getwidth() - 200,0,LPCTSTR(str2));

}

//鼠标点击事件
void showmouseclick(){

    int x = 200,y = 100, h = 50, w = 100;
    char text[] = "start game";
    int x_start =  x + (w - textwidth(LPCTSTR(text)))/2;
    int y_start =  y + (h - textheight(LPCTSTR(text)))/2;

    while(true){

        peekmessage(&msg,EX_MOUSE);

        BeginBatchDraw();
        cleardevice();
        if(msg.x > x && msg.x < x + w && msg.y > y && msg.y < y + h){
            setfillcolor(RGB(127,127,127));
        }
        else{
            setfillcolor(RGB(195,195,195));
        }
        fillroundrect(x,y,x+w,y+h,10,10);

        settextcolor(BLACK);
        outtextxy(x_start,y_start,LPCTSTR(text));
        EndBatchDraw();

        if(msg.x > x && msg.x < x + w && msg.y > y && msg.y < y + h && msg.message == WM_LBUTTONDOWN){
            cout << "start game" << endl;
        }

        msg.message = 0;
    }

}

//键盘按起事件(小球移动)
void showkeydown(){
    double starttime,endtime;
    double fps = 1000 / 60;
    int x = 50, y = 50, r = 30;
    int vx = 0, vy = 0;
    int speed = 2;

    while(true){
        peekmessage(&msg,EX_KEY);

        starttime = clock();
        if(msg.message == WM_KEYDOWN){
            switch (msg.vkcode)
            {
            case VK_DOWN:
                vy = 1;
                break;
            case VK_UP:
                vy = -1;
                break;
            case VK_LEFT:
                vx = -1;
                break;
            case VK_RIGHT:
                vx = 1;
                break;
            default:
                break;
            }
        }
        else if(msg.message == WM_KEYUP){
            switch (msg.vkcode)
            {
            case VK_DOWN:
                if(vy == 1){
                    vy = 0;
                }
                break;
            case VK_UP:
                if(vy == -1){
                    vy = 0;
                }
                break;
            case VK_LEFT:
                if(vx == -1){
                    vx = 0;
                }
                break;
            case VK_RIGHT:
                if(vx == 1){
                    vx = 0;
                }
                break;
            default:
                break;
            }
        }

        x += vx * speed;
        y += vy * speed;

        BeginBatchDraw();
        cleardevice();
        setfillcolor(BLUE);
        solidcircle(x,y,r);
        EndBatchDraw();

        endtime = clock();
        if(endtime - starttime < fps){
            Sleep(fps - (endtime - starttime));
        }
        msg.message = 0;
    }

}

//两种透明贴图方式
void showimg1(){

    IMAGE img_back;
    loadimage(&img_back,_T("IMG/mm.png"));
    putimage(0,0,&img_back);

    //掩码方式
    IMAGE img_mask[2];
    loadimage(img_mask + 0,_T("IMG/planeNormal_1.jpg"));
    loadimage(img_mask + 1,_T("IMG/planeNormal_2.jpg"));
    putimage(500,500,img_mask + 0,NOTSRCERASE);
    putimage(500,500,img_mask + 1,SRCINVERT);

    //自写去背景方式(详见include/tools.hpp)
    IMAGE img;
    loadimage(&img,_T("IMG/enemy1.png"));
    drawImg(600,500,&img);
}

//动图
void showimg2(){

    char path[50];
    double fps = 1000 / 4;
    double starttime,endtime;
    int totalimg = 4;
    int index = 0;

    IMAGE img_back;
    loadimage(&img_back,_T("IMG/mm.png"));

    IMAGE img[4];
    for(int i = 1; i <= totalimg; i++){
        sprintf(path,"IMG/enemy1_down%d.png", i);
        loadimage(img + i,LPCTSTR(path));
    }

    while(true){

        starttime = clock();

        loadimage(&img_back,_T("IMG/mm.png"));

        BeginBatchDraw();
        cleardevice();
        putimage(0,0,&img_back);
        drawImg(500,500,img + index);
        EndBatchDraw();

        index = (index + 1)%totalimg;
        endtime = clock();
        
        if(endtime - starttime < fps){
            Sleep(fps-(endtime-starttime));
        }
    }
}

//精灵动图
void showimg3(){

    char path[50] = "IMG/pikachu.png";
    int fps = 1000 / 7;
    double starttime,endtime;
    int totalimg = 7;
    int index = 0;
    int img_w = 32, img_h = 32;

    IMAGE img_back;
    loadimage(&img_back,_T("IMG/mm.jpg"));

    IMAGE img;
    loadimage(&img,LPCTSTR(path));

    while(true){

        starttime = clock();

        loadimage(&img_back,_T("IMG/mm.png"));

        BeginBatchDraw();
        cleardevice();
        putimage(0,0,&img_back);
        drawImg(500,500,img_w,img_h,&img,img_w * index,0);
        EndBatchDraw();

        index = (index + 1)%totalimg;
        endtime = clock();
        
        if(endtime - starttime < fps){
            Sleep(fps-(endtime-starttime));
        }
    }
}

//播放音乐
void showmusic(){

    // 对于wav格式音乐不能循环播放
    mciSendStringW(L"open Music/That-Girl.mp3 alias bgm", NULL, 0, NULL);
    mciSendStringW(L"play bgm repeat",NULL,0,NULL);
    mciSendStringW(L"setaudio bgm volume to 30",NULL,0,NULL);

    // 对于wav格式音乐播放
    PlaySoundW(L"Music/video_call.wav", NULL, SND_FILENAME | SND_ASYNC | SND_LOOP);
}

int main(){
    initgraph(1080,607,EX_SHOWCONSOLE | EX_DBLCLKS);
    setbkcolor(RGB(255,174,201));
    setbkmode(TRANSPARENT);
    cleardevice();

    //showgraph();

    //showtext();

    //showmouseclick();

    //showkeydown();

    //showimg1();

    showimg2();

    //showimg3();

    //showmusic();

    getchar();
    closegraph();
    return 0;
}