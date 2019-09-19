# JDK
JDK(Java Development Kit) 包涵bin、include、lib、 jre。有这样一个关系，JDK包含JRE，而JRE包 含JVM。是java开发的工具集，编译java源码为Class。
- bin:最主要的是编译器(javac.exe)，java.exe 
- include:java和JVM交互用的头文件 
- lib：类库，JDK命令程序(如javac)的实际执行代码程序。包涵rt.jar--JAVA基础类库，tools.jar--编译和运行工具类库
- jre:java运行环境，包含JVM标准实现及Java核心类库。

总的来说JDK是用于java程序的开发,而jre则是只能运行class而没有编译的功能。

# 虚拟机
## 类的加载
将类的二进制数据读入内存，并放在<strong>方法区</strong>内，在堆区内创建一个java.lang.Class对象，只有被使用才会被加载，会预加载

### 加载方式
类加载有三种方式：

1. 命令行启动应用时候由JVM初始化加载
2. 通过Class.forName()方法动态加载，将类的.class文件加载到jvm中之外，还会对类进行解释，执行类中的static块
3. 通过ClassLoader.loadClass()方法动态加载，将.class文件加载到jvm中，不会执行static中的内容,只有在newInstance才会去执行static块

### 类的生命周期

#### 1. 加载(该阶段可控性最强)

1. 通过一个类的全限定名获取二进制字节流
2. 将这个字节流所代表的静态存储结构转化为方法区的运行时数据结构
3. 在Java堆中生成java.lang.Class对象，作为对方法区中这些数据的访问入口

#### 2. 连接
- 验证，文件格式验证，语义分析，行为，符号引用验证等
- 准备，为 **静态变量**分配内存，并初始化为**默认值**(零值),**final**字段则会被赋**指定值**

```java
public static int value = 123 //这个阶段是0
public static final int value = 123 //这个阶段是123
```

- 解析，把类中的符号引用转换为直接引用(开辟内存)，符号引用就是符号而已并不直接内存地址，而直接引用是指向内存地址

#### 3. 初始化
初始化，为类的静态变量赋予正确(可能因为构造方法提前被改变，赋值回静态变量指定的值)的初始值，JVM负责对类进行初始化，主要对类变量进行初始化。在Java中对类变量进行初始值设定有两种方式：
1. 声明类变量时指定初始值
2. 使用静态代码块为类变量指定初始值

五种情况需要立即对类进行初始化

- new,getstatic,putstatic,invokestatic字节码指令时，最常见的是new一个对象时，读取或者设置静态字段(被final修饰的除外，因为这在编译期间就被放在了常量池)
- 使用java.lang.reflect方法进行放射调用时
- 初始化一个类，其父类需要先进行初始化
- 主类(包含main()这个函数的类)
- 使用java.lang.invoke.MethodHandle实例解析结果是REF_getStatic,REF_putStatic,REF_invokeStatic的方法句柄对应的类

##### JVM初始化步骤

1. 假如这个类还没有被加载和连接，则程序先加载并连接该类
2. 假如该类的直接父类还没有被初始化，则先初始化其直接父类
3. 假如类中有初始化语句，则系统依次执行这些初始化语句

##### 类初始化时机：只有当对类的主动使用的时候才会导致类的初始化，类的主动使用包括以下六种：(总之就是被使用)
- 创建类的实例，也就是new的方式
- 访问某个类或接口的静态变量，或者对该静态变量赋值
- 调用类的静态方法
- 反射（如Class.forName(“com.shengsiyuan.Test”)）
- 初始化某个类的子类，则其父类也会被初始化
- Java虚拟机启动时被标明为启动类的类(Java Test)，直接使用java.exe命令来运行某个主类

#### 4. 结束生命周期
在如下几种情况下，Java虚拟机将结束生命周期
- 执行了System.exit()方法
- 程序正常执行结束
- 程序在执行过程中遇到了异常或错误而异常终止
- 由于操作系统出现错误而导致Java虚拟机进程终止

