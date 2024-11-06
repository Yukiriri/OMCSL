<div align="center">

# OMCSL

</div>

一个自动化选择MC通用优化的启动脚本，使用自适应公式根据可用资源计算低暂停与总负载的平衡点。<br/>

## 讲解汇总

- [运行效果](./readme/test-summary.md)
- [对比Aikar's Flags](./readme/aikars-g1gc.md)
- [经验总结](./readme/my-gc.md)

## 计划功能

- Linux脚本加入自动判断大页开关来启用透明大页

## 安装

1.下载仓库
```
git clone https://github.com/Yukiriri/OMCSL.git
```
2.将仓库中bin目录添加到环境变量（可选）

## 启动

推荐JDK：
- [Adoptium JDK](https://adoptium.net/zh-CN/temurin/releases/)
- [Liberica JDK](https://bell-sw.com/pages/downloads/)
- [Zulu JDK](https://www.azul.com/downloads/?package=jdk#zulu)

命令格式：omcsl \<core\> \<Xmx\> [ \<GC\> [ yggdrasil ] ]
- `core`：服务端jar文件名 或者 MOD加载器的启动@txt
- `Xmx`：堆内存大小
- `GC`：可选以下（区分大小写）：
  - `auto`：使用脚本内的简单判断规则自动选择（默认）
  - `gc8`：使用Java8开始可用的GC预设
  - `gc11`：使用Java11开始可用的GC预设
  - `gc21`：使用Java21开始可用的GC预设
  - `gc21c`：使用Java21开始可用的GC预设，以更高CPU占用把堆内存水位控制在最低
- `yggdrasil`：可选以下（区分大小写）：
  - `ls`：修改yggdrasil为littleskin
> 使用`yggdrasil`参数需要在上级目录放置`authlib-injector.jar`

环境变量参数：
- `JAVA_BIN`：自定义java路径

命令样例：
  - 分配4G的堆，自动选择GC，不修改yggdrasil
    ```
    omcsl purpur.jar 4G
    ```
  - 分配4G的堆，选择GC8，不修改yggdrasil
    ```
    omcsl purpur.jar 4G gc8
    ```
  - 分配4G的堆，选择GC8，修改yggdrasil为littleskin
    ```
    omcsl purpur.jar 4G gc8 ls
    ```
  - 分配4G的堆，自动选择GC，修改yggdrasil为littleskin
    ```
    omcsl purpur.jar 4G auto ls
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

## 更新

```
cd OMCSL
git pull
```
提示：在Windows平台需要把实例关闭后再更新，这个涉及到win对bat读取的逆天机制

## 学习参考

- [Aikar's Flags](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft)
- [VM Options Explorer](https://chriswhocodes.com/vm-options-explorer.html)
- [https://pdai.tech/md/java/jvm/java-jvm-gc-g1.html](https://pdai.tech/md/java/jvm/java-jvm-gc-g1.html)
- [ZGC OpenJDK Wiki](https://wiki.openjdk.org/display/zgc)

## 无用的吐槽

Java/JVM的发展理念就是让一切代码变得宝宝巴士，好处是少掉几根头发，坏处是所有瓶颈因此栽在这<br/>
要不是因为MC，估计我这辈子也不会去深入Java这一遭（）<br/>
