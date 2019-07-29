# 概念

CPU切分时间周期性的切换线程实现并发。JAVA的线程机制是抢占式的(周期性中断切换)，应该有意识的插入让步语句。

![](C:\Users\XIONG\Pictures\IT\JAVA\线程\线程状态.png)

# Thread

垃圾回收无法对这个对象进行回收，只能等其死亡

## sleep()

Tread.sleep(long)睡眠ms，交出CPU，不释放资源锁，处于阻塞状态
TimeUnit.SECEND.sleep(num)，以指定时间单位

## wait() [Object类]

Object.wait([long time])，交出CPU，释放锁，处于阻塞状态，当时间到或是notify()时唤醒
ject.wait([long time])，交出CPU，释放锁，处于阻塞状态，当时间到或是notify()时唤

## yield()

Thread.yield()放弃运行，进入就绪状态，让出CPU和资源锁

## join()

Thread.join()加入运行，外部调用**线程B**的方法的**线程A**被阻塞，让出CPU和资源，直到这个方法的所有者**线程B**运行结束

## notify()

通知一个线程获取锁，不一定马上唤醒线程

## Thread.currentTread()

获取当前线程的引用，与this有区别，new Thread(new MyThread())时，Thread.currentTread()为new Thread()对象，而this则是new MyThread()对象

## 线程池ThreadPoolExcutors

构造方法

```java
public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,TimeUnit unit,
        BlockingQueue<Runnable> workQueue,ThreadFactory threadFactory,RejectedExecutionHandler handler);
```

- **corePoolSize**：**核心池的大小**，这个参数跟后面讲述的线程池的实现原理有非常大的关系。在创建了线程池后，默认情况下，线程池中并没有任何线程，而是等待有任务到来才创建线程去执行任务，除非调用了prestartAllCoreThreads()或者prestartCoreThread()方法，从这2个方法的名字就可以看出，是预创建线程的意思，即在没有任务到来之前就创建corePoolSize个线程或者一个线程。默认情况下，在创建了线程池后，线程池中的线程数为0，当有任务来之后，就会创建一个线程去执行任务，当线程池中的线程数目达到corePoolSize后，就会把到达的任务放到缓存队列当中；
- **maximumPoolSize**：**线程池最大线程数**，这个参数也是一个非常重要的参数，它表示在线程池中最多能创建多少个线程；
- **keepAliveTime**：表示线程没有任务执行时最多保持多久时间会终止。默认情况下，只有当线程池中的线程数大于corePoolSize时，keepAliveTime才会起作用，直到线程池中的线程数不大于corePoolSize，即当线程池中的线程数大于corePoolSize时，如果一个线程空闲的时间达到keepAliveTime，则会终止，直到线程池中的线程数不超过corePoolSize。但是如果调用了allowCoreThreadTimeOut(boolean)方法，在线程池中的线程数不大于corePoolSize时，keepAliveTime参数也会起作用，直到线程池中的线程数为0；
- **unit**：参数keepAliveTime的时间单位，有7种取值，在TimeUnit类中有7种静态属性

TimeUnit.DAYS;               //天
TimeUnit.HOURS;             //小时
TimeUnit.MINUTES;           //分钟
TimeUnit.SECONDS;           //秒
TimeUnit.MILLISECONDS;      //毫秒
TimeUnit.MICROSECONDS;      //微妙
TimeUnit.NANOSECONDS;       //纳秒

```java
ExcutorService es = Excutors.newCachedThreadPool();//使用时新建一个线程
es.execute(Object obj);
es.shutdown;
```

```java
ExcutorService es = Excutors.newFixedThreadPool(int num);//创建num个线程，这几个线程将被复用
es.execute(Object obj);
es.shutdown;
```

```java
ExcutorService es = Excutors.newSingleThreadPool();//创建一个线程，排队复用
es.execute(Object obj);
es.shutdown;
```

## Callable接口

实现Runnable接口的线程run()方法不会返回值不可以抛出异常，而Callable的call()可以返回结果而且可以抛出异常。运行方法是call()，需要ExecutorService.submit(Callable实现类对象))调用Callable并返回FutureTask类(Future接口的实现类)。

- FutureTask.isDone()检查是否完成
- FutureTas.get()获取结果，这会使的其他线程被阻塞，直到该线程获得最终结果

