# Socket概念详解

## 概念

![](C:\Users\XIONG\Pictures\IT\JAVA\JAVA_Socket\四层协议.png)

网络上两个程序通过一个**双向的通信连接**实现数据的交换，这个连接的一段称为一个socket。建立网络通信连接至少要一对端口号(socket)。socket本质是编程接口(API)，对TCP/IP的封装，TCP/IP也要提供可供程序员做网络开发所用的接口，这就是Socket编程接口；socket是通信的基石，是支持**TCP/IP协议**的网络通信的**基本操作单元**。(也就是说机子上的每个端口只能被一个进程占用，所以Socket是用来不同主机**进程**之间的通信的)

## 作用

![](C:\Users\XIONG\Pictures\IT\JAVA\JAVA_Socket\Socket.png)

1. **提供了tcp/ip协议的抽象**:使用不同的协议进行通信，就得使用不同的协议接口进行开发，加大开发难度。socket屏蔽了各个协议的通信细节。
2. 

它是网络通信过程中端点的抽象表示，包含进行网络通信必须的五种信息：
- 连接使用的协议
- 本地主机的IP地址
- 本地进程的协议端口
- 远地主机的IP地址
- 远地进程的协议端口

Socket是对TCP/IP协议的**封装**，它把复杂的TCP/IP协议族隐藏在Socket接口后面，提供一个易用的接口，所以Socket本身并不是协议，而是一个**调用接口(API)**。

## 一个Socket实例

- so_type:  
  - SOCK_STREAM 提供有序的、可靠的、双向的和基于连接的字节流服务，当使用Internet地址族时使用TCP。
  - SOCK_DGRAM 支持无连接的、不可靠的和使用固定大小（通常很小）缓冲区的数据报服务，当使用Internet地址族使用UDP。
  - SOCK_RAW 原始套接字，允许对底层协议如IP或ICMP进行直接访问，可以用于自定义协议的开发。
- ip地址
- 端口号

## Socket接口

1. int **socket**(int protofamily, int so_type, int protocol)；创建socket实例化生成socket描述符，还没有绑定ip端口，确定socket实例的类型。
   - protofamily 指协议族，常见的值有：
     AF_INET，指定so_pcb中的地址要采用ipv4地址类型
     AF_INET6，指定so_pcb中的地址要采用ipv6的地址类型
     AF_LOCAL/AF_UNIX，指定so_pcb中的地址要使用绝对路径名
     当然也还有其他的协议族，用到再学习了
   - so_type 指定socket的类型，也就是上面讲到的so_type字段，比较常用的类型有：
     SOCK_STREAM
     SOCK_DGRAM
     SOCK_RAW
   - protocol 指定具体的协议，也就是指定本次通信能接受的数据包的类型和发送数据包的类型，常见的值有：
     IPPROTO_TCP，TCP协议
     IPPROTO_UDP，UPD协议
     0，如果指定为0，表示由内核根据so_type指定默认的通信协议

2. int **bind**(int sockfd, const struct sockaddr *addr, socklen_t addrlen);（**客户端**）bind函数就是给图三种so_pcb结构中的地址赋值的接口

   - sockfd   是调用socket()函数创建的socket描述符
   - addr     是具体的地址
   - addrlen  表示addr的长度

3. int **listen**(int sockfd, int backlog)；（**服务端**）告知内核在sockfd这个描述符上监听是否有连接到来，并设置同时能完成的最大连接数为backlog。当调用listen后，内核就会建立两个队列，一个SYN队列，表示接受到请求，但未完成三次握手的连接；另一个是ACCEPT队列，表示已经完成了三次握手的队列

   - sockfd 是调用socket()函数创建的socket描述符
   - backlog 已经完成三次握手而等待accept的连接数

4. int **accept**(int listen_sockfd, struct sockaddr *addr, socklen_t *addrlen)；（**服务端**）返回新的描述符connfd。这三个参数与bind的三个参数含义一致，不过，此处的后两个参数是传出参数。在使用listen函数告知内核监听的描述符后，内核就会建立两个队列，一个SYN队列，表示接受到请求，但未完成三次握手的连接；另一个是ACCEPT队列，表示已经完成了三次握手的队列。而accept函数就是从ACCEPT队列中拿一个连接，并生成一个新的描述符，新的描述符所指向的结构体so_pcb中的请求端ip地址、请求端端口将被初始化。从上面可以知道，accpet的返回值是一个新的描述符，我们姑且称之为new_sockfd。那么new_sockfd和listen_sockfd有和不同呢？不同之处就在于listen_sockfd所指向的结构体so_pcb中的请求端ip地址、请求端端口没有被初始化，而new_sockfd的这两个属性被初始化了。

5. int **connect**(int sockfd, const struct sockaddr *addr, socklen_t addrlen);（**客户端**）这三个参数和bind的三个参数类型一样，只不过此处strcut sockaddr表示对端公开的地址。三个参数都是传入参数。connect顾名思义就是拿来建立连接的函数，只有像tcp这样面向连接、提供可靠服务的协议才需要建立连接。

   

   ## 连接过程

   ![](C:\Users\XIONG\Pictures\IT\JAVA\JAVA_Socket\socket流程.png)

   ![](C:\Users\XIONG\Pictures\IT\JAVA\JAVA_Socket\连接过程.png)

   ![](C:\Users\XIONG\Pictures\IT\JAVA\JAVA_Socket\socket流程2.png)

   

# JAVA下Socket应用

## 服务端
```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

public class SocketServer {
    public static void main(String[] args)
    {
        String host = "127.0.0.1";
        int port = 30000;
        while (true)
        try {
            ServerSocket serverSocket = new ServerSocket(port);

            //accept()侦听并接受到此套接字的连接，此方法在连接传入之前一直阻塞
            Socket socketServer = serverSocket.accept();
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(socketServer.getInputStream(),"UTF-8"));
            String tempString;
            StringBuffer stringBuffer = new StringBuffer();
            while((tempString = bufferedReader.readLine()) != null){
                stringBuffer.append(tempString);
            }
            bufferedReader.close();
            socketServer.close();
            serverSocket.close();
            System.out.println(stringBuffer);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

```

## 客户端
```java

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.Socket;

public class SocketClient {
    public static void main(String[] args)
    {
        String host = "127.0.0.1";
        int port = 30000;

        try {
            Socket socketClient = new Socket(host, port);
            Writer writer = new OutputStreamWriter(socketClient.getOutputStream());
            writer.write("Hello1 1 "+"\n"+"  --From Client");
            writer.flush();
            writer.close();
            socketClient.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

```

## 半关闭的socket
我们是以行作为通信的最小数据单位，服务器端也是逐行进行处理的。但是我们在大多数场景下，通信的数据单位是多行的，这时候Socket的输出流如何表达输出的数据已经结束？
<br>在IO学习过程中提到过，如何要表示输出已经结束，则通过关闭输出流来实现，但是在socket中是行不通的，因为关闭socket，会导致无法再从该socket中读取数据了。为了解决这种问题，java提供了两个半关闭的方法：

1. shutdownInput():关闭该Socket的输入流，程序还可以通过该Socket的输出流输出数据。
2. shutdownOutput():关闭该Socket的输出流，程序还可以通过该Socket的输入流读取数据。
如果我们对同一个Socket实例先后调用shutdownInput和shutdownOutput方法，该Socket实例依然没有被关闭，只是该Socket既不能输出数据，也不能读取数据。适用于一次连接后关闭的场景。
