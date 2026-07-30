# 一般值得计算的JVM内存
- ### 托管堆内存(Xmx)
  - 绝大多数MC本体逻辑和MOD逻辑所使用的内存
- ### 非托管堆内存(DirectMemory)
  - MC本体和MOD所用的部分NIO操作会使用的内存
  - 在处理一些复杂的材质包纹理时会使用的内存
- ### JVM自身内存
  - Metaspace
  - Code Cache
  - ...
- ### Native API内存
  - OpenGL/Vulkan资源管理使用的内存
  - 一些罕见MOD使用JNI操作的内存

# 估算方式参考
- 给服务端-Xmx4G，运行期占用大概是(Xmx 4G + JVM 1G = 5G)
- 给客户端-Xmx4G，运行期占用大概是(Xmx 4G + JVM 1G + OpenGL 2G = 7G)
