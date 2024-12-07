
## Java内存
Java进程所包含的内存有
- 堆内存（Xmx）
- 非堆内存（Metaspace，Code Cache，...）
- 外界API管理的内存

估算方式例如：
- 给服务端分配4G内存，在进程运行时候的内存占用大概是（堆4G + 非堆1G = 5G占用）
- 给客户端分配4G内存，在进程运行时候的内存占用大概是（堆4G + 非堆1G + OpenGL 2G = 7G占用）

## TPS排查
- 可以使用[spark](https://spark.lucko.me/download)采集并导出插件/MOD占用耗时堆栈图，找出tick占用高的堆栈顺序里最先出现的插件/模组

## 我的G1GC调优侧重
最大化削峰，让GC的CPU占用均匀，把Mixed GC的次数控制在最少，尽可能用最少的暂停时间去换这些目标

## 我的G1GC参数讲解
- ## -XX:MaxGCPauseMillis=100
  每一轮GC里尽可能把暂停时间不超过100ms  

- ## -XX:G1HeapRegionSize=2M
  Region大小为2M，理由是从ZGC学习所得，对于MC的内存利用能更紧凑  
  Region的大小影响内存碎片数量和脏卡分析量  

- ## -XX:G1ReservePercent=10
  保留10%堆空间  
  假设堆有4G，那么软上限就是3600M，留出400M给极端情况  
  G1不使用SoftMaxHeapSize  

- ## -XX:G1NewSizePercent=33 -XX:G1MaxNewSizePercent=33
  年轻代大小为恒定的全堆中33%大小，此时老年代就为67%  
  不使用自适应年轻代大小是为了阻止幸存区上限被一起改变  

- ## -XX:SurvivorRatio=Eden / (64M + CPU核心 * 16M)
  幸存区大小将使用脚本内的公式自动计算目标值，CPU核心数越多，幸存区就越大  
  幸存区大小是影响暂停时间的第一大因素，过高会导致暂停变长，但过低会导致老年代加速膨胀  

- ## -XX:TargetSurvivorRatio=75
  幸存区占用达到75%时开始清理，把年龄超过InitialTenuringThreshold的对象送进养老院  

- ## -XX:InitialTenuringThreshold=15
  被动晋升阈值设置为15，从最老的对象开始送  
  因为对象头当中有4bit用来表示年龄，所以年龄容纳的最大值就是15  

- ## -XX:MaxTenuringThreshold=16
  主动晋升阈值设置为16  
  由于16已经超过了最大的15，所以将是永不主动晋升，全靠幸存区占用达到阈值时触发被动晋升  

- ## -XX:+ParallelRefProcEnabled
  Java8没有对这个选项默认启用，所以才加上这个选项  

- ## -XX:G1RSetUpdatingPauseTimePercent=25
  决定Pause Remark可以暂停的时间  
  按照MaxGCPauseMillis=100，所以Pause Remark最多可以暂停25ms左右  

- ## -XX:-G1UseAdaptiveIHOP
  让GC不要插手暗改InitiatingHeapOccupancyPercent，尽可能减少不必要的Mixed GC  

- ## -XX:InitiatingHeapOccupancyPercent=50
  当老年代占用大小达到全堆50%时，开始启动一轮Mixed GC  

- ## -XX:G1MixedGCCountTarget=10
  一轮Mixed GC最多持续10次收集  
  因为一次收集默认扫描老年代中10%的区域，所以给10次  

- ## -XX:G1MixedGCLiveThresholdPercent=90
  每一次Mixed GC收集只有Region中存在10%以上垃圾才会加入Cset  

- ## -XX:G1HeapWastePercent=5
  最少可以回收5%的堆空间才会继续这一轮Mixed GC，否则提前结束  