```java
	MyCallable callable = new MyCallable(2000);  
	// 将Callable写的任务封装到一个由执行者调度的FutureTask对象 
    FutureTask<String> futureTask = new FutureTask<String>(callable);
	// 创建线程池并返回ExecutorService实例  
 	ExecutorService executor = Executors.newFixedThreadPool(2);   
    executor.execute(futureTask);  // 执行任务 
        while (true) {  
            try {  
                if(futureTas.isDone()){//  两个任务都完成  
                    System.out.println("Done");  
                    executor.shutdown();                          // 关闭线程池和服务   
                    return;  
                }  
                if(!futureTask.isDone()){ 
                    // 任务没有完成，会等待，直到任务完成  
                    System.out.println("FutureTask output="+futureTask.get());  
                }  
            } catch (InterruptedException | ExecutionException e) {  
                e.printStackTrace();  
            }catch(TimeoutException e){  
                //do nothing  
            }  
        }   
```



## 线程终止

### interrupt()

- 允许自行调用这个方法，其他线程调用的话会，可能会报SecurityException
- 对于处于阻塞状态的线程调用interrupt()，interrupt状态会被清除并报InerruptException()
- 如果被阻塞在Selector选择器中会被从选择器中返回，并标记为true
- 非以上情况会立即标记为true

### this.interrupted()
测试**当前线程**是否已经中断。线程的中断状态由**该方法清除**。换句话说，如果连续两次调用该方法，则第二次调用返回false。

### 终止阻塞状态的线程

通过try-catch捕获InterruptException来终止线程

- 对于循环体在try-catch内则直接终止退出循环
- 对于循环体在try-catch外则需要手动退出循环

### 终止运行状态的线程

通过“标记”的方式来终止

- **isInterrupt()**来获取是否被中断(通过Thread.Interrupt())设置标记
- 通过额外添加标记的方式类终止，设置中断标志
  设置volatile boolean stop = false 再通过设置stop标志，手动判断是否需要stop

### 综合

```java
@Override
public void run() {
    try {
        // 1. isInterrupted()保证，只要中断标记为true就终止线程。
        while (!isInterrupted()) {// 执行任务...}
    } catch (InterruptedException ie) {  
        // 2. InterruptedException异常保证，当InterruptedException异常产生时，线程被终止。
    }
}
```



# 并发同步

1. 原子性
2. 可见性
3. 有序性

## Synchronized

当对一个方法或者代码块使用它时，当一个线程获得了这个锁，那么其它的线程就会陷入挂起状态，在java中也就表现为sleep状态，我们都知道线程的挂起和运行时要转入操作系统的内核态的（与内核态对应的便是用户态），这样特别浪费cpu资源，所以这个重量级锁是名副其实的！

## Volatile

修饰的变量能够使得：

1. 使得其他线程对该变量缓存无效
2. 线程修改当前值时立即写入主存中

**保证可见性，不保证原子性**

## ReentrantLock重入锁

ReentrantLock rlock = new ReentrantLock()
rlock.lock() rlock.unlock()显示加解锁

### 中断响应

对于synchronized块来说，要么获取到锁执行，要么持续等待。而重入锁的中断响应功能就合理地避免了这样的情况。比如，一个正在等待获取锁的线程被“告知”无须继续等待下去，就可以停止工作了。

```java
import java.util.concurrent.locks.ReentrantLock;
ReentrantLock rlock = new ReentrantLock()
rlock.lockInterruptibly()  // 以可以响应中断的方式加锁
if (rlock.isHeldByCurrentThread()) lock1.unlock();  //判断获取锁是否已由当前线程占用
```

### 锁申请等待限时

- tryLock() 
  线程尝试加锁，如果没有被其他线程加锁，则使用，否则返回false。
- tryLock(long timeout, TimeUtil unit) 
  在指定时长内获取到锁则继续执行，如果等待指定时长后还没有获取到锁则返回false

### 公平锁

公平锁，就是按照时间先后顺序，使先等待的线程先得到锁，而且，公平锁不会产生饥饿锁，也就是只要排队等待，最终能等待到获取锁的机会。
<br>ReentrantLock rlock = new ReentrantLock(true)获取公平锁

## CountDownLatch

> Java的concurrent包里面的CountDownLatch其实可以把它看作一个计数器，只不过这个计数器的操作是原子操作，同时只能有一个线程去操作这个计数器，也就是同时只能有一个线程去减这个计数器里面的值。可以向CountDownLatch对象设置一个初始的数字作为计数值，任何调用这个对象上的await()方法都会阻塞，直到这个计数器的计数值被其他的

