重新定制新版本MC通用JVM优化参数，同时涵盖服务端和客户端  
如果遇到问题或者有更好的调优，欢迎提出  
也欢迎贡献更多的统计数据  
祝你能收获更多快乐  

## 用途一览
[G1GC  ]: ../flags/jvmgc-g1gc.txt
[G1GC-C]: ../flags/jvmgc-g1gc-c.txt
[G1GC-M]: ../flags/jvmgc-g1gc-m.txt
[ZGC   ]: ../flags/jvmgc-zgc.txt
[ZGC-C ]: ../flags/jvmgc-zgc-c.txt
[SGC   ]: ../flags/jvmgc-sgc.txt
[SGC-C ]: ../flags/jvmgc-sgc-c.txt

| JVM GC参数 | STW程度         | 运行表现     | JDK要求 | 适用场景                   |
| :--------- | :-------------- | :----------- | :------ | :------------------------- |
| [G1GC]     | 轻度 & 偶尔尖峰 | 均衡         | JDK8+   | 服务端 & 客户端            |
| [G1GC-C]   | 轻度 & 少量尖峰 | 积极返还内存 | JDK8+   | 客户端                     |
| [G1GC-M]   | 持续轻度        | 内存紧凑     | JDK8+   | 服务端 & 客户端            |
| [ZGC]      | 无感 & 偶尔微感 | 积极消费内存 | JDK21+  | 服务端 & 客户端 & Velocity |
| [ZGC-C]    | 无感 & 偶尔微感 | 积极返还内存 | JDK21+  | 客户端                     |
| [SGC]      | 无感 & 偶尔轻度 | 积极消费内存 | JDK25+  | 服务端 & 客户端 & Velocity |
| [SGC-C]    | 无感 & 偶尔轻度 | 积极返还内存 | JDK25+  | 客户端                     |

- ## 已有的统计数据
  [/docs/statistical/](./statistical/)

- ## 选择参考
  - ## 低主频
    |               | 服务端         | 客户端           |
    | :------------ | :------------- | :--------------- |
    | 少核心 小内存 | [G1GC]         | [G1GC]           |
    | 少核心 大内存 | [G1GC]         | [G1GC]           |
    | 多核心 小内存 | [ZGC] > [G1GC] | [ZGC-C] > [G1GC] |
    | 多核心 大内存 | [ZGC]          | [ZGC-C]          |

  - ## 高主频
    |               | 服务端         | 客户端           |
    | :------------ | :------------- | :--------------- |
    | 少核心 小内存 | [G1GC]         | [G1GC]           |
    | 少核心 大内存 | [ZGC] > [G1GC] | [ZGC-C] > [G1GC] |
    | 多核心 小内存 | [ZGC] > [G1GC] | [ZGC-C] > [G1GC] |
    | 多核心 大内存 | [ZGC]          | [ZGC-C]          |

> [!TIP]  
> `G1GC-C` `ZGC-C` `SGC-C`可以有节省内存的用途  
> 如果想节省内存占用，就把`-Xms`设置到比`-Xmx`更低  
> 但是`G1GC-C`的`-Xms`不要给太小，不然反复伸缩进程内存会导致STW大幅波动  

## 使用方式
- ## 服务端  
  - 添加到java启动命令行  
    (在-jar之前)  
  - 写入到txt文件并在启动命令行添加@xxx.txt  
    (在-jar之前)  
    (需要JDK9+)  
  - 也可以添加到`user_jvm_args.txt`  
    (这个因服务端而异)  
- ## 客户端  
  - 添加到启动器自定义JVM参数  
    (需要删除启动器已有的`-XX:+UseG1GC`)  
  - 写入到txt文件并在启动器自定义JVM参数添加@xxx.txt  
    (需要删除启动器已有的`-XX:+UseG1GC`)  
    (需要JDK9+)  

> [!IMPORTANT]  
> 在使用Windows写入到txt时，需要注意行尾必须为LF  

## JDK推荐
- [Liberica](https://bell-sw.com/pages/downloads/)
- [Zulu](https://www.azul.com/downloads/)
- [Graalvm](https://www.graalvm.org/downloads/)

> [!TIP]  
> 推荐使用LTS版本，可以有更广范围的旧版MC兼容性  

## 经验心得
- [内存估算](./experience/memory.md)

## Credits
- https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft

## Acknowledgements
- https://chriswhocodes.com/vm-options-explorer.html