## 内存
### 程序计数器
如果线程执行的是
- 非native方法，则程序计数器中保存的是**当前需要执行的指令的地址**
- native方法，则程序计数器中的值是**undefined**。
分支、跳转、循环等基础功能都要依赖它来实现，由于程序计数器中存储的数据所占空间的大小不会随程序的执行而发生改变，因此，对于程序计数器是不会发生内存溢出现象(OutOfMemory)
### 栈内存
存放的是一个个的**栈帧**，每个栈帧对应一个**被调用的方法**
![方法栈](http://pcpj2g4mj.bkt.clouddn.com/18-11-4/18762104.jpg)

- 局部变量表

就是用来存储方法中的局部变量(包括在方法中声明的非静态变量以及函数形参)。对于基本数据类型的变量，则直接存储它的值，对于引用类型的变量，则存的是指向对象的引用。局部变量表的大小在编译器就可以确定其大小了，因此在程序执行期间局部变量表的大小是不会改变的。

- 操作数栈

在方法的执行过程中，会有各种字节码指令(比如：加操作、赋值元算等)向操作栈中写入和提取内容，也就是入栈和出栈操作
<br>栈最典型的一个应用就是用来对表达式求值。想想一个线程执行方法的过程中，实际上就是不断执行语句的过程，而归根到底就是进行计算的过程。因此可以这么说，程序中的所有计算过程都是在借助于操作数栈来完成的。

- 指向运行时常量池的引用(动态连接)

因为在方法执行的过程中有可能需要用到常量(存在在常量池中)，所以必须要有引用指向运行时常量。
>静态解析:类加载阶段或第一次使用的时候转化为直接引用(如final、static域等)

- 方法返回地址

当一个方法执行完毕之后，要返回之前调用它的地方，因此在栈帧中必须保存一个方法返回地址。
<br>由于每个线程正在执行的方法可能不同，因此每个线程都会有一个自己的Java栈，互不干扰。

**异常**
规定了两种异常情况：
1. 如果线程请求的栈深度大于虚拟机所允许的深度，将抛出StackOverflowError异常。
2. 如果虚拟机在动态扩展栈时无法申请到足够的内存空间，则抛出OutOfMemoryError异常。

### 本地方法栈
本地方法栈与Java栈的作用和原理非常相似。区别只不过是Java栈是为执行Java方法服务的，而本地方法栈则是为执行本地方法（Native Method）服务的。
<br>在JVM规范中，并没有对本地方发展的具体实现方法以及数据结构作强制规定，虚拟机可以自由实现它。在HotSopt虚拟机中直接就把本地方法栈和Java栈合二为一

### 堆内存(线程共享)
用来存储对象本身和数组(引用是存放在Java栈中的)

### 方法区(线程共享)
存储了每个**类的信息**(包括类的名称、方法信息、字段信息)、**静态变量**、**常量**以及编译器**编译后的代码**等。
- 常量池
它是每一个类或接口的常量池的运行时表示形式，在类和接口被加载到JVM后，对应的运行时常量池就被创建出来,在运行期间也可将新的常量放入运行时常量池中

# 注解
JDK1.5开始

## JDK提供的注解
添加javac编译器、开发工具和其他程序可以通过反射来了解类及各种元素上有无何种标记
- @Override
可以不用注解是给编译器看的
- @Deprecated
表示此方法已过时，过时的原因就是有新的API的类替代了次方法，但是仍然可以正常使用
- @SuppressWarings
允许选择性地取消特定代码段(即，类或方法)中的某些或是全部警告

## 元注解

- @Target

表示该注解可以用于什么地方，可能的ElementType参数有：
```java

CONSTRUCTOR：构造器的声明

FIELD：域声明（包括enum实例）

LOCAL_VARIABLE：局部变量声明

METHOD：方法声明

PACKAGE：包声明

PARAMETER：参数声明

TYPE：类、接口(包括注解类型)或enum声明
```

- @Retention

表示需要在什么级别保存该注解信息。可选的RetentionPolicy参数包括：
```java
SOURCE：注解将在编译器进行编译时它将被丢弃忽视

CLASS：注解只被保留到编译进行的时候，它并不会被加载到JVM中，在class文件中可用，但会被VM丢弃

RUNTIME：VM将在运行期间保留注解，因此可以通过反射机制读取注解的信息。

```

- @Document

将注解包含在Javadoc中

- @Inherited

允许子类继承父类中的注解

## 定义注解
@interface
与定义接口类似，原始也是以方法名的方式，default设置默认值。注解的可用的类型包括以下几种：所有基本类型、String、Class、enum、Annotation、以上类型的数组形式。元素**不能**有**不确定**的值，**即要么有默认值**，**要么在使用注解的时候提供元素的值**。而且元素**不能使用null**作为默认值。注解在只有一个元素且该元素的名称是value的情况下，在使用注解的时候可以省略“value=”，直接写需要的值即可。

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Demo {
     public String id();
     public String description() default "no description";
}
```
## 注解处理器
原理上使用反射的方式获取注解信息，然后根据值进行具体操作
```

```





-------------------------------------------

# static关键字



## JVM内存

### 程序计数器

非native方法，程序计数器保存当前需要执行的指令地址，native方法则为undefined。每个线程都有自己独立的程序计数器，这样线程切换时才知道恢复的位置

### 虚拟机栈

每个方法对应栈帧，执行该方法则将该栈帧压入虚拟机栈中，栈帧包含的信息，

- 局部变量表

主要是存储方法中的局部变量，包括方法中局部变量的信息和方法的参数。如：各种 **基本数据类型**（boolean、byte、char、short、int、float、long、double）、**对象引用**（reference类型，它不等同于对象本身，可能是一个指向对象起始地址的引用指针，也可能是指向一个代表对象的句柄或其他与此对象相关的位置）和returnAddress类型（指向了一条字节码指令的地址），其中64位长度的long和double类型的数据会占用2个局部变量空间（Slot），其余的数据类型只占用1个。局部变量表的大小在编译器就可以确定其大小了，因此在程序执行期间局部变量表的大小是不会改变的。在Java虚拟机规范中，对这个区域规定了两种异常状况：如果线程请求的栈深度大于虚拟机所允许的深度，将抛出StackOverflowError异常；如果虚拟机栈可以动态扩展（当前大部分的Java虚拟机都可动态扩展，只不过Java虚拟机规范中也允许固定长度的虚拟机栈），如果扩展时无法申请到足够的内存，就会抛出OutOfMemoryError异常。

- 操作数栈

虚拟机把操作数栈作为它的工作区，程序中的所有计算过程都是在借助于操作数栈来完成的，大多数指令都要从这里弹出数据，执行运算，然后把结果压回操作数栈。

- 动态连接

每个栈帧都包含一个指向运行时常量池中该栈帧所属方法的引用（指向运行时常量池：在方法执行的过程中有可能需要用到类中的常量），持有这个引用是为了支持方法调用过程中的动态连接

- 方法返回地址

当一个方法执行完毕之后，要返回之前调用它的地方，因此在栈帧中必须保存一个方法返回地址。

- 附加信息

虚拟机规范允许具体的虚拟机实现增加一些规范里没有描述的信息到栈帧中，例如与高度相关的信息，这部分信息完全取决于具体的虚拟机实现。在实际开发中，一般会把动态连接，方法返回地址与其它附加信息全部归为一类，称为栈帧信息。

### 本地方法栈
执行 **Native方法** 时使用的栈，与虚拟机栈类似

### 堆
线程共享的 **存储对象** 以及 **数组**(引用存放在栈中)，对象实例分配内存

### 方法区
线程共享内存区，用来存放类信息，常量，静态变量

- 常量池 
jvm为每个已加载的类型都维护一个常量池。常量池就是这个类型用到的常量的一个有序集合，包括实际的常量(string, integer, 和floating point常量)和对类型，域和方法的符号引用。池中的数据项象数组项一样，是通过索引访问的。 因为常量池存储了一个类型所使用到的所有类型，域和方法的符号引用，所以它在java程序的动态链接中起了核心的作用。 

- 域信息 
jvm必须在方法区中保存类型的所有域的相关信息以及域的声明顺序， 
域的相关信息包括： 
域名 
域类型 
域修饰符(public, private, protected,static,final volatile, transient的某个子集) 
- 方法信息

- 类信息等

### 内存参数

1. -Xms 初始堆大小即JVM内存大小
2. -Xmx 堆内存最大值，一般与-Xms相当，避免内存回收时重新分配内存
3. -Xss 设置线程栈的深度大小

## JVM垃圾

堆(新生代，老年代)，方法区(永久代)

### 新生代

使用"停止-复制"算法，分成Eden区和Survivor区，每次清理将Survivor区的存活的复制到新的Survivor区。

### 年老代

年轻代存在时间够长就会被复制都年老代
<br>使用"标记-整理"算法，标记出仍然存活的对象（存在引用的），将所有存活的对象向一端移动，以保证内存的连续

### 永久代

常量，静态变量，final变量等，对于不被引用的对象进行清理，对于类满足以下会被清理
- 所有实例被清理
- ClassLoader加载类被清理
- Class对象没有被引用(即没有被反射技术使用)




# 异常
程序在运行时，发生不期望发生的事件，并阻止了程序的预期的正常运行。**Throwable**类是异常类的顶级父类
**Throwable**又派生出**Error**类和**Exception**类。
<br>错误:Error类以及他的子类的实例，代表了JVM本身的错误。错误不能被程序员通过代码处理，Error很少出现。因此，程序员应该关注Exception为父类的分支下的各种异常类。
<br>异常:Exception以及他的子类，代表程序运行时发送的各种不期望发生的事件。可以被Java异常处理机制使用，是异常处理的核心。
<br>非检查异常，如Error和RuntimeException，不需要强制捕捉
<br>检查异常，如IOExcption,SQLException,ClassNotFoundExceptiond等是需要强制捕捉或是声明时throws抛出
<br>对于多个catch是从上到下匹配，要将范围小的放在上面，范围大的(父类放在下面),否则会报已捕捉错误
## throw
用于代码块中抛出异常
```java
throw new NumberFormatException(); 
```
## throws
声明方法会抛出异常，在声明方法时声明
```java
public void function() throws Exception{
}
```



# emun枚举类
```java
public enum WeekDay { 
     Mon("Monday"), Tue("Tuesday"), Wed("Wednesday"), Thu("Thursday"), Fri( "Friday"), Sat("Saturday"), Sun("Sunday"); 
    /*
        编译后是
                public static final WeekDay Mon;
                public static final WeekDay Tue;
        这几个常量对象
    */
     private final String day; //成员变量

     private WeekDay(String day) { 
            this.day = day; 
     } 
     //WeekDay类的构造方法

    public static void printDay(int i){ 
       switch(i){ 
            case 1: System.out.println(WeekDay.Mon); break; 
            case 2: System.out.println(WeekDay.Tue);break; 
            case 3: System.out.println(WeekDay.Wed);break; 
            case 4: System.out.println(WeekDay.Thu);break; 
            case 5: System.out.println(WeekDay.Fri);break; 
            case 6: System.out.println(WeekDay.Sat);break; 
            case 7: System.out.println(WeekDay.Sun);break; 
            default:System.out.println("wrong number!"); 
         } 
    }
    /*
        switch条件只能是int char和enum类
    */ 
    public String getDay() { 
        return day; 
     } 
}

```
emum也是类，并且实例化了几个对象

# 集合框架(JDK8)
# map
## hashmap
<k,v>键值对，不允许重复键，允许一个null，非线程安全
<br>内部通过“链表散列”实现
![](http://pcpj2g4mj.bkt.clouddn.com/18-10-30/43157221.jpg)
### hashcode(为什么数组大小都是2的幂)
```java
indexFor(int h,int lenth)
{
    return h&(lenth-1);
    //如果lenth是15(1110),任何数&1110都得不到最后一位为1的，所以浪费资源
}
```
<br>另一个好处就是如果hash值新增位如果为0，索引不变，如果为1则新索引为(久索引+久的位数)
### 什么时候扩容
达到loadFactor(一般为0.75)时候扩容
## concurrenrhashmap
线程安全，使用分段锁保证安全



# 克隆
基本类型使用 = 可以进行值的复制，会开辟新的内存地址存放值。
<br>类，数组的 = 是引用的复制，都是指向同一个内存地址。
<br>实现clonable接口，实现clone()方法
```java
public class CloneA implements Cloneable {  

    public Object clone() {  
        CloneA o = null;  
        try {  
            o = (CloneA) super.clone();  
        } catch (CloneNotSupportedException e) {  
            e.printStackTrace();  
        }  
        return o;  
    }  
}
```
## 浅克隆
如果类的内部有引用，这样克隆是浅克隆，因为这个引用还是指向原本的内存

## 深克隆
```java
public class CloneA implements Cloneable {  

    CloneB cloneb;
    public Object clone() {  
        CloneA o = null;  
        try {  
            o = (CloneA) super.clone();  
            this.cloneb = cloneb.clone();
        } catch (CloneNotSupportedException e) {  
            e.printStackTrace();  
        }  
        return o;  
    }  
}
```
对内部类也进行克隆，但是要内部类也进行克隆。对于StringBuffer这种final无法进行深度克隆，实现方法就是
```java
CloneA.strBuffer = new StringBuffer(strBuffer.toString());//进行复制
```



# IO

## 1. 磁盘文件IO

IO有直接IO/缓冲IO/内存映射的IO方式
- 直接IO

数据库这种高度追求IO性能，直接将数据从磁盘写入用户空间

- 缓冲IO
    1. 用户调用read方法
    2. 调用系统调用，触发中断，进程从用户态进入内核态
    3. 从硬盘中读取数据并复制到kernel缓冲区
    4. 将数据从kernel缓存区复制到用户提供的byte数组中
    5. 进程从内核态返回到用户态

- 内存映射
    1. 用户试图访问ptr指向的数据
    2. MMU解析失败，触发缺页中断，程序从用户态进入到内核态
    3. 从硬盘中读取数据并复制到进程空间中ptr指向的逻辑空间里
    4. 进程从内核态返回到用户态

java中IO的read()方法是调用native read0()方法,

```java
public int read() throws IOException {
    return read0();
}
private native int read0() throws IOException;

```

## 2. 网络IO
![io](http://pcpj2g4mj.bkt.clouddn.com/18-11-16/68197494.jpg)

分为kernel(内核态)准备好从网络上接收到的数据报，收到的报文被从kernel复制到用户态空间两个过程

1. 阻塞I/O(同步IO)
等待系统执行，将被程序将被阻塞，直到两个过程都完成

2. 非阻塞I/O(同步IO，拷贝数据是任然需要等待)
不用等待系统执行(内核获取数据阶段)，程序主动询问系统是否操作完成(轮询会得到结果，如果未完成则得到ERROR)，但是将数据从**内核态取出到用户态**仍然需要线程等待。

3. 多路复用I/O(是否非阻塞同步IO取决于设置timeout参数)

多路复用是一种**通知机制**，通知线程从内核态取数据的通知机制，即程序注册一组socket文件描述符(fd)给操作系统，表示“我要监视这些fd是否有IO事件发生，有了就告诉程序处理”,一般结合NIO才有意义。
进程调用select/poll,epoll轮询系统完成操作，当某个进程的数据完成时通知线程(拷贝数据时进程需要等待)。多路复用模式不一定会提高单个IO的效率，是为了处理多IO，系统不必创建进程/线程，也不必维护这些进程/线程，从而大大减小了系统的开销

- select实现
接受3个文件描述符的数组(1024长度)，分别监听读取(readfds)，写入(writefds)和异常(expectfds)事件,调用后select函数会**阻塞**，直到有描述符就绪(有数据 可读、可写、或者有except)，或者超时(timeout指定等待时间，如果立即返回设为null即可)，函数返回。当select函数返回后，讲fd表传入内核中通过轮询方式**遍历**fd，来找到就绪的描述符。并且是无状态，对于就绪为被通知的描述符下次仍然需要遍历通知。

- poll实现

与select方式类似，只是对描述符个数没有限制。

- epoll实现

epoll将就绪的描述符标记，直接读取就绪的描述符
两种模式
<br>LT模式(水平触发):关心文件描述符中是否还有没完成处理的数据，这个模式下相当于高效的poll，对于没有被读取或是读取完的标识符第二次继续去通知线程来读取。
<br>ET模式(边沿触发):关心文件描述符是否有新的事件产生，这个模式下，为读取或是没读完的标识符不会去通知线程来读取，因为这次并非是新的事件

4. 信号驱动I/O

5. 异步I/O (AIO)
线程请求会被立即返回，不会被阻塞，数据拷贝到**用户空间**后会通知进程操作完成。

# lambda表达式

```java
Arrays.asList( "a", "b", "d" ).forEach( e -> System.out.println( e ) );
Arrays.asList( "a", "b", "d" ).forEach( ( String e ) -> System.out.println( e ) );
//可以不用指定参数类型，编译器会自动推理,也可以指定



String separator = ",";
Arrays.asList( "a", "b", "d" ).forEach((String e) -> System.out.print( e + separator ) );

final String separator = ",";
Arrays.asList( "a", "b", "d" ).forEach(( String e ) -> System.out.print( e + separator ) );
// Lambda表达式可以引用类成员和局部变量（会将这些变量隐式得转换成final的）


Arrays.asList( "a", "b", "d" ).sort( ( e1, e2 ) -> e1.compareTo( e2 ) );

Arrays.asList( "a", "b", "d" ).sort( ( e1, e2 ) -> {
    int result = e1.compareTo( e2 );
    return result;
});
// Lambda表达式有返回值，返回值的类型也由编译器推理得出。如果Lambda表达式中的语句块只有一行，则可以不用使用return语句

```

## 函数式接口
一个普通方法+n个默认方法+n个静态方法
<br>默认方法通过实现类的对象进行调用，静态方法通过接口名调用
<br>**注意**:
1. 类实现多个接口，这些接口包含同名默认方法需要重写
2. 实现的接口的默认方法与父类同名方法，则被父类重载


# 泛型
## 参考资料

- [java 泛型详解-绝对是对泛型方法讲解最详细的，没有之一](https://www.cnblogs.com/coprince/p/8603492.html)

泛型也就是参数化类型，将参数类型作为参数，所有会用到基本类型的包装类。
<br>在编译之后程序会采取去**泛型化**的措施。也就是说Java中的泛型，只在**编译阶段有效**。在编译过程中，正确检验泛型结果后，会将泛型的相关信息擦除(未指定时为Object。如果指定了上限如\<T extends String> 则类型参数就被替换成类型上限。也因为类型擦除也带来了继承相关的特性局限)。并且**在对象进入和离开方法的边界处添加类型检查和类型转换的方法**。也就是说，泛型信息**不会进入到运行时阶段**。对此总结成一句话：**泛型类型在逻辑上看以看成是多个不同的类型，实际上都是相同的基本类型（Object类或上限类型）**。

## 举个例子

```java
public class Cache {
    Object value;
    public Object getValue() {
        return value;
    }
    public void setValue(Object value) {
        this.value = value;
    }
}

Cache cache = new Cache();
cache.setValue(134);      //Object类型
int value = (int) cache.getValue();  //类型装换(Integer)
cache.setValue("hello");  //Object类型
String value1 = (String) cache.getValue();//类型装换

```
```java
public class Cache<T> {
    T value;

    public T getValue() {
        return value;
    }
    public void setValue(T value) {
        this.value = value;
    }
}

Cache<String> cache1 = new Cache<String>();
cache1.setValue("123");
String value2 = cache1.getValue();
Cache<Integer> cache2 = new Cache<Integer>();
cache2.setValue(456);
int value3 = cache2.getValue();

```



## 通配符

### 参考资料

- [深入java 泛型通配符和上下界限定](https://blog.csdn.net/yabay2208/article/details/77967537)

**通配符的出现是为了指定泛型中的类型范围**(如子类与父类的范围)，可以安全的使用和改正Java数组的的类型安全弱点。

通配符有 3 种形式。

- <?> 被称作无限定的通配符。相当于上限为Object类。

- <? extends T> 被称作有上限的通配符。表示参数化类型的可能是**T类**或是**T的子类**。

- <? super T> 被称作有下限的通配符。**T类**的**超类**（**父类**），直至**Object**

> 一般使用在数组的定义上，对参数的类型定义是使用通配符
>
> - 上限list**只读**，赋值为**T类**或是**T的父类**。
> - 下限list
>   - **写操作** 可以add**T**类以及**T类的子类**；
>   - **读操作 **需要使用**Object类**来赋值（instance of可以获知其数据类型）
> - 而无限定通配符表示**只读**，相当于**上限**为**Object类**，赋值为**T类**或是**T的父类**。

> - 上限 <? extend Futher> ，表示所有继承Futher的子类，但是具体是哪个子类，无法确定，所以调用add的时候，要add什么类型，谁也不知道。但是get的时候，不管是什么子类，不管追溯多少辈，肯定有个父类是Futher，所以，都可以用最大的父类Futher接着，也就是把所有的子类向上转型为Futher。
> - 下限 <? super Son>，表示Son的所有父类，包括Son，一直可以追溯到老祖宗Object 。那么当我add的时候，我不能add Son的父类，因为不能确定List里面存放的到底是哪个父类。但是我可以add Son及其子类。因为不管我的子类是什么类型，它都可以向上转型为Son及其所有的父类甚至转型为Object 。但是当我get的时候，Son的父类这么多，我用什么接着呢，除了Object，其他的都接不住

> 所以，归根结底可以用一句话表示，那就是编译器可以**支持向上转型**，但不支持向下转型。具体来讲，我可以把Son对象赋值给Futher的引用，但是如果把Futher对象赋值给Son的引用就必须得用cast，因为Son有的属性，Futher对象没有，没法满足。

### 泛型与通配符的区别

泛型侧重于类型的**声明**上代码复用，通配符则侧重于**使用**上的代码复用

# 杂记

## System.out.print()
作为一个很常用的函数，了解了解内部实现

```java
public void println() {
        //对于非空操作，调用print操作
        newLine();
    }

//换行操作
private void newLine() { 
    try {
        //synchronized 保证输出的顺序性
        synchronized (this) {
            ensureOpen();
            textOut.newLine();          //BufferedWriter textOut
            textOut.flushBuffer();
            charOut.flushBuffer();      //OutputStreamWriter charOut
            if (autoFlush)
                out.flush();
        }
    }
    catch (InterruptedIOException x) {
        Thread.currentThread().interrupt();
    }
    catch (IOException x) {
        trouble = true;
    }
}


// print操作
public void print(char c) {
    write(String.valueOf(c));
}

// write()操作
private void write(String s) {
        try {
            synchronized (this) {
                ensureOpen();
                textOut.write(s);
                textOut.flushBuffer();
                charOut.flushBuffer();
                if (autoFlush && (s.indexOf('\n') >= 0))
                    out.flush();
            }
        }
        catch (InterruptedIOException x) {
            Thread.currentThread().interrupt();
        }
        catch (IOException x) {
            trouble = true;
        }
    }
```

