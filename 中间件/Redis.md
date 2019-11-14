# 安装
## 源码安装
### 1. 下载源码
```sh
wget http://download.redis.io/releases/redis-3.2.1.tar.gz

```

### 2. 编译
```sh

cd redis-3.2.1/src
make

```
### 3. 启动
```sh
cd src/
./redis-server ../redis.conf # 表示已redis.conf配置开启redis服务

```
- src中redis-server为服务端
- src中redis-cli为客户端

#### 配置文件
```conf

#数据目录，数据库的写入会在这个目录。rdb、aof文件也会写在这个目录
dir /var/lib/redis

#是否在后台执行，yes：后台运行；no：不是后台运行（老版本默认）
daemonize yes

#redis的进程文件
pidfile /var/run/redis/redis-server.pid

#redis监听的端口号。
port 6379

#指定 redis 只接收来自于该 IP 地址的请求，如果不进行设置，那么将处理所有请求
bind 127.0.0.1

#指定了记录日志的文件。空字符串的话，日志会打印到标准输出设备。后台运行的redis标准输出是/dev/null。
logfile /var/log/redis/redis-server.log

#指定了服务端日志的级别。级别包括：debug（很多信息，方便开发、测试），verbose（许多有用的信息，但是没有debug级别信息多），notice（适当的日志级别，适合生产环境），warn（只有非常重要的信息）
loglevel notice

#默认redis使用的是rdb方式持久化，这种方式在许多应用中已经足够用了。但是redis如果中途宕机，会导致可能有几分钟的数据丢失，根据save来策略进行持久化，Append Only File是另一种持久化方式，可以提供更好的持久化特性。Redis会把每次写入的数据在接收后都写入 appendonly.aof 文件，每次启动时Redis都会先把这个文件的数据读入内存里，先忽略RDB文件。
appendonly no

```
#### 服务配置
由于是通过源码编译安装所以不会被配置到service 和 chkconfig中,需要自己编写服务脚本

##### 脚本
在redis/util/中redis_init_script文件复制到/etc/int.d/内重命名如redisd
```
#!/bin/sh
# chkconfig:   2345 90 10
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

# 端口 
REDISPORT=6379

# 服务端
EXEC=/usr/local/bin/redis-server

# 客户端
CLIEXEC=/usr/local/bin/redis-cli

# 进程文件 在配置文件中有配置
PIDFILE=/var/run/redis_${REDISPORT}.pid

# 配置文件
CONF="/usr/local/redis-3.2.1/redis.conf"

case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
                $EXEC $CONF
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."
                $CLIEXEC -p $REDISPORT shutdown
                while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac

```
- # chkconfig:   2345 90 10 修改运行级别

配置完成后
```s
#设置为开机自启动服务器
chkconfig redisd on

#打开服务
service redisd start

#关闭服务
service redisd stop
```
## Docker安装

```s
docker run -v /myredis/conf/redis.conf:/usr/local/etc/redis/redis.conf --name myredis -d -p 6379:6379 redis redis-server /usr/local/etc/redis/redis.conf

```

# Redis的使用

## Spring下的使用
### RedisTemplate
RedisTemplate主要步骤
- 创建jedis连接池

- 连接池中获取jedis连接

- 使用jedis来进行实际操作
源码:
## 数据库异步缓存

### Spring Boot Redis增删改查

Lettuce和Jedis的都是连接Redis Server的客户端程序。2.X版本默认Lettuce
<br>Jedis在实现上是直连redis server，多线程环境下非线程安全，除非使用连接池，为每个Jedis实例增加物理连接。
<br>Lettuce基于Netty的连接实例（StatefulRedisConnection），可以在多个线程间并发访问，且线程安全，满足多线程环境下的并发访问，同时它是可伸缩的设计，一个连接实例不够的情况也可以按需增加连接实例。

# 消息队列
Redis使用双向链表实现列表,可以直接使用Redis的List实现消息队列，只需简单的两个指令
- lpush(尾部插入)和rpop(头部取出)
- rpush(头部插入)和lpop(尾部取出)
- brpop(阻塞式头部取出)和blpop(阻塞式尾部取出)，相对于非阻塞，这个命令会阻塞连接直到列表内有信息可以取

