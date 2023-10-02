easyxStudy：vscode使用适配mingw的easyx库下，学习C++图形界面的编写

- 适配mingw的easyx库文件：https://codebus.cn/bestans/easyx-for-mingw
- 链接库文件的几种方法：
  - 把库文件和头文件分别加入到mingw根文件夹下的x86_64-w64-mingw32文件的lib和include中，同时命令行加上 -leasyx(-l 是link 链接的意思)
  - 直接在主程序中引入easyx的头文件路径，并在运行命令行上加入 -I "lib库文件路径"
  - 使用cmake包括easyx头文件路径和easyx库文件路径，最后链接easyx库文件即可