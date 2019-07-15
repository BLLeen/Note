# 概念
NFC文件系统是Unix系统间文件共享系统，即挂载到NFC服务端主机上，NFC客户端共享这个挂载点

# 实现
在NFC文件系统通过网络传输，访问端口是未知的，<1024的端口，通过RPC实现远程调用
## RPC
RPC基于TCP/IP协议
[RPC](http://pcpj2g4mj.bkt.clouddn.com/18-9-11/67159636.jpg)