## 生产者消费者模式
生产者将消息放入队列中，指定消费者取获取。一个消息只会被一个消费者获取。
<br>该方法是借助redis的list结构实现的。Producer调用redis的lpush往特定key里塞入消息，Consumer调用brpop去不断监听该key
- 监听者

自己实现org.springframework.data.redis.connection.MessageListener接口生成监听者
```java
package com.definesys.dboperationserver.redismq;

import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;

public class insertListener implements MessageListener {
    @Override
    public void onMessage(Message message, byte[] bytes) {
        //处理该信息逻辑方法，bytes是topic message是消息
        System.out.println(new String(bytes) + "主题发布：" + new String(message.getBody()));
    }
}

```
- 绑定监听者与topic

```java
package com.definesys.dboperationserver.config;

import com.definesys.dboperationserver.redismq.deleteListener;
import com.definesys.dboperationserver.redismq.insertListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;

@Configuration
public class RedisMqConfig {
    @Autowired
    private JedisConnectionFactory jedisConnectionFactory;

    @Bean
    public RedisMessageListenerContainer redisMessageListenerContainer() {

        RedisMessageListenerContainer container = new RedisMessageListenerContainer();

        container.setConnectionFactory(jedisConnectionFactory);

        /**
         * 添加监听者监听不同的主题的发布
         * */
        container.addMessageListener(new insertListener(), new PatternTopic("insert"));
        container.addMessageListener(new deleteListener(),new PatternTopic("delete"));

        return container;
    }
    @Bean
    public StringRedisTemplate stringRedisTemplate(RedisConnectionFactory redisConnectionFactory) {
        return new StringRedisTemplate(redisConnectionFactory);
    }
}

```
- 消息发布者
```java
package com.definesys.dboperationserver.redismq;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class Publisher {
    @Autowired
    StringRedisTemplate redisTemplate;
    public void publish(String topic, Object message) {
        // 该方法封装的 connection.publish(rawChannel, rawMessage);
        redisTemplate.convertAndSend(topic, message);
    }
}

```
## 发布者订阅者模式

# 常用命令
## key操作
### keys 匹配模式
- KEYS * 匹配数据库中所有 key 。
- KEYS h?llo 匹配 hello ， hallo 和 hxllo 等。
- KEYS h*llo 匹配 hllo 和 heeeeello 等。
- KEYS h[ae]llo 匹配 hello 和 hallo ，但不匹配 hillo 。
- 特殊符号用 \ 隔开

### expire key seconds 
设置过期时间，单位秒 pexpire 毫秒单位
- set或是getset 时间不会被改变
- rename key key1 也不会改变时间，如果rename的key1之前存在且有时间，那么时间也会被key覆盖
- persist key 会移除过期时间

### expireat key date (时间戳)
expireat设置过期时间戳，秒单位。pexpireat，毫秒单位。



# 数据类型
## String:
Strings 数据结构是简单的key-value类型，value其实不仅是String，也可以是数字。
常用命令:set,get,decr,incr,mget,appande追加等

## Hash hash表
定义一个hash是一个string类型的key和value的映射表，类似HashMap。
- hset FieldName key value  向filename这个表内插入key value。
- hgetall FileName 获取这个表所有的key
- hget FileName key 获取表的key对应的value



## Set 集合类型

set集合类型，没有重复值。key -> values。
- sadd SetName value1 value2 .... 往setname中加入值
- smembers SetName 获取SetName中的成员值
- sismember SetName value 判断是否是SetName包含value
- srem SetName value 删除SetName的value元素

## Zset 排序集合
对集合的值有顺序编号
- zadd ZSetName 1 value 加入一个值
- zincrby ZSetName 增量(正负) value 原value的权值加上增量



# 使用lua脚本

可以使用lua脚本来解决一些需要**保证原子性**的问题，而且lua脚本可以缓存在redis服务器上，会增加性能。



# 应用

## 分布式锁

