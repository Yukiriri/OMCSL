<div align="center">

![Banner](https://socialify.git.ci/Yukiriri/OMCSL/image?description=1&language=1&name=1&owner=1&pattern=Circuit%20Board&theme=Auto)

![Stars](https://img.shields.io/github/stars/Yukiriri/OMCSL?style=for-the-badge)
![Forks](https://img.shields.io/github/forks/Yukiriri/OMCSL?style=for-the-badge)
![Issues](https://img.shields.io/github/issues/Yukiriri/OMCSL?style=for-the-badge)
![Pull](https://img.shields.io/github/issues-pr/Yukiriri/OMCSL?style=for-the-badge)

![Code Size](https://img.shields.io/github/languages/code-size/Yukiriri/OMCSL?style=for-the-badge)

</div>

一个自动化选择MC通用优化的启动脚本，使用自适应公式根据可用资源计算低暂停与总负载的平衡点。  
如果遇到问题或者有更好的调优，欢迎提出。  

# 讲解汇总
- [运行效果](./md/test-summary.md)
- [对比Aikar's Flags](./md/aikar-g1gc.md)
- [经验总结](./md/my-gc.md)

# 计划功能
- Linux脚本加入自动判断大页开关来启用透明大页

# 安装
1. 下载仓库
    ```
    git clone -b stable https://github.com/Yukiriri/OMCSL.git
    ```
2. （可选）将仓库中bin目录添加到环境变量

# 启动
- ## 推荐JDK
    - [Adoptium JDK](https://adoptium.net/zh-CN/temurin/releases/)
    - [Liberica JDK](https://bell-sw.com/pages/downloads/)
    - [Zulu JDK](https://www.azul.com/downloads/?package=jdk#zulu)

- ## 命令格式
    ### `omcsl` \<`core`\> \<`Xmx`\> [ \<`GC`\> [ `yggdrasil` ] ]
    - `core`：服务端jar文件名 或者 MOD加载器的启动@txt
    - `Xmx`：堆内存大小
    - `GC`：可选以下（区分大小写）：
        - `auto`  
            使用脚本内的简单判断自动选择（默认）  
        - `gc8`  
            使用Java8开始可用的GC预设  
            有一定的暂停时间，GC负载全程都比较低  
        - `gc11`  
            使用Java11开始可用的GC预设  
            暂停时间基本上在3毫秒，GC负载高  
        - `gc21`  
            使用Java21开始可用的GC预设  
            暂停时间基本上在0.1毫秒，GC负载只高了一些  
        - `gc21c`  
            和上面的gc21相同  
            但以更高CPU占用把堆内存水位控制在最低  
    - `yggdrasil`：可选以下（区分大小写）：  
        - `ls`：修改yggdrasil为littleskin  

> [!IMPORTANT]  
> 1. 由于还没有编写系统版本判断，如果你有原因不能使用新版本系统，请手动把`GC`参数填写为`gc8`  
> 2. 使用`yggdrasil`参数需要在上级目录放置`authlib-injector.jar`  

- ## 命令样例
    - 分配4G的堆，自动选择gc，不修改yggdrasil
        ```
        omcsl purpur.jar 4G
        ```
    - 分配4G的堆，选择gc8，不修改yggdrasil
        ```
        omcsl purpur.jar 4G gc8
        ```
    - 分配4G的堆，自动选择gc，修改yggdrasil为littleskin
        ```
        omcsl purpur.jar 4G auto ls
        ```
    - 分配4G的堆，选择gc8，修改yggdrasil为littleskin
        ```
        omcsl purpur.jar 4G gc8 ls
        ```
    - 使用环境变量
        - Windows bat脚本
            ```
            set JAVA_BIN=C:\Java\bin\java
            omcsl purpur.jar 4G
            ```
        - Linux shell脚本
            ```
            export JAVA_BIN=/opt/Java/bin/java
            omcsl purpur.jar 4G
            ```

# 更新
```
cd OMCSL
git pull
```
> [!IMPORTANT]  
> 在Windows平台需要把实例关闭后再更新，这个涉及到win对bat读取的逆天机制  

## 学习参考
- [Aikar's Flags](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft)
- [VM Options Explorer](https://chriswhocodes.com/vm-options-explorer.html)
- [https://pdai.tech/md/java/jvm/java-jvm-gc-g1.html](https://pdai.tech/md/java/jvm/java-jvm-gc-g1.html)
- [ZGC OpenJDK Wiki](https://wiki.openjdk.org/display/zgc)

## Stargazers
[![Stargazers](https://starchart.cc/Yukiriri/OMCSL.svg?variant=adaptive)](https://starchart.cc/Yukiriri/OMCSL)

## 无用的吐槽
Java/JVM的发展理念就是让一切代码变得宝宝巴士，好处是少掉几根头发，坏处是所有瓶颈因此栽在这。  
要不是因为MC，估计我这辈子也不会去深入Java这一遭（）  