```java
package java.util.concurrent;
import java.util.concurrent.locks.AbstractQueuedSynchronizer;
public class CountDownLatch {
   
    private static final class Sync extends AbstractQueuedSynchronizer {
        private static final long serialVersionUID = 4982264981922014374L;

        Sync(int count) {
            setState(count);
        }

        int getCount() {
            return getState();
        }

        protected int tryAcquireShared(int acquires) {
            return (getState() == 0) ? 1 : -1;
        }

        protected boolean tryReleaseShared(int releases) {
            // Decrement count; signal when transition to zero
            for (;;) {
                int c = getState();
                if (c == 0)
                    return false;
                int nextc = c-1;
                if (compareAndSetState(c, nextc))
                    return nextc == 0;
            }
        }
    }

    private final Sync sync;

    public CountDownLatch(int count) {
        if (count < 0) throw new IllegalArgumentException("count < 0");
        this.sync = new Sync(count);
    }

    public void await() throws InterruptedException {
        sync.acquireSharedInterruptibly(1);
    }

    public boolean await(long timeout, TimeUnit unit)
        throws InterruptedException {
        return sync.tryAcquireSharedNanos(1, unit.toNanos(timeout));
    }

    public void countDown() {
        sync.releaseShared(1);
    }

   
    public long getCount() {
        return sync.getCount();
    }

    public String toString() {
        return super.toString() + "[Count = " + sync.getCount() + "]";
    }
}


```

### 使用

- CountDownLatch latch = new CountDownLatch(3); 

声明一个计数值的类

- this.downLatch.await(); 

调用用这个类的方法线程会阻塞等待，直到计数完成

- this.downLatch.countDown();

调用这个方法为计数值减一

理所当然CountDownLatch是线程安全的，它的减一操作是原子操作，一次只能被一个线程调用。

# 底层实现

``` java
//主要的线程方法
private static native void registerNatives();
public static native Thread currentThread();
public static native void yield();
public static native void sleep(long millis) throws InterruptedException;
public final native boolean isAlive(); 
```
这些主要的线程方法是**native**，java的线程实现是由操作系统来实现的。

## 操作系统实现线程

操作系统实现线程的原理有以下三种方式：

- **用户级线程**
- **内核级线程**
- **用户级线程 + 内核级线程，混合实现**

## 用户级线程



![用户级线程](I:\Mydoc\pic_图片\用户级线程.png)

​		用户线程指的是建立在**用户空间**的线程库上，系统内核不能感知线程存在的实现。用户线程的建立、同步、销毁和调度完全在**用户态**中完成，不需要内核的帮助。如果程序实现得当，这种线程不需要切换到内核态，因此操作可以是非常快速且低消耗的，并且可以支持规模更大的线程数量。

​		[用户级线程与内核级线程介绍与对比](https://blog.csdn.net/u013568373/article/details/93468678)

## 内核级线程

![](I:\Mydoc\pic_图片\内核级线程.png)

​		内核线程就是直接由操作系统内核支持的线程，这种线程由内核来完成线程切换，内核通过操纵调度器对线程进行调度，并负责将线程的任务映射到各个处理器上。每个内核线程可以视为内核的一个分身。

​		程序一般不会直接去使用内核线程，而是去使用内核线程的一种高级接口——**轻量级进程**（**Light Weight Process**，**LWP**），轻量级进程就是我们通常意义上所讲的线程，由于每个轻量级进程都由一个内核线程支持，因此只有先支持内核线程，才能有轻量级进程。这种轻量级进程与内核线程之间 **1 ： 1 的关系**称为一对一的线程模型

由于有内核线程的支持，每个轻量级进程都成为一个独立的调度单元，即使有一个轻量级进程在系统调用中阻塞了，也不会影响整个进程继续工作，但是轻量级进程具有它局限性，主要有如下两点:

- 线程的创建、销毁等操作，都需要进行**系统调用**，而系统调用的代价相对较高，需要**在用户态和内核态之间来回切换**。
- 每个**轻量级进程**都需要有一个**内核线程的支持**，因此轻量级进程要消耗一定的内核资源（比如内核线程的栈空间），因此一个系统支持轻量级线程的数量是有限的。

## Java 线程的实现

​		在 JDK 1.2 中，线程模型替换为**基于操作系统原生线程模型**来实现，因此，在目前的 JDK 版本中，操作系统支持怎样的线程模型，在很大程度上决定了 Java 虚拟机的线程是怎样映射的，这点在不同平台上没有办法达成一致，虚拟机规范中也并未限定 Java 线程需要使用哪种线程模型来实现。

​		举个例子，对于 Sun JDK 来说，它的 Windows 版与 Linux 版都是使用**一对一的线程模型**实现的，**一条 Java 线程就是映射到一条轻量级进程之中**，因为 Windows 和 Linux 系统提供的线程模型就是一对一的。