[【分布式缓存系列】Redis实现分布式锁的正确姿势](https://www.cnblogs.com/zhili/p/redisdistributelock.html)

[基于Redis的分布式锁到底安全吗（上）？](https://mp.weixin.qq.com/s?__biz=MzA4NTg1MjM0Mg==&mid=2657261514&idx=1&sn=47b1a63f065347943341910dddbb785d&chksm=84479e13b3301705ea29c86f457ad74010eba8a8a5c12a7f54bcf264a4a8c9d6adecbe32ad0b&mpshare=1&scene=23&srcid=1004XqCveZ8C5IDjoB9ZXbWj#rd)

[基于Redis的分布式锁到底安全吗（下）？](https://mp.weixin.qq.com/s?__biz=MzA4NTg1MjM0Mg==&mid=2657261521&idx=1&sn=7bbb80c8fe4f9dff7cd6a8883cc8fc0a&chksm=84479e08b330171e89732ec1460258a85afe73299c263fcc7df3c77cbeac0573ad7211902649&mpshare=1&scene=23&srcid=1004J1UMhLJLs1v4PkTOCF3h#rd)

1. 需求背景

   > 分布式下更新token，该token被不同节点的多线程访问

2. 分析

   - token更新，保证每个节点的线程拿到的token是有效的。
   - 分布式锁，用于不同节点间锁
   - 本地锁，用于节点本地线程的锁

3. 实现

   >- 使用脚本，保证设k-v操作（加锁）和删除k-v操作（解锁）都是原子性。
   >- 设k-v操作（加锁）加上过期时间（过期自动删除），避免死锁。
   >- ThreadLocal用来保存每个线程的v，保证自己的锁自己解。（ThreadLocal在不同的线程栈有自己的拷贝，保证每个线程都有自己的值）

   1. redis分布式锁

   ```java
   package com.xiong.redis.lock;
   
   import com.google.common.io.Resources;
   import com.xiong.redis.RedisUtil;
   import redis.clients.jedis.Jedis;
   import redis.clients.jedis.JedisPool;
   
   import java.io.*;
   import java.nio.charset.Charset;
   import java.util.Arrays;
   import java.util.Random;
   import java.util.UUID;
   import java.util.concurrent.TimeUnit;
   
   /**
    * @author linsongxiong
    * @Description:
    * @date 2019/11/08 10:28
    **/
   public class RedisLock {
       // lock 锁 key
       private static final String LOCK_KEY_PREFIX = "LOCK_KEY:";
       //尝试分布式锁超时时间
       private static final int TRY_REDISLOCK_OVERTIME = 10;
       // 用于存储拿lock锁的value，每个线程私有，用自己每个线程自己的value去解锁，自己的锁自己解
       private ThreadLocal<String> local = new ThreadLocal<>();
       // 加锁lua脚本
       private static String lockScript = null;
       // 解锁lua脚本
       private static String unlockScript = null;
       private static JedisPool jedisPool;
       static {
           try {
               jedisPool = RedisUtil.getJedisPool();
               String lockScriptPath = Resources.getResource("lua/lock.lua").getFile();
               String unlockScriptPath = Resources.getResource("lua/unlock.lua").getFile();
               lockScript = getLuaScriptStr(lockScriptPath);
               unlockScript = getLuaScriptStr(unlockScriptPath);
           }catch (IOException ioe){
               System.out.println(ioe.getMessage());
           } catch (Exception e){
               System.out.println(e.getMessage());
           }
           System.out.println("redis init success");
       }
       /**
        * 有超时设置的加锁
        */
       public boolean lock() {
           // 尝试加锁
           long tryLockTimeNanoOverTime = TimeUnit.SECONDS.toNanos(TRY_REDISLOCK_OVERTIME);
           long tryLockTimeStart = System.nanoTime();
         	// 未超时时间内循环尝试加锁
           while (System.nanoTime() - tryLockTimeStart < tryLockTimeNanoOverTime){
               if(tryLock()){
                   return true;
               }
             	// 拿不到redislock锁，休眠50-60毫秒再试
               try {
                   TimeUnit.MILLISECONDS.sleep(50l+new Random().nextInt(10));
               }catch (InterruptedException ie){
                   Thread.currentThread().interrupt();
                   System.out.println("休眠被打断");
               }
           }
           return false;
       }
       /**
        * 获取锁
        * @return 是否成功加锁
        */
       public boolean tryLock() {
   
           //产生随机值，标识本次锁编号
           String uuid = UUID.randomUUID().toString();
           Jedis jedis = null;
           Long result = null;
           try {
               // redisKey:我们使用key来当锁
               // uuid:唯一标识，代表锁的身份信息
             	jedis = jedisPool.getResource();
               result = (Long)jedis.eval(lockScript,Arrays.asList(LOCK_KEY_PREFIX),Arrays.asList(uuid));
               //设值成功 抢到了锁
           }catch ( Exception e){
               System.out.println(e.getMessage());
           }finally {
               if (jedis != null){
                   jedis.close();
               }
           }
           if (result == 1L) {
               local.set(uuid);//抢锁成功，把锁标识号记录入本线程--- Threadlocal
               return true;
           }
           //抢redis锁失败
           return false;
       }
       /**
        * 解锁
        */
       public void unlock() {
           Jedis jedis = null;
           try {
               jedis =  jedisPool.getResource();
               Long result = (Long) jedis.eval(unlockScript,Arrays.asList(LOCK_KEY_PREFIX),Arrays.asList(local.get()));
           } finally {
               if (jedis != null){
                   jedis.close();
               }
               local.remove();
           }
       }
     	/**
     	 * 讲脚本.lua 读出
     	 */
       private static String getLuaScriptStr(String luaFilePath) throws IOException {
           File file = new File(luaFilePath);
           InputStreamReader isr= null;
           isr = new InputStreamReader(new FileInputStream(file), Charset.forName("UTF-8"));
           BufferedReader br = new BufferedReader(isr);
           String data = null;
           StringBuilder sb = new StringBuilder();
           while((data = br.readLine())!= null){
               sb.append(data+"\n");
           }
           br.close();
           isr.close();
           return sb.toString();
       }
   }
   
   ```

   2. lua脚本

   ```lua
   # lock.lua
   if redis.call("set", KEYS[1], ARGV[1], "EX", 90, "NX") then
       return 1
   else
       return 0
   end
   
   # unlock.lua
   if redis.call("get",KEYS[1]) == ARGV[1] then
       return redis.call("del",KEYS[1])
   else
       return 0
   end
   ```

   3. 调用

   简单模拟本地单机使用redis锁。只使用redis锁，本地jvm锁就不用啦。

   ```java
   package com.xiong.redis;
   
   import com.xiong.redis.lock.RedisLock;
   
   import java.util.concurrent.TimeUnit;
   
   /**
    * @author linsongxiong
    * @Description:
    * @date 2019/11/06 10:10
    **/
   public class App {
       private static int count = 0;
       private static RedisLock redisLock = new RedisLock();
       public static class Worker implements Runnable{
           @Override
           public void run() {
               try {
                   TimeUnit.NANOSECONDS.sleep(100000+((int) (Math.random() * 100)));
                   if (redisLock.lock()){
                       System.out.print(Thread.currentThread().getName()+" count:"+(++count)+" ");
                   }else {
                       System.out.print(Thread.currentThread().getName()+" sorry 超时失败 ");
                   }
               }catch (Exception e){
                   System.out.println(e.getMessage());
               }finally {
                   System.out.println(Thread.currentThread().getName()+" 运行结束");
                   redisLock.unlock();
               }
   //            try {
   //            TimeUnit.NANOSECONDS.sleep(100000+((int) (Math.random() * 100)));
   //                System.out.print(Thread.currentThread().getName()+" count:"+(++count)+" ");
   //
   //            }catch (Exception e){
   //                System.out.println(e.getMessage());
   //            }finally {
   //                System.out.println(Thread.currentThread().getName()+" 运行结束");
   //            }
           }
       }
       public static void main(String[] args) {
           for (int i = 0;i<20;i++){
               new Thread(new Worker()).start();
           }
       }
   }
   
   ```

   





# 原理及实现