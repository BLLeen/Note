# IO分类
java的IO分为字符流和字节流，整个Java.io包中最重要的就是5个类和一个接口。5个类指的是File、OutputStream、InputStream、Writer、Reader；一个接口指的是Serializable。这几个类和接口分为包括如下几个层次，包含三个部分：

- 流式部分 
IO的主体部分，还可以具体细分为**字符流**和**字节流**

- 非流式部分
主要包含一些辅助流式部分的类，如：File类、RandomAccessFile类和FileDescriptor等类；

- 其他类
文件读取部分的与安全相关的类，如：SerializablePermission类，以及与本地操作系统相关的文件系统的类，如：FileSystem类和Win32FileSystem类和WinNTFileSystem类。

# 流式IO
- 字节流
    - InputStream 字节流读抽象类，所有输入流的父类
            - FileInputStream 字节读文件
            - FilterInputStream 一个具有装饰者作用的类，一般使用其子类镜像装饰。
                - BufferedInputStream 装饰类，扩展buffer功能
				- DataInputStream 扩展对数据类型的读取，从底层输入流中读取基本 Java 数据类型
    - OutputStream 所有输出流的父类
            - FileOutputStream 
            - FilterInputStream 
                - BufferedOutputStream 
				- DataOutpputStream 使用DataOutpputStream写入的数据要使用DataInputStream取出进来

- 字符流
	- Reader字符流读抽象类
            - BufferedReader 带缓冲区文件读 readLine()可以逐行读
            - InputStreamReader 逐字符读 InputStreamReader(new FileInputStream(path),"UTF-8")可指定编码
                - FileReader 由InputStreamReader继承来的
    - Writer字符流写抽象类 Writer字符流写抽象类
            - BufferedWriter  new BufferedWriter(new FileWriter("D:/trainning/demo.txt",true))加个true可在原文末尾添加而不覆盖
            - OutputStreamWriter 
                - FileWriter 

## 字节流
字节流以1字节为单元传输，byte代表一个字节，一个字节包含8个位，类型的取值范围是-128到127。一般非字符类型，如图片，视频等。字节流的操作不用到缓冲区，直接进行操作。

### 输入流
InputStream抽象类，所有输入流的父类。
<br>其子类:
- FileInputStream  其特性是专门从**文件**中创建输入流
- AudioInputStream 音频输入流是具有指定音频格式和长度的输入流。
- ByteArrayInputStream 包含一个内部缓冲区，该缓冲区包含从流中读取的字节。
- ObjectInputStream ObjectInputStream 对以前使用 
- ObjectOutputStream 写入的基本数据和对象进行反序列化。
- SequenceInputStream SequenceInputStream 表示其他输入流的逻辑串联。

#### FileInputStream
从文件中创建输入流，主要是做两件事1.创建标识符(文件句柄(windows)，文件描述符(linux),用来表示当前进程打开的文件) 2.调用native read0()函数。
<br>创建标识符步骤如下
1. 如果FileInputStream类尚未加载，则执行initIDs方法，否则这一步直接跳过。
2. 如果FileDescriptor类尚未加载，则执行initIDs方法，否则这一步也直接跳过。
3. new一个FileDescriptor对象赋给FileInputStream的fd属性。
4. 打开一个文件句柄。
5. 将文件句柄赋给FileDescriptor对象的handle属性。

```java
 try {
            //还有一个FileInputStream(File file)构造方法，估计是用来加载文件标识符的
            InputStream is = new FileInputStream ("input.txt");
            StringBuffer sb = new StringBuffer();
            while(true)
            {
                int c=is.read();
                if(c==-1)break; //返回-1表示读取完毕
                sb.append((char)c);
            }
            System.out.println(sb);
            is.close();
        }catch (FileNotFoundException e)
        {
            System.out.println("文件不存在");
        }catch (IOException e)
        {
            System.out.println("读取失败");
        }
```
#### FilterInputStream类
装饰类，传入inputstream类，将其修饰功能。
- BufferedInputStream类较于FileInputStream类，会先将数据读到缓存中，这样会快一些。使用方法与FileInputStream类似
- DataInputStream类可以将，这个类可以直接从stream中读取基本数据类型，String等类型

#### 其他子类日后研究

### 输出流
OutputStream抽象类，所有输出流的父类。与InputStream类似
```java
 File file = new File("input.txt");
        if(!file.exists())
        {

            try {
                if(file.createNewFile())
                {
                    System.out.println("文件不存在，并且创建失败");
                    return;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        }

        try {
            FileOutputStream fos = new FileOutputStream(file,true); //第二个参数是否为追加而不是覆盖
            fos.write(" append \n".getBytes());

            fos.close();

        } catch (FileNotFoundException e) {
            System.out.println("文件不存在");
        }catch (IOException e)
        {
            System.out.println("写入失败");
        }
```
#### 

## 字符流
Java中字符是采用Unicode标准，一个字符是16位，即一个字符使用两个字节来表示。为此，JAVA中引入了处理字符的流。字符流以字符为传输单元传输，一般纯文本格式，xml，json，txt操作用此方式。因为数据编码的不同，而有了对字符进行高效操作的流对象。本质其实就是**基于字节流**读取时，去查了指定的**码表**。字符流的操作需要缓冲区，需要关闭才能输出。
<br> 个人理解，本质的传输还是字节流，
### Reader 字符流输入的父类
#### InputStreamReader类
将输入字节流包装成字符流，指定编码方式
```java
InputStreamReader  isr= null;
isr = new InputStreamReader(new FileInputStream(file),Charset.forName("UTF-8"));
```
### Writer



