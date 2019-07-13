# 介绍

[RabbitMQ](https://www.rabbitmq.com/) 2007年发布，是一个在[AMQP](http://www.amqp.org/)(高级消息队列协议)基础上完成的，可复用的企业消息系统，是当前最主流的 **消息中间件** 之一。由以高性能、健壮以及可伸缩性出名的 **Erlang** 写成，因此也是继承了这些优点。并且RabbitMQ是一个是一个开源的消息代理和队列服务器。

# 作用
- 解耦：通过基于数据的接口层，让不同的模块各自扩展修改，实现解耦
- 冗余：MQ 可以把数据进行持久化直到它们被完全处理，规避了数据丢失的风险
- 扩展性：通过解耦可以方便增加应用的处理过程，从而提高消息入队和处理的效率，实现扩展
- 削峰：MQ可以支撑关键组件支撑突发访问压力，缓冲上下游流量差，实现削峰
- 可恢复性：部分组件失效时，加入消息队列的消息仍然可以在系统恢复后处理
- 顺序保证：MQ支持一定的顺序性
- 缓冲：MQ 通过一个缓冲层来帮助任务高效执行
- 异步通信：把不需要立即处理的消息通过MQ进行异步处理

# 环境配置
需要Erlang环境
## 1. 安装依赖 
yum install gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel git
## 2. 解压第下载的源代码
```shell
wget http://erlang.org/download/otp_src_19.1.tar.gz
tar -xzf otp_src_19.1.tar.gz
```
## 3. 安装erlang
```
mv otp_src_19.1 /usr/local/erlang
cd /usr/local/erlang
./otp_build autoconf
./configure && make && sudo make install
ln -s /usr/local/erlang/bin/erl /usr/local/bin/
```
## 4. 验证
```
erl
```

# 安装RabbitMQ
## 下载
```
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server-generic-unix-3.6.10.tar.xz
xz -d rabbitmq-server-generic-unix-3.6.10.tar.xz
tar -xf rabbitmq-server-generic-unix-3.6.10.tar
mv rabbitmq_server-3.6.10 /usr/local/rabbitmq

```
## 修改配置文件
```conf
# vi /etc/profile
# 在文件的末尾添加

#set rabbitmq
export PATH=$PATH:/usr/local/rabbitmq/sbin
# 设置开机自动启动
/usr/local/rabbitmq/sbin/rabbitmq-server -detached

# source /etc/profile
```

设置local权限
<br> chmod +x /etc/rc.d/rc.local

```conf
vi /etc/rc.d/rc.local

# start rabbitmq
/usr/local/rabbitmq/sbin/rabbitmq-server -detached

```
## 使用rpm安装
```
[erlang_21](https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_21.0-1~centos~7_amd64.rpm)

[rabbitmq-server-3.7.7-1.el7.noarch.rpm](https://dl.bintray.com/rabbitmq/all/rabbitmq-server/3.7.7/rabbitmq-server-3.7.7-1.el7.noarch.rpm)

```
## 使用rabbitmqctl管理，常用的命令有：
```
rabbitmq-server -detached  # 使用守护进程方式打开
rabbitmq-server start  # 使用阻塞方式启动
rabbitmqctl stop  # 关闭rabbitmq
rabbitmqctl reset  # 清空队列
rabbitmqctl list_users  # 查看后台管理员名单
rabbitmqctl list_queues  # 查看当前的所有的队列
rabbitmqctl list_exchanges  # 查看所有的交换机
rabbitmqctl list_bindings  # 查看所有的绑定
rabbitmqctl list_connections  # 查看所有的tcp连接
rabbitmqctl list_channels  # 查看所有的信道
rabbitmqctl stop_app  # 关闭应用
rabbitmqctl start_app # 打开应用
rabbitmqctl status # 查看状态
rabbitmq-plugins enable rabbitmq_management #安装插件 

```
### status
```yml
[{pid,3086},   # rabbitmq服务运行的进程ID
 {running_applications,
     [{rabbit,"RabbitMQ","3.6.10"},
      {ranch,"Socket acceptor pool for TCP protocols.","1.3.0"},
      {ssl,"Erlang/OTP SSL application","8.2"},
      {public_key,"Public key infrastructure","1.4.1"},
      {asn1,"The Erlang ASN1 compiler version 5.0","5.0"},
      {os_mon,"CPO  CXC 138 46","2.4.2"},
      {rabbit_common,
          "Modules shared by rabbitmq-server and rabbitmq-erlang-client",
          "3.6.10"},
      {syntax_tools,"Syntax tools","2.1.2"},
      {xmerl,"XML parser","1.3.15"},
      {crypto,"CRYPTO","4.0"},
      {mnesia,"MNESIA  CXC 138 12","4.15"},
      {compiler,"ERTS  CXC 138 10","7.1"},
      {sasl,"SASL  CXC 138 11","3.0.4"},
      {stdlib,"ERTS  CXC 138 10","3.4"},
      {kernel,"ERTS  CXC 138 10","5.3"}]},
 {os,{unix,linux}},
 {erlang_version,
     "Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:64] [hipe] [kernel-poll:true]\n"},
 {memory,  # 内存
     [{total,56444960},  # 总共消耗的内存，单位字节
      {connection_readers,0},  # tcp订阅连接消耗
      {connection_writers,0},  # tcp发布者连接消耗
      {connection_channels,0}, # 信道消耗
      {connection_other,0},    # 其他消耗
      {queue_procs,2840},      # 队列进程消耗
      {queue_slave_procs,0},   # 队列子进程消耗
      {plugins,0},             # 插件消耗
      {other_proc,22726336},   # 其他进程消耗
      {mnesia,60944},          
      {metrics,184544},
      {mgmt_db,0},
      {msg_index,45048},       # 消息标记
      {other_ets,1695784},
      {binary,94472},         # 一些被引用的数据
      {code,21374813},        # 代码
      {atom,891849},
      {other_system,9549962}]},
 {alarms,[]},
 {listeners,[{clustering,25672,"::"},{amqp,5672,"::"}]},  # mq监听端口5672，erlang端口25672
 {vm_memory_high_watermark,0.4},  # 开启流控的内存阀值
 {vm_memory_limit,6568098201},    # 消息持久化阀值
 {disk_free_limit,50000000},      # 磁盘开启流控阀值
 {disk_free,48187891712},         # 磁盘空闲量
 {file_descriptors,  # 文件句柄
     [{total_limit,924},  # 文件句柄上限
     {total_used,2},      # 已使用
     {sockets_limit,829}, # 允许的TCP连接上限
     {sockets_used,0}]},  # 已使用连接数
 {processes,       
    [{limit,1048576},     # 允许的最大进程数
    {used,156}]},         # 已使用进程数
 {run_queue,0},           # 运行的队列数
 {uptime,97},             
 {kernel,{net_ticktime,60}}]

```
## 开放端口
### 4369 – erlang发现口

### 5672 – client端通信口

### 15672 – 管理界面ui端口

### 25672 – server间内部通信口
```s
firewall-cmd --zone=public --add-port=15672/tcp --add-port=5672/tcp --permanent
firewall-cmd --reload # 重新载入防火墙
```
## 用户管理
### 1. 创建与授权 
```
rabbitmqctl add_user root root  //添加用户，后面两个参数分别是用户名和密码
rabbitmqctl set_permissions -p / username ".*" ".*" ".*"  //添加权限
# rabbitmqctl set_permissions -p / root ".*" ".*" ".*"
rabbitmqctl set_user_tags username administrator  //修改用户角色,将用户设为管理员

```
#### 权限说明：
rabbitmqctl set_permissions [-pvhostpath] {user} {conf} {write} {read}
Vhostpath：Vhost路径。
user：用户名。
Conf：一个正则表达式match哪些配置资源能够被该用户访问。
Write：一个正则表达式match哪些配置资源能够被该用户读。
Read：一个正则表达式match哪些配置资源能够被该用户访问。

### 2. 删除与修改
```
删除用户：rabbitmqctl delete_user username
改密码: rabbimqctl change_password {username} {newpassword}
设置用户角色：rabbitmqctl set_user_tags {username} {tag ...}

```

## UI界面
需要添加rabbitmq_management插件
```
rabbitmq-plugins enable rabbitmq_management
```
# Docker安装RabbitMQ
## 运行容器
``` s
docker run -d  --name rabbitMQ3 -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=root -p 5671:5671  -p 5672:5672 --p 4369:4369 -p 25672:25672 -p 15671:15671 -p 15672:15672 rabbitmq:3-management

```
## 开放端口
```s
firewall-cmd --zone=public --add-port=5672/tcp --add-port=15672/tcp --permenant && firewall-cmd --reload 
```

# 原理介绍

![](C:\Users\XIONG\Pictures\IT\RabbitMQ\RabbitMQ的模型架构.png)

## 概念

主要四个概念: **消息产生者**，**交换器**， **队列**，**消息接收者**。比传统的消息队列多了交换器，这样样发消息者和队列就没有直接联系, 转而变成发消息者把消息给交换器, 交换器根据调度策略再把消息再给队列。

### 交换机

交换机的功能主要是接收消息并且转发到绑定的队列，交换机不存储消息，在启用ack模式后，交换机找不到队列会返回错误。交换机有四种类型：Direct, Topic, Headers，Fanout

- Direct：direct 类型的行为是"先匹配, 再投送". 即在绑定时设定一个 **routing_key**, 消息的**routing_key** 完全匹配时, 才会被交换器投送到绑定的队列中去.
- Topic：按规则模糊匹配转发消息（最灵活），“.”分割单词，"*"匹配一个任意单词，"#"匹配多个或0个单词。
- Fanout：交换机转发消息到所有绑定到他的队列。
- Headers：设置header attribute参数类型，自定义匹配规则的类型的交换机，其他的是字符串匹配规则。

### 虚拟主机(vhost)

创建用户时，会指定用户能访问一个虚拟机，并且该用户只能访问该虚拟机下的队列和交换机，如果没有指定，默认的是”/”;一个rabbitmq服务器上可以运行多个vhost，以便于适用不同的业务需要，这样做既可以满足权限配置的要求，也可以避免不同业务之间队列、交换机的命名冲突问题，因为不同vhost之间是隔离的。



### binding_key

交换机与队列的绑定规则，即binding_key对应队列。

### routing_key

消息发送到队列的路由规则，即routing_key匹配binding_key.

# 工作模式

## Simple模式

![](C:\Users\XIONG\Pictures\IT\RabbitMQ\simple_pattern.png)

这个模式就是一个生产者，一个消费者。用这个模式来大体的了解RabbitMQ Client的使用方法。

Producer

~~~java

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import xiong.RabbitMQDemo.config.ConnectionConfig;

public class SimpleSender{
    public static String QueueName = "simple_queue_1";
    public static void main(String[] args) throws Exception
    {
        Connection connection = ConnectionConfig.getConnection();
        Channel channel = connection.createChannel();
        //声明队列
        /**
         *  队列名
         *  是否持久化
         *  是否排外，即只允许该channel访问该队列，true的话用于一个队列只能有一个消费者来消费的场景
         *  是否自动删除  消费完删除
         *  其他属性
         */
        channel.queueDeclare(QueueName, false, false, false, null);
        String message = "Hello I am simple message";
        //消息内容
        /**
         * 交换机
         * 队列名
         * 其他属性  路由
         * 消息body
         */ //默认exchange是空字符""
        channel.basicPublish("", QueueName,null,message.getBytes());
        channel.close();
        connection.close();
    }

}

~~~



Consumer

~~~java

import com.rabbitmq.client.*;
import xiong.RabbitMQDemo.config.ConnectionConfig;

public class SimpleConsumer {
    public static String QueueName = "simple_queue_1";
    public static void main(String[] args) throws Exception
    {
        Connection connection = ConnectionConfig.getConnection();
        Channel channel = connection.createChannel();
        channel.queueDeclare(QueueName, false, false, false, null);
        DeliverCallback deliverCallback = (consumerTag, delivery) -> {
            String message = new String(delivery.getBody(), "UTF-8");
            System.out.println("收到消息: " + message);
        };
        channel.basicConsume(QueueName, true, deliverCallback, consumerTag -> { });
    }
}
~~~



## Work模式

![](C:\Users\XIONG\Pictures\IT\RabbitMQ\work_pattern.png)

一个队列有多个消费者，这些消费者竞争消费，消息只被一个消费者完成(并不是完全只被一个消费者消费，如果一个消费者无应答会被重新被其他消费者消费)。

通过message acknowledgments (消息确认机制)和 prefetchCount (消息预取设为1) 来实现Work模式。

Producer

```java
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import xiong.RabbitMQDemo.config.ConnectionConfig;

public class Task{
    public static String QUEUE_NAME = "work_queue";
    public static void main(String[] args) throws Exception
    {
        Connection connection = ConnectionConfig.getConnection();
        Channel channel = connection.createChannel();
        channel.queueDeclare(QUEUE_NAME, true, false, false, null);
        for(int i = 0;i<10;i++)
        {
            channel.basicPublish("", QUEUE_NAME,null,String.valueOf(i).getBytes());
        }
        System.out.println("Work Task 执行完毕！");
        channel.close();
        connection.close();
    }
}

```

Consumer

```java

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.DeliverCallback;
import xiong.RabbitMQDemo.config.ConnectionConfig;
public class Worker {
    public static String QUEUE_NAME = "work_queue";
    public static void main(String[] args)throws Exception
    {
        Connection connection = ConnectionConfig.getConnection();
        Channel channel = connection.createChannel();
        channel.queueDeclare(QUEUE_NAME, true, false, false, null);
        
        //该消费者在接收到队列里的消息但没有返回确认结果之前,它不会将新的消息分发给它。
        channel.basicQos(1);
        DeliverCallback deliverCallback = (consumerTag, delivery) -> {
            
            String message = new String(delivery.getBody(), "UTF-8");
            System.out.println("收到消息:" + message);
            try {
                Thread.sleep(2000);
            }catch (Exception e)
            {
                System.out.println(e.getMessage());
            }finally {
                //手动发送确认
                channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);
            }
        };
        // 第二个参数时是否自动发送ACK确认
        channel.basicConsume(QUEUE_NAME, false, deliverCallback, consumerTag -> {});
    }

}

```

## 发布订阅模式

![](C:\Users\XIONG\Pictures\IT\RabbitMQ\publisher_pattern.png)

与Work模式不同，队列发送消息给所有的消费者(实际上：每个消费者对应一个临时队列，每个临时队列队列fanout交换机)。

Publisher

```java

```

Consumer

```java

```



## 路由模式

![](C:\Users\XIONG\Pictures\IT\RabbitMQ\routing_pattern.png)

Exchange与队列绑定，并指定binding_key，生产者发送包含routing_key的消息给Exchange，Exchange通过消息的routing_key与binding_key匹配，送到对应的队列上。

- key最长255字节



## Topic模式

![](C:\Users\XIONG\Pictures\IT\RabbitMQ\topic_pattern.png)

与路由模式类似，routing_key与binding_key的匹配是使用表达式匹配。

- 每个单词以 . 隔开
- *表示一个单词
- #表示任意多个单词



