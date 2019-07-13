# 前言

不使用ide和maven等工具打包，使用JDK命令打包，学习java项目打包的结构与过程

# 命令行

## java

运行java源码编译后的程序。

### 基本参数

- **-classpath**|**-cp**

虚拟机在运行一个类时，需要将其装入内存，虚拟机搜索类的方式和顺序如下：

**Bootstrap classes**，**Extension classes**，**User classes**。

**Bootstrap** 中的路径是虚拟机自带的jar或zip文件，虚拟机首先搜索这些包文件，用System.getProperty("sun.boot.class.path")可得到虚拟机搜索的包名。

**Extension**是位于jre"lib"ext目录下的jar文件，虚拟机在搜索完Bootstrap后就搜索该目录下的jar文件。用System.getProperty("java.ext.dirs”)可得到虚拟机使用Extension搜索路径。

**User classes**搜索顺序为**当前目录**、**环境变量 CLASSPATH**、**-classpath**。**-classpath**用于告知虚拟机搜索目录名、jar文档名、zip文档名，之间用分号;分隔。



# 打包步骤

我的项目目录结构如下，src中为项目源码，com.xiong为我的项目包名。classes文件夹将用来存放编译后的字节码文件。

```
|--src
     |--com
          |--xiong
                 |--AppDemo.java
|--classes

```



## 1. 编译成class字节码文件

```sh
javac ./src/com/xiong/AppDemo.java -d ./classes 
```

- **-d** 将在指定目录下生成编译文件，会自动生成包目录

## 2.运行字节码文件

```sh
java com.xiong.AppDemo -cp ./classes
```

java 类名执行该类的main方法 ，**-cp ** 指定类路径，如果不指定会按顺序搜索该类。

## 3. 打包程序

使用**jar**将项目打包成jar归档文件，将项目打包成单个的归档文件。**注意**：需要cd到需要打包的目录下。

```sh
jar -cvef com.xiong.AppDemo MyAppDemo.jar ./*
```

- **-c** 创建新档案
- **-v**  在标准输出中生成详细输出
- **-f**  指定档案文件名
- **-e**  为绑定到可执行 jar 文件的独立应用程序指定应用程序入口点, 类名, 不包含后缀

会在当前目录生成MyAppDemo.jar文件该压缩文件内如下：

```
|--com
     |--xiong
            |--AppDemo.class
|--META-INF
		  |--MANIFEST.MF
```

MANIFEST.MF中

```
Manifest-Version: 1.0
Created-By: 1.8.0_181 (Oracle Corporation)
Main-Class: com.xiong.AppDemo
```

Main-Class是该打包项目的主入口类。

