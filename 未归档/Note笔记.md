7-11
git pull 
git checkout mybranch
git merge develop//同步到develop分支
git push origin mybranch
---------------
Java 泛型
	泛型类
	class<T,V> className
	{
		T a;
		v b;
	}
	泛型方法
	<T,V>int function()
	{
		
	}
	调用时<Type1, Type2>function()
	边界符
	比较比较操作符无法使用的类
	<T extends Compareble<t>> int compare( T a,T b)
	{
		a.compareTo(b)
		return int
	}
## vagrant快速环境部署工具
> vagrant+虚拟机进行环境打包快速部署。

### Vagrantfile为配置信息
```
config.vm.box = "bento_centos-7.3.box"//环境包路径
```
```
.box 环境包
```
### 开始环境部署
```
$ vagrant init      //初始化
$ vagrant up        //启动虚拟机
$ vagrant halt      //关闭虚拟机
$ vagrant reload    //重启虚拟机
$ vagrant ssh       //SSH 至虚拟机
$ vagrant suspend   //挂起虚拟机
$ vagrant resume    //唤醒虚拟机
$ vagrant status    //查看虚拟机运行状态
$ vagrant destroy   //销毁当前虚拟机
```

### box管理命令
```
$ vagrant box list    //查看本地box列表
$ vagrant box add     //添加box到列表
$ vagrant box remove  //从box列表移除 
```
### 遇到的情况

- CPU虚拟化需要打开
- 如遇到powershell问题，检查环境配置
	-powershell C:\Windows\System32\WindowsPowerShell\v1.0
## Java泛型
- 泛型类
- 泛型方法
- 泛型通配符
> 通配符 ?  ；当操作类型时，不需要使用类型的具体功能时，只使用Object类中的功能。那么可以用 ? 通配符来表未知类型.
- 类型擦除
> - 虚拟机中没有泛型类型的对象,所有对象都是普通的类 。
> - 比如list<Integer>和List<String>在编译后都是变成List，在字节码中不包含类型信息，在使用

--------------------------07-12-------+++
title = "2018-07-12"
weight = 98
+++

## Docker
> - 在windows上运行其本质是运行在Windows上的虚拟机里面的Linux上，实质上还是运行在Linux，因为Docker是建立在Linux内核基础上的，Windows无法适应
> - 容器 = 镜像 + 读写层，容器是镜像的实例


### 拉取镜像到本地
``` 
docker pull 镜像加速器地址/镜像
docker pull registry.saas.hand-china.com/tools/ubuntu:14.04
``` 
### 删除镜像
> 需要先stop有该镜像的容器
```
docker rmi 镜像id

```

### 创建容器
```
docker create 镜像id 
```
### 删除容器
```
docker rm 容器名

```
### 查看(所以)容器
```
docker ps (-a)
```
### 启动指定容器
```
docker-machine ssh 容器名
```

### 容器下指定镜像执行命令
```
docker run 镜像 Command 
```
### 停止容器
```
docker stop 容器名
```
### 删除容器
> 需要先停止该容器

```
docker rm 容器名
```

### 交互式容器
- 使用Ubuntu中的bash打印出了信息。但是这个操作并不是交互式的，并没有侵入Ubuntu本身。进入Ubuntu，然后使用shell交互式的对容器进行交互。

```
docker run -i -t ubuntu:15.10 /bin/bash

-t:  在新容器内启动一个终端
-i：允许对容器内的标准输入进行交互

```

## Linux学习

### 杂记
- history命令获取500条内的命令记录
- exit退出所以shell，logout退出登陆的shell
- man/info 命令可以列出命令信息

### Vi编辑器
1. 进入vi之后，是处于「命令行模式（command mode）」，
换到「插入模式（Insert mode）」才能够输入文字
2. 切换至插入模式（Insert mode）编辑文件在「命令行模式（command mode）」下按一下字母「i」就可以进入「插入模式（Insert mode）」，这时候你就可以开始输入文字了。
3. Insert 的切换
	「ESC」键转到「命令行模式（command mode）」
4. 退出vi及保存文件
	在「命令行模式（command mode）」下，按一下「：」冒号键进入「Last line mode」，例如：
	- : w filename （输入 「w filename」将文章以指定的文件名filename保存）
	- : wq (输入「wq」，存盘并退出vi)
	- : q! (输入q!， 不存盘强制退出vi)


--------------------7-13------------
## Docker

### 交互式容器
run bash 可使得linux为命令交互式shell
### 虚悬镜像
> 新版本的镜像pull下来导致旧版本的名字和tag为<none>
```
docker images -f dangling=ture //显示虚悬镜像
```
### 中间层镜像
> 其他镜像的依赖镜像没有标签名，顶层镜像才会显示标签

### 过滤器 -f/-filter
> 列出过滤后的列表

### docker虚拟机地址
```
docker-machine ip
```
### docker端口映射到主机端口
run 时指定虚拟端口号:主机端口号

### 进入容器也可以

```
docker exec -it()  容器 /bin/bash(交互式shell)

```
nginx 80端口 443端口

### 杀死容器
```
docker kill 容器

```
### 停用并删除容器
```
docker stop $(docker ps -q) & docker rm $(docker ps -aq)

```
### 创建镜像(从已有的镜像)

#### 将镜像打包
```
docker commit -m="with wget" -a="five3" e218edb10161 five3/ubuntu:v2
- -m:提交的描述信息
- -a:指定镜像作者

```
#### 将镜像打包上传
```
docker push 镜像仓库

```

```
docker build -t name:tag

```
## 创建镜像(Dockerfile)

### TAG
```
docker tag 镜像 name：tag

```
### Mysql镜像
```
-  docker run --restart=always --name=mysql_5.7 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d registry.saas.hand-china.com/tools/mysql:5.7.22
-  docker run  --name=mysql_5.7 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
- 需要配置MYSQL_ROOT_PASSWORD默认root用户密码

```
## Compose
> 定义并且运行一组相关联的容器，如web服务器容器加上数据库服务器容器，同时运行多个配置在yml中的容器。


### docker-compose.yml格式
```yml
version: "3" # yml版本号
services:
  nginx-0: #服务1名
    container_name: nginxtest  #容器名
    image: nginx/nginx:v1.0  #镜像
    ports: 
	  - "容器端口:主机端口" #端口映射
	  
  mysqltest: #服务2
    container_name: mysqltest
    image: mysql:5.6
    hostname: mysqltest
    environment: #环境配置
      - MYSQL_ROOT_PASSWORD=root 
    ports: 
      - "3306:3306"
```
### MySQL
> enviroment需要配置默认root用户密码,否则会失败


docker-compose.yml
docker-compose up
docker-compose down
docker-compose ps
docker-compose start 

---------------
### hugo+Github创建个人博客
``` 
hugo new site <username.github.io>
# 生成 username.github.io 文件夹
创建的站点文件目录说明：
	|- archetypes ：存放default.md，头文件格式
	|- content ：content目录存放博客文章（.markdown/.md文件）
	|- data ：存放自定义模版，导入的toml文件（或json，yaml）
	|- layouts ：layouts目录存放的是网站的模板文件
	|- static ：static目录存放js/css/img等静态资源
	|- config.toml ：config.toml是网站的配置文件
```
#### github创建github page 项目名<username.github.io>
#### hugo new post/xxx.md
在content目录下创建post目录并生成xxx.md文件，这就是博客文章

```
+++
date = "2017-02-08T22:07:46+08:00"
title = "title"
draft = true #true 表示为草稿，hugo不发布这一个md
+++

```


作业
 hugo /hugo server
1. github创建库，README
用hugo主题模板博客
2. Dockerfile，打包博客镜像
3. biuld.sh 打开镜像的脚本
4. run.sh
	cd ..
	sh build.sh //打包命令
	sh run.sh
4. 日报，总结
---------7-14------
## Docker学习
### Dockerfile 创建镜像
> Docker通过对于在Dockerfile中的一系列指令的顺序解析实现自动的image的构建

#### Dockerfile指令

- FROM base镜像 #表示baseimage开始构建,可以在一个 Dockerfile 中出现多次，以便于创建混合的images。
- MAINTAINER #镜像制作者的信息
- RUN #将在当前image中执行任意合法命令并提交执行结果。命令执行提交后，就会自动执行Dockerfile中的下一个指令。
- ENV
 	- ENV指令可以用于为docker容器设置环境变量
    - ENV设置的环境变量，可以使用 docker inspect命令来查看。同时还可以使用docker run --env <key>=<value>来修改环境变量。
- WORKDIR
    WORKDIR 用来切换工作目录的。这个切换是持久的。
- COPY
    - COPY <src> <dest>。
    - <src> 文件或目录
	- <dest> 是目标容器中的绝对路径。
- ADD
    - ADD  <src> <dest>。
    - <src> 文件或目录，也可以是一个远程的url。
	- <dest> 目标容器中的绝对路径。

- EXPOSE #EXPOSE 指令指定在docker允许时指定的端口进行转发。

- CMD
	- CMD RUN 镜像安装完后执行
> [Dockerfile详解](Dockerfile详解)

### 遇到的问题
#### 问题1
##### 问题描述
> 写Dockerfile时，WORKDIR file1路径，准备在WORKDIR另一个路径时忽略表示根目录的"/",直接写成file2，导致此时的file2为file1目录下的file2 

### Docker + hugo建个人博客
#### build我的镜像centos+hugo服务器镜像 
```
registry.cn-hangzhou.aliyuncs.com/blleen/xiong_centos_hugo:v1.0

```
#### 基于xiong_centos_hugo:v1.0的Dockerfile
```
FROM registry.cn-hangzhou.aliyuncs.com/blleen/xiong_centos_hugo:v1.0

COPY hugo个人博客文件夹/ /mysite/

WORKDIR /mysite/

#baseUrl=docker-machine ip默认192.168.99.100

CMD hugo server --baseUrl=192.168.99.100 --bind=0.0.0.0 && \ run -dit -p 1313:1313 --name=myhugoserver xiong_centos_hugo:v1.0

EXPOSE 1313
	
```
### hugo+github发布个人博客
1. hugo new site myblog //构建建hugo博客文件目录
2. hugo new 文件或文件夹将在context目录下创建
3. 创建md格式的页面
```
+++
date = "20xx-xx-xxT10:48:56+08:00"
draft = true //是否为草稿
title = "first"
+++
# My first blog

```
---------------7-16-------------
### 今日的坑
今天花了一下午时间研究docker持久化问题，容器间的数据交互问题，在想
- <strong>Mysql数据如何保存</srtong>(尚未解决)
> 看到有的博客说可以直接保存容器可以将数据一同打包成镜像，可是我试了在数据库里添加表，生成镜像，在新的docker-machine上跑，数据不见了
- 容器映射到主机目录<strong>但是我会出现</strong>
运行
```
docker run -d -p 3306:3306 -v /data:/var/lib/mysql -e MYSQL_ROOT_PASS="root" 
```
出现
```
Error response from daemon: invalid mode:
```
(尚未解决)

### maven
> 项目管理工具，用来管理jar包，以maven项目模版构建项目目录，以pom.xml配置显目构建。
- 统一管理jar包，协调jar包版本
- 减少本地jar包下载
#### Maven项目结构
分成两大类，main与test。main放关于项目的文件，test放测试相关源码文件等
- src/main/java 项目的源代码所在的目录
- src/main/resources 项目的资源文件所在的目录
- src/main/filters 项目的资源过滤文件所在的目录
- src/main/webapp 如果是web项目，则该目录是web应用源代码所在的目录，比如html文件和web.xml等都在该目录下。
- src/test/java 测试代码所在的目录
- src/test/resources 测试相关的资源文件所在的目录
- src/test/filters 测试相关的资源过滤文件所在的目录
- 项目根目录下有pom.xml,这是maven重要的配置文件
#### Maven Setting
用来配置本地仓库，网络代理，设置servers，定义远程仓库的镜像等

##### POM文件
- Project：所有元素的根元素，该元素声明的信息主要为了方便第三方插件使用。
	- modelVersion：用于指定当前POM模型的版本，对于maven2,maven3只能是4.0.0。
	- groupId：用于指定当前项目所属的组，比如com.hand.project。
	- artiffactId：当前项目所属组的唯一的ID号
	- Version：用于指定当前项目的版本编号。比如：0.0.1-SNAPSHOT。后面的SNAPSHOT常指正在开发中的项目。
	- dependencies             
       - dependency 项目所需的依赖       

####### 子模块
如果父项目pom中使用的是：
```xml
<dependencies>
     ....
</dependencies>方式，
```
则子项目pom会自动使用pom中的jar包。
<br>如果父项目pom使用
```xml
<dependencyManagement>
     <dependencies>
          ....
     </dependencies>
</dependencyManagement>
```
<br>则子项目pom不会自动使用父pom中的jar包，如果需要使用，就要给出groupId和artifactId，无需给出version

### Maven指令
- mvn clean 清除上次编译生成的文件
### Kafka&Zookeeper
#### Kafka
#### Zookeeper
### docker swarm

### 敏捷开发
个人理解关键词
- 用户需求
	> 满足用户需求，实时跟进用户需求变更，频繁交流，注重沟通
- 迭代
	> 用户需求增加，功能更新
- 子项目
	> 将大项目分割成小项目，能够独立运行，持续交付集成

#### 敏捷原则：

- 频繁交付
- 沟通合作
- 需求变化
- 项目推进

#### CI/CD持续集成/持续部署
持续交付，频繁交付新的软件版本，集成，越早集成发现错误，越早解决成本越小。
#### 书籍推荐
《持续交付》
《凤凰项目》
《scnum敏捷软件开发》
《DevOps》
### Docker容器数据持久化与数据共享
> 镜像是多个只读文件层，叠成的。容器，就是在镜像层上添加读写层。对容器的操作便是在该层上进行。
> docker容器是无状态的，重启时数据会被清空，恢复初始状态。

#### 数据持久化
- 可以将静态数据写入容器，将容器commit成镜像，即可保存。下次要使用重新根据镜像生成容器
#### 数据共享
##### 数据卷
> 数据卷是容器内数据直接映射到本地主机指定的目录的一个目录，这个卷会一直存在。实现了应用与数据的结耦合
-------------------07-17------
## 学习计划
- Kafka&Zookeeper ✘
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- Maven加深 ✘
- Java基础 ✔
## 今日的坑

今天在复习java基础知识没有什么坑。就是在Maven Setting.xml配置上很混乱不知道什么标签必须加什么可以默认。以及Maven的pom.xml配置问题。

## 今日学习

### 数据卷(较于昨日更加深入)
昨日挂载一直出现问题。

### 数据容器
数据卷直接在主机目录挂载有问题，试试数据容器方式。
<br>先在centOS容器里根目录创建挂载卷dbdata。
```
 docker run -it -v /dbdata --name database registry.saas.hand-china.com/tools/centos:7.2.1511

```
ls确实生成该文件夹
<br>再创建一个mysql容器，--volumes-from 容器名，从database容器来挂载数据卷
#### 删除数据容器挂载卷
挂载卷类似共享文件，而这个文件似乎没有拥有者，所有挂载的容器，创建他的容器被删除后该卷还在，<strong>生命周期独立于容器<strong>，
- 需要在最后一个挂载他的容器删除是 加上-v进行删除数据卷
- docker volume ls 查看volumes, 再选择inspect查看详细信息，选择需要删除的，rm。
- docker volume prune 删除所有的volume

### Java基础学习

#### 异常篇

- 异常处理时如果指定子类异常，并被捕获，则捕获父类Exception块不会被执行
- java.lang，java.util，java.net内的异常都是Runningtime异常需要捕获(运行时异常强制要求捕获)
- 自定义异常，通过extends异常创建一个异常类
- throw抛出异常，与<strong>trycatch</strong>配套或是与<strong>throws<strong>配套使用

#### 字符串篇

#### String
> String是一个final类，创建就是<strong>固定不变<strong>的
> 对String对象的任何改变都不影响到原对象，生成新的字符串操作都会生成新的对象。改变的只是引用的指向，指向新的对象，就的对象，等待被垃圾回收

#### StringBuffer

> 可以对字符串内容进行更改,为字符串变量。
> 线程安全的。很多方法上加了synchronized。

#### StringBuild

> 和StringBuild类似，速度会比StringBuffer块一些。
> 线程不安全的。

#### String,StringBuffer,StringBuilder适用范围
- String适用于较短的少量的字符串操作
- StringBuffer适用<strong>多线程</strong>于大量的字符串操作
- StringBuilder适用于<strong>单线程</Strong>大量的字符串操作
-------
- 方法的重写:
> 子类对父类方法的重写
- 参数列表相同
- 返回值相同
- 访问权限不能比父类严格
访问权限修饰符

|     |同一个类 | 同一个包 | 不同包的子类 | 不同包的非子类|
| ----| ------ | ------   | -------    |--------|
| private|✔   |          |         |      |
| default| ✔  | ✔       |         |     |
| protect| ✔  | ✔       |✔       |      |
| public| ✔   | ✔       |     ✔|      ✔|

- 方法的重载:
> 同一个方法名，不同的方法内容

- 递归方法
看到大牛博客写了一句话
> To Iterate is Human, to Recurse, Divine.
> 人理解迭代，神理解递归

递归既向外递，达到返回条件再向内归。有的问题在向外递的过程中解决问题
有的在往回归的过程中解决问题
- 模型一： 在递去的过程中解决问题
```
 recursion(大问题)){
    if (递归终止条件){      
        end;   
    }else{     // 在将问题转换为的每一步，解决该步中剩余部分的问题
        solve;                // 递去
        recursion(子问题);     // 递到最深处后，不断地归来
    }
}

```

- 模型二： 在归来的过程中解决问题

```

function recursion(大问题){
    if (end_condition){      // 明确的递归终止条件
        end;   // 简单情景
    }else{            // 大问题全部展开，再由终点归来途中依次解决每步中剩余部分的问题
        recursion(子问题);     // 递去
        solve;                // 归来
    }
}

```
------------

### 匿名对象

new一个对象，该对象不赋给类引用变量。既在堆内存中开辟一个对象空间，不用栈内存里的变量去指向这个对象，所有用一次后等待垃圾回收机制来回收。

```
new 类.成员
```
### Maven打包项目
通过IDE编写Maven项目，通过mvn指令进行打包成jar格式


-----------7-18-----
## 学习计划
- Kafka&Zookeeper ✘
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- ~~Maven加深 ✔~~
- ~~Java基础 ✔~~
- java8新特性 ✘

## 今日的坑

### 坑1

运行mvn时遇见Error

```
 Plugin org.apache.maven.plugins:maven-resources-plugin:2.6 or one of its dependencies could not be resolved: Failure to find org.apache.maven.plugins:maven-resources-plugin:jar:2.6 in http://nexus.choerodon.com.cn/repository/choerodon-release/ was cached in the local repository, resolution will not be reattempted until the update interval of choerodon-release-repository has elapsed or updates are forced -> [Help 1]
```
我的镜像库只有一个choerodon-release-repository，插件下载失败，于是我添加阿里镜像库解决问题。

### 坑2

intelli idea创建子模块后子项目的java文件夹下没有new -> class选项
<br>解决方法是在file->project struct为子项目指定文件夹类型，给java文件夹指定Sources

## 今日学习

### Maven深入学习

#### 使用mvn命令

- 创建项目 mvn archetype:create

```
mvn archetype:create
    -DgroupId=packageName
    -DartifactId=projectName
```

- 编译项目 mvn compile
> 下载依赖jar，生成字节码文件

- 测试项目 mvn test
> 写好项目的test后，运行该命令,新增surefire-reports,test-classes两个文件夹

- 打包项目 mvn -D package
> 打包项目， 生成target文件，-D debug

- 打包部署 mvn -D install 
> 一样也是打包项目但是比package指令多了install指令，既部署到私库和本地仓库


- 清除上次编译 mvn clean
> 删除target文件夹，既上次编译结果

- mvn install

#### pom.xml配置

添加插件
<build>
    <sourceDirectory>src/main/java</sourceDirectory>
    <finalName>maventest</finalName> <!--打包生成名-->
    <plugins>
        <plugin>
            <artifactId>maven-assembly-plugin</artifactId>
            <configuration>
                <appendAssemblyId>false</appendAssemblyId>
                <descriptorRefs>
                    <descriptorRef>jar-with-dependencies</descriptorRef>
                </descriptorRefs>
                <archive>
                    <manifest>
                        <mainClass>Main</mainClass> <!--主类入口-->
                    </manifest>
                </archive>
            </configuration>
            <executions>
                <execution>
                    <id>make-assembly</id>
                    <phase>package</phase>
                    <goals>
                        <goal>assembly</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>

- 凡哥要求打包生成的<strong>jar包要与工程同名</strong>

```
<build>
    <finalName>生成jar名</finalName>
</build>

```

- 有可能需要配置主类入口

```
<plugin>
    <artifactId>maven-assembly-plugin</artifactId>
        <configuration>
			<appendAssemblyId>false</appendAssemblyId>
                <archive>
                    <manifest>
                        <mainClass>java为基初路径</mainClass>
```
### shell脚本循环的编写
因为要用到shell脚本的循环语句来执行，所有浅显的看了看，发现脚步语言写法很接近
- shell脚本语句不用;分开，有点类似php
- shell脚本变量，a=1设置，使用的时候$a,进行使用
- 循环语句
```
for ((i=1;i<=3;i++))
   do
		执行语句
   done

```
- 字符串拼接直接写在一起即可如,${a}${b}即可链接ab字符串
### Java8的新特性
查了Java8的相关博客，一个劲的先介绍lambda表达式，让我很难理解，觉得吧如果接口里有多个函数怎么办
然后才知道函数式接口
#### 函数式接口

> 就是一个有且仅有一个抽象方法，但是可以有多个非抽象方法的接口。函数式接口是由JVM判定的，也可以 @FunctionalInterface注释生成，一般为一个接口，里面一个函数

#### Lambda表达式
了解函数式接口后，我才理解的Lambda表达式
```
(参数列表)->{表达式}
```
Lambda表达式就很简单，一个无名函数，定义了参数，以及函数里面的表达式，用法就是作为<strong><font color=#9BCD9B>函数式接口参数的实参</font></strong>
- 比如forEach()通过Lambda表达式实现输出List每个值，forEach((l)->{System.out.println(t))
- 比如Tread(函数接口)构造方法，原本
	```
	new Tread(new Runnable(){@override public void run(){xxxxxxx}}).start
	->
	new Tread(()->{xxxxx}).start

	```
- 方法的引用(与Lambda引用已有的方法相同，方法的引用来作为函数式接口形参的实参)
	- 构造器引用：它的语法是Class::new，或者更一般的Class< T >::new实例如下：
	```
	final Car car = Car.create( Car::new );
	final List< Car > cars = Arrays.asList( car );

	```
	- 静态方法引用：它的语法是Class::static_method，实例如下：
	```
	cars.forEach( Car::collide );
	```

	- 特定类的任意对象的方法引用：它的语法是Class::method实例如下：
	```
	cars.forEach( Car::repair );
	```

	- 特定对象的方法引用：它的语法是instance::method实例如下：
	```
	final Car police = Car.create( Car::new );
	cars.forEach( police::follow );

	```

- 默认方法
默认方法是对于接口来说的，实现<strong>接口函数的实现<strong>
```
	public interface xxx
	{
		default void xxxx()
		{
			xxxxxxx;
			xxxx;
		}
	}
```
	- 对于多个接口共同的默认方法可以通过interfaceClass.super.xx()来调用
	- 静态默认方法可以实现，直接方法名前加static即可

- Optional类
是个保存类型<T>的容器，可以保存null，可以解决空指针问题
```
Optional<T> a = Optional.ofNullable(T的对象)	//可以为NULL
Optional<T> b =Optional.of(T的对象)  //null则包NullPointExcption异常

常用方法
1	static <T> Optional<T> empty()
返回空的 Optional 实例。

2	boolean equals(Object obj)
判断其他对象是否等于 Optional。

3	Optional<T> filter(Predicate<? super <T> predicate)
如果值存在，并且这个值匹配给定的 predicate，返回一个Optional用以描述这个值，否则返回一个空的Optional。

4	<U> Optional<U> flatMap(Function<? super T,Optional<U>> mapper)
如果值存在，返回基于Optional包含的映射方法的值，否则返回一个空的Optional

5	T get()
如果在这个Optional中包含这个值，返回值，否则抛出异常：NoSuchElementException

6	int hashCode()
返回存在值的哈希码，如果值不存在 返回 0。

7	void ifPresent(Consumer<? super T> consumer)
如果值存在则使用该值调用 consumer , 否则不做任何事情。

8	boolean isPresent()
如果值存在则方法会返回true，否则返回 false。

9	<U>Optional<U> map(Function<? super T,? extends U> mapper)
如果存在该值，提供的映射方法，如果返回非null，返回一个Optional描述结果。

10	static <T> Optional<T> of(T value)
返回一个指定非null值的Optional。

11	static <T> Optional<T> ofNullable(T value)
如果为非空，返回 Optional 描述的指定值，否则返回空的 Optional。

12	T orElse(T other)
如果存在该值，返回值， 否则返回 other。

13	T orElseGet(Supplier<? extends T> other)
如果存在该值，返回值， 否则触发 other，并返回 other 调用的结果。

14	<X extends Throwable> T orElseThrow(Supplier<? extends X> exceptionSupplier)
如果存在该值，返回包含的值，否则抛出由 Supplier 继承的异常

15	String toString()
返回一个Optional的非空字符串，用来调试
```
- Java8时间日期改进
- Java8引入Base64编码

```
1	static Base64.Decoder getDecoder()
返回一个 Base64.Decoder ，解码使用基本型 base64 编码方案。

2	static Base64.Encoder getEncoder()
返回一个 Base64.Encoder ，编码使用基本型 base64 编码方案。

3	static Base64.Decoder getMimeDecoder()
返回一个 Base64.Decoder ，解码使用 MIME 型 base64 编码方案。

4	
static Base64.Encoder getMimeEncoder()

返回一个 Base64.Encoder ，编码使用 MIME 型 base64 编码方案。

5	static Base64.Encoder getMimeEncoder(int lineLength, byte[] lineSeparator)
返回一个 Base64.Encoder ，编码使用 MIME 型 base64 编码方案，可以通过参数指定每行的长度及行的分隔符。

6	static Base64.Decoder getUrlDecoder()
返回一个 Base64.Decoder ，解码使用 URL 和文件名安全型 base64 编码方案。

7	static Base64.Encoder getUrlEncoder()
返回一个 Base64.Encoder ，编码使用 URL 和文件名安全型 base64 编码方案。
  try {
        
         // 使用基本编码
         String base64encodedString = Base64.getEncoder().encodeToString("java8".getBytes("utf-8"));
         System.out.println("Base64 比那么字符串 (基本) :" + base64encodedString);
        
         // 解码
         byte[] base64decodedBytes = Base64.getDecoder().decode(base64encodedString);
        
         System.out.println("原始字符串: " + new String(base64decodedBytes, "utf-8"));
         base64encodedString = Base64.getUrlEncoder().encodeToString("TutorialsPoint?java8".getBytes("utf-8"));
         System.out.println("Base64 编码字符串 (URL) :" + base64encodedString);
        
         StringBuilder stringBuilder = new StringBuilder();
        
         for (int i = 0; i < 10; ++i) {
            stringBuilder.append(UUID.randomUUID().toString());
         }
        
         byte[] mimeBytes = stringBuilder.toString().getBytes("utf-8");
         String mimeEncodedString = Base64.getMimeEncoder().encodeToString(mimeBytes);
         System.out.println("Base64 编码字符串 (MIME) :" + mimeEncodedString);
         
      }catch(UnsupportedEncodingException e){
         System.out.println("Error :" + e.getMessage());
      }

```
### 设计模式
既解决问题时的coding方案，代码方式千千万，不同场合对类的设计函数的设计不同效果不同。
#### 工厂模式
顾名思义工厂模式就是，通过工厂类生成需要的对象，对于请求者需求选择的接口，通过对需求进心选择，生成对应的类，不需要知道生成逻辑。
<br>缺点类之间是会有很多的依赖
#### 抽象工厂模式
创建管理工厂的抽象类，该抽象工厂类包含所有可实例化工厂，既一个需求一个工厂。创建一个工厂生成类，用来生成工厂类，工厂类通过需求进行操作。
<br>个人感觉这种方式应该在需求种类多且固定的情况下使用，因为依赖太多。增加一个需求时要对抽象工厂，工厂生成器进行修改。
#### 单例模式
就是只能实例化一次，而且该实例化是该对象自己生成的。
- 只实例化一次的方法:将构造方法用private修饰
- 自己生成的方式:static修饰该类的实例化成员

#### 装饰器模式
装饰类用于给已有的对象动态扩展功能，互相独立，不耦合
<br>装饰类与被装饰类有共同接口，扩展时可以用装饰类的子类，对被装饰类进行功能扩展。
- 扩展具体实现方式:被装饰类作为<strong>装饰类的构造函数参数</strong>进行<strong>装饰类的实例化</strong>

#### mvc模式
- model 既业务逻辑，对数据进行逻辑操作
- view 将处理好的逻辑数据可视化的展现给用户
- controller 接收请求，并进行请求并调用model层处理数据并返回结构，控制view将结果显示给用户

--------07-19------------
## 学习计划

- Kafka&Zookeeper ✘
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- Java8新特性深入 ✘
- Java集合框架 ✘
- XML学习 ✘
- JSON学习 ✘
- JavaIO ✘
## 今天的坑

## 今日学习 

### Java集合框架

- <strong>Collection</strong>接口,继承Itetator接口，所有继承于collection接口的类都可以迭代遍历
    - <strong>List</strong>接口，有序可重复
        - ArrayList类，由数组实现，非线程安全，可以模拟队列。
        - LinkedList类，由链表实现，非线程安全
        - Vector类，由数组实现，与ArrayList类似，线程安全
            - Stack类，堆栈类，pop(空会抛出异常)，push，peek等操作
    - <strong>Set</strong>接口，无序且不可重复，
        - HashSet 存入顺序是按照哈希值来存入，通过hashCode+equal实现实现查重
            > hashCode查重是不可靠的，但是速度快，equal查重是绝对可靠的当是速度很慢，所有相结合，hashCode值不同则元素一定不同，但是相同则元素不一定相同，所以要在equal。
        - TreeSet 默认升序排列，使用红黑树实现，不可随机访问，只能通过迭代器访问

            ```
            for(Iterator iter = set.iterator();iter.hasNext();)
            { 
                iter.next();
            } 
            ```
        TreeSet()构造方法可以以比较器为参数
- <strong>Map</Strong>接口，<key,value>键-值对，对重复put给予覆盖
    - HashMap通过key和hashCode存储键值对，允许一个null键值对，非线程同步
    - TreeMap通过key值的[红黑树](http://www.cnblogs.com/skywang12345/p/3245399.html)结构，不允许unll，非线程安全
    - HashTable 与HashMap类似，但是不允许null，线程安全
    - LinkedHashMap有序的HashMap，允许null，非线程安全
- <strong>Iterator</strong>接口 用于迭代遍历容器元素，Iterable 也是通过Iterator实现的，一般都是类用实现Iterable接口而不是Iterator接口，因为防止迭代时next()互相干扰，而Iterable则是不互相干扰的。迭代过程中是不用集合自带的删除方法(会报错)，用迭代器自身的方法来移除元素。

### Java的IO

java的IO分为字符流和字节流
- 字节流以1字节为单元传输，byte代表一个字节，一个字节包含8个位，一般非字符类型，如图片，视频等
    - 字节流的操作不用到缓冲区，直接进行操作
- 字符流以字符为传输单元传输，一般纯文本格式，xml，json，txt操作用此方式。
    - 字符流的操作需要缓冲区，需要关闭才能输出

### 本地文件的操作
File类对文件夹及文件的操作
File file = new File("new-Test/test.txt");
		//判断文件是否存在
		System.out.println("文件是否存在：" + file.exists());
		//读取文件名称
		System.out.println("文件名称为：" + file.getName());
		//读取文件路径
		System.out.println("文件路径为：" + file.getPath());
		//读取文件绝对路径
		System.out.println("文件的绝对路径：" + file.getAbsolutePath());
		//获取文件父级路径
		System.out.println("文件父级路径：" + file.getParent());
		System.out.println("文件父级绝对路径：" + file.getParentFile().getAbsolutePath());
		//读取文件的大小
		System.out.println("文件的大小是：" + (float)file.length() / 1024 + "KB");
		//文件是否被隐藏
		System.out.println("文件是否被隐藏：" + file.isHidden());
		//文件是否可读
		System.out.println("文件是否可读：" + file.canRead());
		//文件是否可写
		System.out.println("文件是否可写：" + file.canWrite());
		//文件是否为文件夹
		System.out.println("文件是否是文件夹：" + file.isDirectory());
		//设置为只读
		file.setReadOnly();
		//设置为可写
		file.setWritable(true);
		//设置为可读
		file.setReadable(true);

		//file.mkdir();
		//创建文件夹
		file.mkdirs();
		
		//删除文件夹
//		if(file.exists()){
//			file.delete();
//		}
		
		//重命名文件夹
		File newfile = new File("new-Test");
		file.renameTo(newfile);
        创建文件
File file = new File("test.txt");
		try {
			//判断文件是否被创建
			if(file.createNewFile()){
				System.out.println("文件创建成功！");
			}else{
				if(file.exists()){
					System.out.println("文件已经存在，无需再次创建！");
				}else{
					System.out.println("文件创建失败！");
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}


### XML

文本标记语言，自定义表签，较于Json一般用于配置文件

#### XML文件的读取
在org.xml.dom里对xml的操作是抽象工厂模式，既抽象工厂类DocumentBuilderFactory，通过抽象工厂类创建除工厂类DocumentBuilder，通过工厂类对读写文件的选择生成.xml文档对象。

##### DOM方法
DOM方法是将整个XML写入内存

- 创建DOM模式的解析器对象DocumentBuilderFactory
DocumentBuilderFactory doc=DocumentBuilderFactory.newInstance()//工厂抽象类，根据本地信息创建工厂

- 用工厂对象的 newDocumentBuilder方法得到 DOM 解析器对象
DocumentBuilder db=doc.newDocumentBuilder();

- 把要解析的 XML 文档转化为输入流，以便 DOM 解析器解析它
InputStream is= new  FileInputStream("test.xml");     

- 调用 DOM 解析器对象的 parse() 方法解析 XML 文档，得到代表整个文档的 Document 对象，进行可以利用DOM特性对整个XML文档进行操作了。
Document doc=db.parse(is);

- 得到 XML 文档的根节点

Element root=doc.getDocumentElement();

- 得到节点的子节点

NodeList users=root.getChildNodes();

##### SAX方法
AX解析方式会逐行地去扫描XML文档，当遇到标签时会触发解析处理器，只用来读XML文件。

###

#### 文件的读写

------------------07-20--------------
## 学习计划

- Kafka&Zookeeper ✘
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- Java8新特性深入 ✘
- ~~XML学习 ✘~~
- ~~JSON学习 ✘~~
- ~~JavaIO ✘~~

## 今天的坑

## 今日学习 

### IO

#### 对文件内容的操作
区别与File类，这些流操作是对于文件内容的操作
<br>个人理解，这些输入输出流是指定类别的类型数据，有传输方法，不同类对类型的定义不同，在基础的流上进行包装，过滤，生成自己的流，也就是该类可传输的数据类型

- 字符流
	- Reader字符流读抽象类
            - BufferedReader 带缓冲区文件读 readLine()可以逐行读
            - InputStreamReader 逐字符读 InputStreamReader(new FileInputStream(path),"UTF-8")可指定编码
                - FileReader 由InputStreamReader继承来的
    - Writer字符流写抽象类 Writer字符流写抽象类
            - BufferedWriter  new BufferedWriter(new FileWriter("D:/trainning/demo.txt",true))加个true可在原文末尾添加而不覆盖
            - OutputStreamWriter 
                - FileWriter 
- 字节流
    - InputStream 字节流读抽象类
            - FileInputStream 字节读文件
            - FilterInputStream 一个具有装饰者作用的类，一般使用其子类镜像装饰。
                - BufferedInputStream 装饰类，扩展buffer功能
				- DataInputStream 扩展对数据类型的读取，从底层输入流中读取基本 Java 数据类型
    - OutputStream 
            - FileOutputStream 
            - FilterInputStream 
                - BufferedOutputStream 
				- DataOutpputStream 使用DataOutpputStream写入的数据要使用DataInputStream取出进来

### 网络通信

#### HTTP通信

##### Get请求方式
将请求信息放入到Url中进行请求

```
    URLConnection  = URL.openConnection();//获取网络连接
    InputStream = URLConnection.getInputStream();//获取Get返回的字节流

```
##### Post请求方式
Url只是请求地址，请求的信息需要放在List<BasicNameValuePair(Key,Value)>中。
```
List.add(new BasicNameValuePair(key,value));
post.setEntity(new UrlEncodedFormEntity(List,编码方式));//post请求设置参数
HttpResponse response = httpclient.execute(post);//获得请求回应
HttpEntity entity =response.getEntity();
String result = EntityUtils.toString(entity,"UTF-8");

```
##### 也可以使用W3C标准进行Http操作

#### Socket通信
Socket通信基于TCP协议，可靠面向连接的传输方式，既三次握手建立连接，以确认号保证可靠传输，保持长时间连接。
- 创建服务端的SocketServerSocket ss=new ServerSocket(12345);
- 监听端口是否有访问,Socket socket= ss.accept();方法是阻断的线程一直被占用且直到有访问
- socket输出流，socket.getOutputStream().write();用来信息交互
- socket输入流，socket.getIntputStream().read();

<dependencies>
        <dependency><!--httpclient-->
            <groupId>org.apache.httpcomponents</groupId>
            <artifactId>httpclient</artifactId>
            <version>4.5.6</version>
        </dependency>
        <dependency>
            <groupId>com.google.code.gson</groupId><!--gson-->
            <artifactId>gson</artifactId>
            <version>2.8.2</version>
        </dependency>
 </dependencies>

用Gson解析Json
　

Gson写入json
// 方法一
	public static void gsonW1() {
		JsonObject obj = new JsonObject();
		obj.addProperty("name", "小明");
		obj.addProperty("age", 20);
		obj.addProperty("car", false);
 
		JsonArray arr = new JsonArray();
 
		JsonObject o1 = new JsonObject();
		o1.addProperty("id", 1);
		o1.addProperty("name", "java");
 
		JsonObject o2 = new JsonObject();
		o2.addProperty("id", 1);
		o2.addProperty("name", "java");
 
		arr.add(o1);
		arr.add(o2);
 
		obj.add("hobby", arr);
 
		System.out.println(obj);
 
	}
 
	// 方法二
	public static void gsonW2() {
		Person p = new Person();
		p.setName("小明");
		p.setAge(20);
		p.setCar(false);
		p.setHobby(new String[] { "Java", "PHP" });
 
		Gson g = new Gson();
		System.out.println(g.toJson(p));
	}
+++
title = "2018-07-21"
weight = 90
+++

## 学习计划

- Kafka&Zookeeper ✘
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- Java8新特性深入 ✘



## 今日的坑

1. 对PDF写入乱码，PDF为非文本格式，适合用字节流进行输入输出

```
InputStream is = new BufferedInputStream(new FileInputStream("文件路径"));
//使用BufferedInputStream类增加缓冲功能
OutputStream os = new BufferedOutputStream(new FileOutputStream("文件路径"));

int length = 0;//用来记录缓冲区的大小
byte[] buffer = new byte[2024]; // 缓存字节设置为2m
while((length=is.read(buffer)) != -1){//如果内容长度不是空
    os.write(buffer, 0, length);//写入到新文件
}

```

2. 项目的编码方式与运行时指定的编码方式不同导致中文编码不同
3. 今天感受到了maven的好处，Gson依赖包通过Maven可更方便的导入，不用自行下载依赖包
4. Dom方式下对本地文件的写入不能直接用Document.toString()来需要

```

1）创建转换器工厂：TransformerFactory  factory=TransformerFactory.newInstance();

2）由工厂创建转换器实例：Transformer transformer=factory.newTransformer();

3）设置转换格式：transformer.setOutputProperty(属性，属性值);//设置输出到文档时的格式，比如：换行等

4）由转换器把dom资源转换到结果输出流，而结果输出流连接到一个xml文件：transformer.transform(new DOMSourse(dom),new StreamResult(xml_file));
DOM4j的写入就方便的多了如下:
XMLWriter xml = new XMLWriter(new FileOutputStream("file/books.xml"),format);

```
## 今日学习 

### JDBC

通过JDBC操作数据库——步骤：

1. 载入驱动(向虚拟机加载需要连接的数据库的驱动，如mysql的驱动，和其他的驱动)
    - Class.forName(“com.mysql.jdbc.Driver”),只用String类传入信息即可，不用载入驱动类
    - DriverManager.registerDriver(com.mysql.jdbc.Driver);需要传入驱动类
    - System.setProperty(“jdbc.drivers”, “driver1:driver2”);
2. 建立连接(Connection)
    - DriverManager.gerConnection(URL,user,password);
3. 创建运行SQL的语句

```
Statement st=conn.createStatement();
ResultSet rs=st.executeQuery("select * from user");

```
Statement类执行一次性操作，对于只运行一次的操作最好用该类

```
PreparedStatement conn.prepareStatement();
preparedstatement ps = connection.preparestatement(sql);
ps.setint(1,id);
ps.setstring(2,name);
resultset rs = ps.executequery(); 
```
PreparedStatemwnt类是对sql语句预编译的，重复操作适用，且可以适用占位符

4. 运行语句(Statement类和PreparesStatement类)

- execute执行增删改查操作
execute返回的结果是个boolean型，当返回的是true的时候，表明有ResultSet结果集，通常是执行了select操作，当返回的是false时，通常是执行了非查询操作。execute适用用于执行不明确的sql语句。
- executeQuery执行查询操作
executeQuery返回的是ResultSet结果集，通常是执行了select操作。

- executeUpdate执行增删改操作
executeUpdate返回的是int型，表明受影响的行数，通常是执行了数据库增删改语句。

5. 处理运行结果(ResultSet)结果集

```
while(resultSet.next()){
      getInt(列数)
      getString("string")
    }

```

6. 释放资源

需要对Connectin，Statement，ResultSet进行关闭
## 每周总结

本周学习了创建Maven项目，Java基础知识以及进阶的线程，IO，以及网络通信，http，socket通信
### Maven
Maven创建项目很方便
- 可以自动导入jar依赖包
- 打包很方便，只需mvn package即可
- 通过POM.XML对项目很方便的配置
- 对于子项目的管理也很方便

### 学习了Java基础
- String对象是final类不可以被改变，适合少量的操作，StringBuffer可改变对象内容且是线程安全的，StringBuilder相对于StringBuffer性能更高，但是非线程安全的
- 方法可能抛出异常的声明throws，throw可直接抛出异常类，需要捕获
- Java集合分为两大接口，Collection接口和Map接口，Collection是单个数据集合，Map是键值对数据集合，且key是不可重复的。
- Collection分为List和Set两大接口。List接口类似数组链表，Set接口不可重复，HashSet查重功能，TreeSet树结构数据，有排序功能
- Map接口有HashMap类，不可重复允许null的键值对，TreeSet类以key值进行排序存储，HashTable 与HashMap类似，但是不允许null线程安全，LinkedHashMap有存入顺序的HashMap。
- Java的IO类是真多，根据功能封装成不同的类。文件File类是属于文件操作的类并非内容炒作。对于内容的操作有，字符流的操作，适用于文本文件，字节流的操作，适用于非文本文件操作。字符流与字节流的操作以InputStreamReader/OutputStreamWriter为桥梁进行转换
- Java的Http通信，Get请求比较便捷，通过URL传参，不像Post请求需要额外写入参数List。
- Pocket通信可以用来即使通信，通过Socket创建客户端类，通过ServerSocket创建服务端类，通过获取字节流InputStream类进行数据传输，因为字节流是较为底层的数据流。
- 整理了Mysql操作笔记，因为较多就不写在总结里面。[Mysql操作笔记](Mysql);

## 今日学习

### MySql杂记

#### ResultSet没有提供获取大小的语句需要自己设置

1. 通过conn.prepareStatement(sql语句,TYPE_SCROLL_INSENSITIVE, CONCUR_READ_ONLY);
	- ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY // 可以滚动的
	- ResultSet.TYPE_FORWARD_ONLY // 只能向前滚动
	- ResultSet.TYPE_SCROLL_INSENSITIVE和Result.TYPE_SCROLL_SENSITIVE //实现任意的前后滚动
2. ResultSet.last();将结果滚到最后一条，int rowCount = resultSet.getRow()这个时候getRow就可以获取全部结果数
3. resultSet.beforeFirst();回滚到第一条，开始遍历查询

#### 查询非内容信息(表的属性等)
```
SHOW DATABASES                                //列出 MySQL Server 数据库。
SHOW TABLES [FROM db_name]                    //列出数据库数据表。
SHOW CREATE TABLES tbl_name                    //导出数据表结构。
SHOW TABLE STATUS [FROM db_name]              //列出数据表及表状态信息。
SHOW COLUMNS FROM tbl_name [FROM db_name]     //列出资料表字段
```
#### 表的修改
```sql

1.添加表字段
alter table 表名 add 字段名 数据类型(长度) not Null;非空

alter table   table1 add id int unsigned not Null auto_increment primary key;//auto_increment 是主键才能有的属性，自动增长值

2.修改某个表的字段类型及指定为空或非空
alter table 表名 modify 字段名称 字段类型 [是否允许非空];

3.修改某个表的字段名称及指定为空或非空
alter table 表名 change 字段名称 字段名称 字段类型 [not Null是否允许非空];

4.如果要删除某一字段，可用命令：
ALTER TABLE mytable DROP 字段名;

5.表重命名
alter table 表名 rename to 表重命名;

6.删除表

drop table 表名;

```


--------------------------7-23-------------------

## 学习计划
- Kafka&Zookeeper ✘
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- ~~~Java8新特性深入 ✘~~
## 今日的坑

- 报错:java:-source 1.5

<br>pom中加入：
```xml
<plugin>
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-compiler-plugin</artifactId>
	<configuration>
		<source>1.8</source>
		<target>1.8</target>
		<encoding>UTF-8</encoding>
	</configuration>
</plugin>

```
解决问题。
## 今日学习


environment: 
- "MY_ROOT_PASS":"root"
```
Sending build context to Docker daemon  3.426MB
Step 1/7 : FROM registry.saas.hand-china.com/tools/mysql:5.6
 ---> 15a5ee56ec55
Step 2/7 : ADD sakila-data.sql sakila-data.sql
 ---> 192ddbf2b0bb
Step 3/7 : ADD sakila-schema.sql sakila-schema.sql
 ---> be3eff410d77
Step 4/7 : CMD ["sh", "/mysql/setup.sh"]
 ---> Running in e653e9d4bdb3
Removing intermediate container e653e9d4bdb3
 ---> c9aee1e04a6d
Step 5/7 : RUN mysql -uroot -proot
 ---> Running in 19c2262c8d62
Warning: Using a password on the command line interface can be insecure.
Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock'

```
--------------------------7-24-------------------

## 学习计划
- Kafka&Zookeeper ✘
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- JSP ✘
- Servlet ✘
## 今日的坑
- docker-compose执行顺续可以通过depends_on设定，但是并不会等待执行完毕再执行下一条指令
	- 通过sleep或延迟使进程等待，依赖容器安装完毕再执行
	- shell脚本 nc -z url port 连接端口进行试探

## 今日学习

### 昨日考核试题完整要求解答

[Git连接](https://github.com/BLLeen/JavaTest3review)

- docker-compose 设置变量，在容器中可以通过$变量名获取
- docker-compose.yml 通过link获得相连镜像的环境变量

### JSP

####jsp标签 
- <%! %>声明代码，全局变量
- <%  %>局部代码
- <%= %>jsp表达式

### Mysql关联查询

#### 内连接查询

所有查询出的结果都是能够在连接的表中有对应记录的,既有关系的都会连接显示

```sql
select xxx from tablename1 inner jion teblename2 on 条件
```

```sql

//查询两表关联
select 
e.empName,d.deptName
from t_employee e
INNER JOIN t_dept d
ON e.dept = d.id;
```

#### 左外连接
是指以左边的表的数据为基准，去匹配右边的表的数据，如果匹配到就显示，匹配不到就显示为null
```sql
SELECT e.empName,d.deptName
from t_employee e
RIGHT OUTER JOIN t_dept d 
on d.id = e.dept;
```

#### 右外连接
同理，只是基准表的位置变化了而已

#### 全外连接
既有关联的进行关联，没关联的其他位置设为null
<br>mysql是没有全外连接的(mysql中没有full outer join关键字)，想要达到全外连接的效果，可以使用union关键字连接左外连接和右外连接。例如：

```sql
select e.empName,d.deptName
     FROM t_employee e 
     left JOIN t_dept d
     ON e.dept = d.id
UNION
select e.empName,d.deptName
     FROM t_employee e 
     RIGHT JOIN t_dept d
     ON e.dept = d.id;
```
#### 自连接查询

自连接查询就是当前表与自身的连接查询，关键点在于虚拟化出一张表给一个别名
```sql
SELECT e.empName,b.empName
     from t_employee e
     LEFT JOIN t_employee b
     ON e.bossId = b.id;
```

--------------------------7-25-------------------

## 学习计划
- Kafka&Zookeeper ✘
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- JSP ✘
- Servlet ✘
## 今日的坑

## 今日学习

### sql

#### Oracle使用distinct等价改写
低效：
```SQL
　　SELECT DISTINCT DEPT_NO,DEPT_NAME 
　　FROM DEPT D,EMP E 
　　WHERE D.DEPT_NO = E.DEPT_NO
```
高效写法：
```sql
　　SELECT DEPT_NO,DEPT_NAME 
　　FROM DEPT D 
　　WHERE EXISTS (SELECT 'X'
　　FROM EMP E 
　　WHERE E.DEPT_NO = D.DEPT_NO);
```
#### TRUNCATE语句和DELETE语句的区别
- truncate 为DDL，是清空表数据，删除后对字段默认初始值从1开始。因为对表清空
- delete 是DML，删除数据，字段默认初始值从已设置最大初始值开始。

#### 排序一般使用索引字段进行排序

#### null与null比较为false，一般用is null判断
```sql
delete from tablename where x is null ;
```
#### 对索引字段使用函数操作过程中不会使用该字段索引
#### length,lenghtb,substr,substrb
加上b为按字节操作
```sql
SELECT length('叶德华abc') -- length按字符计，汉字、英文、数字都是1个字符，故这里返回6
  FROM dual;
SELECT lengthb('叶德华abc') -- length按字节计，我这里是UTF-8编码，汉字3个字节，英文一个字节，故这里返回12
  FROM dual;
SELECT substr('叶德华abc', 1,4)-- substr按字符截取，截取到a，返回：叶德华a
  FROM dual;
SELECT substrb('叶德华abc',1,2) -- substrb按字节截取，2不足一个汉字长度，返回：两个空格
  FROM dual;
SELECT substrb('叶德华abc',1,3) -- substrb按字节截取，3刚好是一个汉字长度，返回：叶
  FROM dual;
SELECT substrb('叶德华abc',1,4) -- substrb按字节截取，4多余一个汉字少于两个汉字，返回：叶 加一个空格
  FROM dual;
```
#### oracle中nvl(函数)
NVL(表达式1，表达式2)如果表达式1为空值，NVL返回值为表达式2的值，否则返回表达式1的值。
<br>表达式1和表达式2的数据类型必须为同一个类型
<br>类似mysql中的ifnull(表达式1，表达式2)

#### 有null的字段无法建立索引，将null改为特殊定义的字符表示来建立索引

#### count(字段)对null值不会计入

不变的数据可以设置冗余字符

#### 临时表
- 数据库层面临时表，session临时表，事务级临时表，存储中间数据,会话结束或者事务结束的时候，这个临时表中的数据，不用用户自己删除，数据库自己会自动清除。

1. 会话级:会话结束清除

```sql

create global temporary table CUX.CUX_2_INV_MTL_TRX_TEMP
(
  trx_line_id             NUMBER,
  inventory_item_id       NUMBER,
  organization_id         NUMBER, 
  quantity                NUMBER
)
on commit preserve rows;
-- Grant/Revoke object privileges
grant select, insert, update, delete on CUX.CUX_2_INV_MTL_TRX_TEMP to APPSERP;
grant select on CUX.CUX_2_INV_MTL_TRX_TEMP to APPSQUERY;

```

2. 事务级:commit,rollback,会话结束，都会清除

```sql
create global temporary table CUX.CUX_2_INV_MTL_TRX_TEMP
(
  trx_line_id             NUMBER,
  inventory_item_id       NUMBER,
  organization_id         NUMBER, 
  quantity                NUMBER
)
on commit delete rows;

```

#### 执行计划
查看执行数据库过程计划，可以看出执行长短
table | type | possible_keys | key | key_len | ref | rows | Extra
|-----|-------|--------------|------|---------|----|------|-----|
- table 
显示这一行的数据是关于哪张表的
- type 
这是重要的列，显示连接使用了何种类型。从最好到最差的连接类型为const、eq_reg、ref、range、indexhe和ALL
- possible_keys 
显示可能应用在这张表中的索引。如果为空，没有可能的索引。可以为相关的域从WHERE语句中选择一个合适的语句
- key 
实际使用的索引。如果为NULL，则没有使用索引。
- key_len 
使用的索引的长度。在不损失精确性的情况下，长度越短越好
- ref 
显示索引的哪一列被使用了，如果可能的话，是一个常数
- rows 
MYSQL认为必须检查的用来返回请求数据的行数
- Extra 
关于MYSQL如何解析查询的额外信息

#### 约束

#### 视图：简化复制查询

- 普通视图不会优化速度
```sql
CREATE VIEW view_name AS select语句
```
- 物化视图(MATERIALIZED VIEW)会生成数据，但是是异步的，定时同步数据
```sql
CREATE MATERIALIZED VIEW bxj_objects_mv_t2 REFRESH FORCE AS SELECT * FROM bxj_objects_t2

```
```
1. 刷新的方式

Fast //增量刷新

Complete//完全刷新

Fource

2. 刷新的方法

DBMS_REFRESH.Refresh

DBMS_MVIEW.Refresh

```
- 针对表，比如数据字典，可以在不同数据库创建同名视图，保证程序可以跨平台使用

#### oracle主键通过创建序列进行自增与mysql主键自增长auto_increment不同

```sql
create sequence [schema.]sequence_name  
    [increment by n]  
    [start with n]  
    [maxvalue n|nomaxvalue]  
    [minvalue n|nominvalue]  
    [cycle|nocycle]  
    [cache|nocache]  
    [order|noorder]；  
  
INCREMENT BY: 指定序列号之间的间隔，该值可以为正或者负整数，但不可为0. 默认值为1；  
START WITH: 指定生成的第一个序列号，在升序时，序列从比最小值大的值开始，默认值为序列的最小值。对于降序，序列从比最大值小的值开始，默认值为序列的最大值；  

MAXVALUE: 指定序列可生成的最大值；  

NOMAXVALUE: 为升序指定最大值为POWER(10,27)，为降序指定最大值为-1；  

MINVALUE: 指定序列的最小值；  

NOMINVALUE: 为升序指定最小值为1，为降序指定的最小值为POWER(-10,26)；  

CYCLE：以指示在达到它的最大值或最小值之后，该序列将继续产生值。在一个上升序列到达它的最大值后，它会产生最小值。在一个递减序列到达它的最小值之后，它会产生最大值。  

NOCYCLE：当序列到达最大值或者最小值后，该序列不能产生值；这是默认的选项；  

CACHE：指定数据库在内存中预分配多少整数值用于快速访问。这个整数值可以是小于等于28位，最小值为2. 最大缓存的值必须小于等于下面公式计算出的值：  
       (CEIL (MAXVALUE - MINVALUE)) / ABS (INCREMENT)  
NOCACHE: 指定数据库不预分配缓存值。如果没有指定CACHE和NOCACHE，数据库默认缓存20个序列值； 

ORDER: 指定order条件保证序列按请求顺序生成。此条件适用于RAC环境;  

NOORDER: 不保证序列按请求顺序生成; 默认是NOORDER； 

``` 
#### 伪列
伪列只能查询，不能进行增删改操作
- rownum：逻辑编号，常用于分页查询
- rowid：物理位置
#### 索引
索引也是一张表，包含主键以及索引字段,是给系统使用的，在频繁查询的表里创建索引加快速度，当是在插入修改的时候会开销大来维护索引表。
- 单列索引，可以有多个单列索引
- 多列索引，多列组成一个索引
- 普通索引

```sql
CREATE INDEX indexName ON 表名(字段名(length)); //Blob和Text必须指定length 
```
- 唯一索引

```sql
索引字段列的值是唯一的允许null，多列索引的组合值是唯一的
CREATE UNIQUE INDEX indexName ON 表名(字段名(length));
```
- 索引最左前缀原则
index(a,b,c)=index(a),index(a,b),index(a,b,c)，把最常使用的字段列放在最左边
- 位图索引，查询单一简单的查询
#### rollup
group by a,b,v with rollup
<br>会加上a的总和行，b的总和行，(a,b)的总和行，都生成在同一个表里
```sql
部门          员工       工资
A             ZHANG     100 
A             LI        200 
A             WANG      300 
A             ZHAO      400 
A             DUAN      500 
B             DUAN      600 
B             DUAN      700

SELECT 部门,员工,SUM(工资)AS TOTAL 
FROM DEPART 
GROUP BY  部门,员工  WITH ROLLUP
结果如下：
部门           员工       工资
A             DUAN       500 
A             LI         200 
A             WANG       300 
A             ZHANG      100 
A             ZHAO       400 
A             NULL       1500 
B             DUAN       1300 
B             NULL       1300 
NULL       	  NULL       2800
```
#### 设置变量

```sql
SET @rownum:=0;
SELECT @rownum:=@rownum+1 AS rownum, actor.* FROM actor;可以设置变量作增1序列随着结果输出
```
#### 类型转换
#### 子查询
WITH AS短语，也叫做子查询部分，是用来定义一个SQL片断，该SQL片断会被整个SQL语句所用到。
```sql
with A as (sith A as (select * from class);
select *from A  
先执行select * from class   得到一个结果，将这个结果记录为A  ，在执行select *from A ,语句A表只是一个别名,查询结果会被记录到临时表，当一个查询块名字和一个表名或其他的对象相同时，解析器从内向外搜索，优先使用子查询块名字，重复使用结果。类似临时物化视图

```


----------------------07-26---------------------
## 学习计划
- Kafka&Zookeeper ✘
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- JSP ✘
- Servlet ✘
- Spring ✘

## 今日的坑

## 今日学习

### Spring
- 属性注入似乎是通过setXxx()进行注入的，当不写成员的bean,setXxx()时，无法进行注入
#### Ioc/DI
控制反转与依赖注入，将对象的创建，依赖关系，通过配置文件交予容器进行实现
- BeanFactory 主要功能是依赖注入，既通过Beans.xml创建需要的对象，并对对象进行属性注入。在java程序中通过 XmlBeanFactory.getBean获取相应对象
配置文件
```xml
 <bean id="boject" class="com.xx.Class">
       <property name="propertyName" value="xxx"/>
   </bean>
```
获取对象
```java
 XmlBeanFactory factory = new XmlBeanFactory
                             (new ClassPathResource("Beans.xml"));
      HelloWorld obj = (HelloWorld) factory.getBean("helloWorld");
```
- ApplicationContext类 拥有BeanFactory所有功能，并增加了其他功能
```

FileSystemXmlApplicationContext :从完整路径获取xml配置文件;
ClassPathXmlApplicationContext ：通过source文件下查找从applicationContext.xml配置文件。

```
获取配置文件进行对象初始化和注入
通过getBean()获取对象。

### Oracle sql练习

#### 日期操作
- 通过to_date()进行日期格式生成
```sql
to_date('2004-05-07 13:23:44','yyyy-mm-dd hh24:mi:ss')
```
- hh24 表示24小时制
- 获取当前系统时间sysdate
- 获取date的年月日时分秒的数字to_number(to_char(sysdate,'yyyy'/'mm'/'dd'/'h'/....))
- 获取两个时间的间距MONTHS_BETWEEN(end,begin);这是按月份为单位
- 日期自加，自减add_months(sysdate,num)正加负减 
- 英文格式显示日期to_char(hire_date,'dd-mon-yy','nls_date_language=american')
#### 字符拼接
mysql使用concat('xxx'+字段名+....)，可多个拼接
<br>oracle使用 || 进行拼接

#### 运算函数
- trunc(number) 取整，截断小数
    - trunc(number,-1)取到小数点后一位
    - trunc(number,1)将个位数取为0;
- mod(num1，num2)取模

#### or用union (all)替换会快

#### 截取
- substr(字段,左,右)
#### 最大值最小值问题
- 获取一个表(不进行分组)中某一字段的最大最小值的全行信息
```sql
select * from employees e where salary in (select max(salary) as maxsalary
from employees e)
```
#### 使用伪列获取单行数据
- 获得第一行数据，通过伪列 rownum =1进行条件筛选可以获得第一行数据
- 获取最后一行数据，select * from (select * from employees order by rownum desc) where rownum <=1
-------------07-27-----------
## 今日学习
### JAVA Spring
### bean
通过xml创建的,被注入属性的实例化对象
#### 属性
- class	指定用来创建 bean 的 bean 类。
- name	指定唯一的bean标识符。在基于XML的配置元数据中，可使用ID和/或name属性来指定 bean 标识符。
- scope	指定由特定的 bean 定义创建的对象的作用域
    - singleton 属性默认值，默认值在spring IoC容器仅存在一个Bean实例，Bean以单例方式存在，既在容器内共享一个对象
    - prototype	每次从容器中调用Bean时，都返回一个<strong>新的实例</strong>
    - request   每次HTTP请求都会创建一个新的Bean，该作用域仅适用于WebApplicationContext环境
    - session	同一个HTTP Session共享一个Bean，不同Session使用不同的Bean，仅适用于WebApplicationContext环境
    - global-session	一般用于Portlet应用环境，改作用于仅适用于WebApplicationContext环境
- constructor-arg	它是用来注入依赖关系的
- properties	它是用来注入依赖关系的
- autowiring mode	它是用来注入依赖关系的
- lazy-initialization mode	延迟初始化的 bean 告诉 IoC 容器在它第一次被请求时，而不是在启动时去创建一个 bean 实例。
- initialization 方法在 bean 的所有必需的属性被容器设置之后，调用回调方法的容器被销毁时，使用回调方法。

#### Bean的生命周期
Bean被实例化之后需要进行init，和destroy，初始化后不再使用需要将其移除容器，通过<bean>init-method，destroy-method属性指定初始化方法和销毁方法,这些方法在类内部被实现。

### Oracle SQL练习

#### case
具有两种格式:简单case函数和case搜索函数。
简单case函数
```sql
case sex
  when '1' then '男'
  when '2' then '女’
  else '其他' end

```
case搜索函数

```sql
case when sex = '1' then '男'
     when sex = '2' then '女'
     else '其他' end  
```
这两种方式，可以实现相同的功能。简单case函数的写法相对比较简洁，但是和case搜索函数相比，功能方面会有些限制，比如写判定式。case函数只返回第一个符合条件的值，剩下的case部分将会被自动忽略。
- 将sum与case结合使用，可以实现分段统计
如求男女人数
```sql
select
   sum(case u.sex when 1 then 1 else 0 end)男性,
   sum(case u.sex when 2 then 1 else 0 end)女性,
   sum(case when u.sex <>1 and u.sex<>2 then 1 else 0 end)性别为空
from users u;
```
#### to_char(date,'day')可得当前是星期几/'ddd'可得是一年之中第几天

#### 修改日期格式(对表进行操作)
ALTER session SET nls_date_format='yyyy-mm-dd hh24:mi:ss'
#### UTC时区偏移量
select TZ_OFFSET('地区') from dual;
日期格式大全
```SQL
Year:     
        yy   two digits 两位年                显示值:07
        yyy  three digits 三位年                显示值:007
        yyyy four digits 四位年                显示值:2007
Month:     
        mm    number     两位月              显示值:11
        mon    abbreviated 字符集表示          显示值:11月,若是英文版,显示nov    
        month spelled out 字符集表示          显示值:11月,若是英文版,显示november 
Day:     
        dd    number         当月第几天        显示值:02
        ddd    number         当年第几天        显示值:02
        dy    abbreviated 当周第几天简写    显示值:星期五,若是英文版,显示fri
        day    spelled out   当周第几天全写    显示值:星期五,若是英文版,显示friday       
        ddspth spelled out, ordinal twelfth
Hour:
        hh    two digits 12小时进制            显示值:01
        hh24 two digits 24小时进制            显示值:13
Minute:
        mi    two digits 60进制                显示值:45
Second:
        ss    two digits 60进制                显示值:25
其它
Q     digit         季度                  显示值:4
WW    digit         当年第几周            显示值:44
W    digit          当月第几周            显示值:1
24小时格式下时间范围为： 0:00:00 - 23:59:59....     
12小时格式下时间范围为： 1:00:00 - 12:59:59 ....
```
#### group by多个字段
GROUP BY X, Y意思是将所有具有相同X字段值和Y字段值的记录放到一个分组里
#### 标量子查询
select子句中包含单行子查询, 使用到外部连接，或者使用到了聚合函数，就可以考虑标量子查询
```sql
select 列1 ,(select 表2列1 from 表2 where .....))
```
类似外接查询,连接查询结果
#### grouping set
类似与多个group by查询联合起来
<br>比如
```sql
select A , B from table group by grouping sets(A, B) 
查询结果等价于
select A , null as B  from table group by A  
union all  
select null as A ,  B  from table group by B 
```
结果等价但是效率不等价啊，union的效率不如grouping set来的高，union多次扫描表进行union而
聚合是一次性从数据库中取出所有需要操作的数据，在内存中对数据库进行聚合操作并生成结果。
#### 递归查询
```sql
with hgonext as
(
   select *,0 as level from EnterPrise where DepartManage='Tom' --初始查询
   union all 
   select h.*,h1.level+1 from EnterPrise h join hgonext h1 on h.ParentDept=h1.Department
   --查询父节点为上一次查询结果的节点，通过内连接，只显示有相等的结果
)
select * from hgonext
```
递归查询就有点类似与树的层次遍历，先父节点，在夫节点的子节点直到子节点为空(既结果为空)
- 首先执行"select *,0 as level from EnterPrise where DepartManage='Tom'",如果不是第一次执行将返回空结果，因为tom.parenDept不可能指向自己，所有返回空
- 执行到“select h.*,h1.level+1 from EnterPrise h join hgonext h1 on h.ParentDept=h1.Department”，子节点结果与整个表进行内连接，得到子节点的行

#### system用户没有闪回功能的，需要用切换普通用户
- 创建用户create user 用户名 identified by 密码;
- 查看当前用户
    - 1、查看当前用户拥有的角色权限信息：select * from role_sys_privs;
    - 查看当前用户的详细信息：select * from user_users;
    - 查看当前用户的角色信息：select * from user_role_privs;
- 查看当前数据库名字show parameter db_name;
- 查看当前数据库实例select * from v$instance(需要管理员权限)

### kafka学习
#### kafka集群的创建(基于docker)
Kafka集群管理、状态保存是通过<strong>zookeeper<strong>实现，所以先要搭建zookeeper集群
##### zookeeper集群的创建(基于docker)
Zookeeper是分布式应用程序协调服务系统。它是集群的管理者，监视着集群中各个节点的状态根据节点提交的反馈进行下一步合理操作。最终，将简单易用的接口和性能高效、功能稳定的系统提供给用户。
<br>1. 对于kafka系统，最具有管理服务器，如master,slave
<br>2. 存储kafka系统元数据信息：包括consumerGroup/consumer、broker、Topic等
<br>基于JDK8运行环境的，所有需要JDK8环境
###### zookeeper配置
- conf目录下  /opt/zookeeper/zookeeper-3.4.6/conf 
    - configuration.xsl
    - log4j.properties
    - zoo_sample.cfg

zoo_sample.cfg
```
#tickTime：
这个时间是作为 Zookeeper 服务器之间或客户端与服务器之间维持心跳的时间间隔，也就是每个 tickTime 时间就会发送一个心跳。
#initLimit：
这个配置项是用来配置 Zookeeper 接受客户端（这里所说的客户端不是用户连接 Zookeeper 服务器的客户端，而是 Zookeeper 服务器集群中连接到 Leader 的 Follower 服务器）初始化连接时最长能忍受多少个心跳时间间隔数。当已经超过 5个心跳的时间（也就是 tickTime）长度后 Zookeeper 服务器还没有收到客户端的返回信息，那么表明这个客户端连接失败。总的时间长度就是 5*2000=10 秒
#syncLimit：
这个配置项标识 Leader 与Follower 之间发送消息，请求和应答时间长度，最长不能超过多少个 tickTime 的时间长度，总的时间长度就是5*2000=10秒
#dataDir：
快照日志的存储路径
#dataLogDir：
事物日志的存储路径，如果不配置这个那么事物日志会默认存储到dataDir制定的目录，这样会严重影响zk的性能，当zk吞吐量较大的时候，产生的事物日志、快照日志太多
#clientPort：
这个端口就是客户端连接 Zookeeper 服务器的端口，Zookeeper 会监听这个端口，接受客户端的访问请求。修改他的端口改大点
#server.1 服务器1
#server.2 服务器2
#server..... 服务器....
```
##### kafka集群的创建

###### kafka系统配置
/opt/kafka/kafka_2.11-0.9.0.1/config/server.properties
```
broker.id=0  #当前机器在集群中的唯一标识，和zookeeper的myid性质一样
port=19092 #当前kafka对外提供服务的端口默认是9092
host.name=192.168.7.100 #这个参数默认是关闭的，在0.8.1有个bug，DNS解析问题，失败率的问题。
num.network.threads=3 #这个是borker进行网络处理的线程数
num.io.threads=8 #这个是borker进行I/O处理的线程数
log.dirs=/opt/kafka/kafkalogs/ #消息存放的目录，这个目录可以配置为“，”逗号分割的表达式，上面的num.io.threads要大于这个目录的个数这个目录，如果配置多个目录，新创建的topic他把消息持久化的地方是，当前以逗号分割的目录中，那个分区数最少就放那一个
socket.send.buffer.bytes=102400 #发送缓冲区buffer大小，数据不是一下子就发送的，先回存储到缓冲区了到达一定的大小后在发送，能提高性能
socket.receive.buffer.bytes=102400 #kafka接收缓冲区大小，当数据到达一定大小后在序列化到磁盘
socket.request.max.bytes=104857600 #这个参数是向kafka请求消息或者向kafka发送消息的请请求的最大数，这个值不能超过java的堆栈大小
num.partitions=1 #默认的分区数，一个topic默认1个分区数
log.retention.hours=168 #默认消息的最大持久化时间，168小时，7天
message.max.byte=5242880  #消息保存的最大值5M
default.replication.factor=2  #kafka保存消息的副本数，如果一个副本失效了，另一个还可以继续提供服务
replica.fetch.max.bytes=5242880  #取消息的最大直接数
log.segment.bytes=1073741824 #这个参数是：因为kafka的消息是以追加的形式落地到文件，当超过这个值的时候，kafka会新起一个文件
log.retention.check.interval.ms=300000 #每隔300000毫秒去检查上面配置的log失效时间（log.retention.hours=168 ），到目录查看是否有过期的消息如果有，删除
log.cleaner.enable=false #是否启用log压缩，一般不用启用，启用的话可以提高性能
zookeeper.connect=192.168.7.100:12181,192.168.7.101:12181,192.168.7.107:1218 #设置zookeeper的连接端口
```

#### Kafka是一种高吞吐量的分布式发布订阅消息系统
- 分布式既这个系统分布式集群的使用
- 发布，既生产者推送消息给消费者
- 订阅，既消费者获取生产者的消息
- 高吞吐量具体支持多少有待学习

#### kafka名词
- Broker：Kafka集群上的服务器被称为broker
- Topic：每条发布到服务器的消息都有一个类别，这个类别被称为Topic(物理上不同Topic的消息分开存储)
- Partition：topic物理上的分组，每个Topic包含一个或多个Partition，每个partition是一个有序的队列
    - segment,partition物理上由多个segment组成
        - .index索引文件
        - .log数据文件
        - 索引文件中元数据指向对应数据文件中message的物理偏移地址
- Producer：负责发布消息到Kafka broker
- Consumer：消息消费者，向Kafka broker读取消息的客户端
- Consumer Group:每个Consumer属于一个特定的Consumer Group(可为每个Consumer指定group name，若不指定group name则属于默认的group)

#### kafka有四个核心API 
- producer API发布消息到1个或多个topic 
- consumer API来订阅一个或多个topic,并处理产生的消息
- streams API充当一个流处理器,从1个或多个topic消费输入流,并产生一个输出流到1个或多个topic,有效地将输入流转换到输出流
- connector API允许构建或运行可重复使用的生产者或消费者,将topic链接到现有的应用程序或数据系统

#### Producer
##### properties配置
```java
#需要kafka的服务器地址，来获取每一个topic的分片数等元数据信息。
metadata.broker.list=kafka01:9092,kafka02:9092,kafka03:9092

#生产者生产的消息被发送到哪个block，需要一个分组策略。
#指定分区处理类。默认kafka.producer.DefaultPartitioner，表通过key哈希到对应分区
#partitioner.class=kafka.producer.DefaultPartitioner

#生产者生产的消息可以通过一定的压缩策略（或者说压缩算法）来压缩。消息被压缩后发送到broker集群，
#而broker集群是不会进行解压缩的，broker集群只会把消息发送到消费者集群，然后由消费者来解压缩。
#是否压缩，默认0表示不压缩，1表示用gzip压缩，2表示用snappy压缩。
#压缩后消息中会有头来指明消息压缩类型，故在消费者端消息解压是透明的无需指定。
#文本数据会以1比10或者更高的压缩比进行压缩。
compression.codec=none

#指定序列化处理类，消息在网络上传输就需要序列化，它有String、数组等许多种实现。
serializer.class=kafka.serializer.DefaultEncoder

#如果要压缩消息，这里指定哪些topic要压缩消息，默认empty，表示不压缩。
#如果上面启用了压缩，那么这里就需要设置
#compressed.topics= 
#这是消息的确认机制，默认值是0。在面试中常被问到。
#producer有个ack参数，有三个值，分别代表：
// 0 不在乎是否写入成功；
// 1 写入leader成功；
// all 写入leader和所有副本都成功；
#要求非常可靠的话可以牺牲性能设置成最后一种。
#为了保证消息不丢失，至少要设置为1，也就
#是说至少保证leader将消息保存成功。
#设置发送数据是否需要服务端的反馈,有三个值0,1,-1，分别代表3种状态：
#0: producer不会等待broker发送ack。生产者只要把消息发送给broker之后，就认为发送成功了，这是第1种情况；
#1: 当leader接收到消息之后发送ack。生产者把消息发送到broker之后，并且消息被写入到本地文件，才认为发送成功，这是第二种情况；#-1: 当所有的follower都同步消息成功后发送ack。不仅是主的分区将消息保存成功了，
#而且其所有的分区的副本数也都同步好了，才会被认为发动成功，这是第3种情况。
request.required.acks=0

#broker必须在该时间范围之内给出反馈，否则失败。
#在向producer发送ack之前,broker允许等待的最大时间 ，如果超时,
#broker将会向producer发送一个error ACK.意味着上一次消息因为某种原因
#未能成功(比如follower未能同步成功)
request.timeout.ms=10000

#生产者将消息发送到broker，有两种方式，一种是同步，表示生产者发送一条，broker就接收一条；
#还有一种是异步，表示生产者积累到一批的消息，装到一个池子里面缓存起来，再发送给broker，
#这个池子不会无限缓存消息，在下面，它分别有一个时间限制（时间阈值）和一个数量限制（数量阈值）的参数供我们来设置。
#一般我们会选择异步。
#同步还是异步发送消息，默认“sync”表同步，"async"表异步。异步可以提高发送吞吐量,
#也意味着消息将会在本地buffer中,并适时批量发送，但是也可能导致丢失未发送过去的消息
producer.type=sync

#在async模式下,当message被缓存的时间超过此值后,将会批量发送给broker,
#默认为5000ms
#此值和batch.num.messages协同工作.
queue.buffering.max.ms = 5000

#异步情况下，缓存中允许存放消息数量的大小。
#在async模式下,producer端允许buffer的最大消息量
#无论如何,producer都无法尽快的将消息发送给broker,从而导致消息在producer端大量沉积
#此时,如果消息的条数达到阀值,将会导致producer端阻塞或者消息被抛弃，默认为10000条消息。
queue.buffering.max.messages=20000

#如果是异步，指定每次批量发送数据量，默认为200
batch.num.messages=500

#在生产端的缓冲池中，消息发送出去之后，在没有收到确认之前，该缓冲池中的消息是不能被删除的，
#但是生产者一直在生产消息，这个时候缓冲池可能会被撑爆，所以这就需要有一个处理的策略。
#有两种处理方式，一种是让生产者先别生产那么快，阻塞一下，等会再生产；另一种是将缓冲池中的消息清空。
#当消息在producer端沉积的条数达到"queue.buffering.max.meesages"后阻塞一定时间后,
#队列仍然没有enqueue(producer仍然没有发送出任何消息)
#此时producer可以继续阻塞或者将消息抛弃,此timeout值用于控制"阻塞"的时间
#-1: 不限制阻塞超时时间，让produce一直阻塞,这个时候消息就不会被抛弃
#0: 立即清空队列,消息被抛弃
queue.enqueue.timeout.ms=-1


#当producer接收到error ACK,或者没有接收到ACK时,允许消息重发的次数
#因为broker并没有完整的机制来避免消息重复,所以当网络异常时(比如ACK丢失)
#有可能导致broker接收到重复的消息,默认值为3.
message.send.max.retries=3

#producer刷新topic metada的时间间隔,producer需要知道partition leader
#的位置,以及当前topic的情况
#因此producer需要一个机制来获取最新的metadata,当producer遇到特定错误时,
#将会立即刷新
#(比如topic失效,partition丢失,leader失效等),此外也可以通过此参数来配置
#额外的刷新机制，默认值600000
topic.metadata.refresh.interval.ms=60000

```
- 需要引入slf4j的依赖包要不然会出现
```
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder" /报错 
```
slf4j是个日志框架，整合了常用的log4j日志框架
--------------------07-30---------
## 今日的坑
- 横轴为分数段[100-85]、[85-70]、[70-60]、[<60]，纵轴为课程号、课程名称
这道题的思路比较模糊，考完整理了一下
<br>通过case when语句进行每个人该分数段的值，是则1非则0，相对于形成一个列
<br>通过sum()对这个列进行统计总和

- 递归查询
以为是用with as 语法来实现递归
<br>oracle使用
```sql
select colname from tablename
start with 条件1
connect by 条件2
where 条件3;
条件1： 是根结点的限定语句，当然可以放宽限定条件，以遍历多个根结点，实际就是多棵树。
条件2：是连接条件，其中用PRIOR表示上一条记录。
比如 CONNECT BY PRIOR Id = Parent_Id就是说上一条记录的Id 是本条记录的Parent_Id。
条件3：过滤返回的结果集。
```
- 如果where a.x=b.x，b.x有一个为null，会将a的列也不显示，所有如果像显示的话，可以使用左连接，或者是oracle where a.x=b.x(+)改为左连接

列名 not in xxx可以优化为 not exit(select 1 from where 列名=xxx)
### oracle
#### 查询百分比
如获取及格人数的百分比的时候
```sql
select sc.course_no,sum(case when sc.core>=60 then 1 else 0 end)/count(*)*100||'%'  as passrate
from hand_student_core sc
group by sc.course_no
```
- sum(case when 统计条件 then 1 else 0 end)可以用来统计满足某种条件的个数

#### sql执行顺序
书写顺序 select from where group by having union order by
<br>执行顺序 from -> where -> group by ->运行分组函数-> having -> select ->order by

#### between and边界
Oracle的BETWEEN..AND..前后都是闭区间，也就是说包含两个端的数

#### group by
- 想select多个字段，要么出现在分组函数中，要么出现在group by后面
- 按group by顺序分组 

#### 排序列号
- row_number() over(partition by 分组依据字段 order by 排序字段 desc) rank from table名。
连续不重复，与rownum不同，rownum是不受分组的
- rank() over(partition by.....)
跳跃排序不连续重复序列,如值相同情况会出现12245
- dense_rank() over(...)from
连续排序可重复，如值相同会出现122345的情况

### Java Spring

#### 基于设值函数的依赖注入
调用一个无参的构造函数或一个无参的静态 factory 方法来初始化你的 bean 后，通过容器在你的 bean 上调用设值函数，为其依赖注入
<br>通过设置函数setXxxx()进行赋值
<br>如A类依赖B类
<br>通过对通过A类的setB(B b)进行设值
```xml
<bean id="a" class="A">
      <property name="b" ref="b"/>
</bean>
<bean id="b" class="B">
</bean>
```
#### 注入内部bean
通过在bean内部的属性内写bean进行注入
<bean id="a" class="A">
      <property name="b">
         <bean id="b" class="B"/>
       </property>
</bean>
#### 注入集合
与注入内部bean类似，集合类写setter()函数
<br>在xml中对类中的map对象创建实例
```xml
<property name="map">
        <map>
            <entry key="1" value="INDIA"/>
            <entry key="2" value="Pakistan"/>
            <entry key="3" value="USA"/>
            <entry key="4" value="USA"/>
        </map>
</property>
```
--------------------07-31---------
## 学习计划
- Kafka&Zookeeper ○
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- JSP ✘
- Servlet ✘
- Spring ✘

## 今日的坑
- 通过docker起了kafka集群,6个卡kafka-zookeepr容器，为其设置ip，但是每个容器的ip地址是随着开关随机分配的，这使得服务器配置信息需要动态改变。
- 百度一番，在docker-compose.yml中设置networks,通过ipv4_address属性设置局域网ip地址
```yml
networks:
   app_net:
        ipv4_address: 127.18.0.1
```
## 今日学习
### JAVA Spring
#### Bean的自动装配
<br>使得Bean的注入不需要通过ref=""进行连接
- bean的autowire="byName"属性通过依赖bean的id与属性对象名自动装配
- bean的autowire="bytype"属性通过依赖bean的名字与属性类名自动装配，总感觉这种方式好不严谨，看着难受
- bean的autowire="constructor"属性通过依赖bean的名字与与属性类名自动装配。
#### 基于注解的配置
<br>通过对类或方法进行注解镜像配置， 默认关闭该方式需要<context:annotation-config/>打开
- @Required 应用与setter()方法
- @Autowired 它会在方法中视图执行byType自动连接，XML文件中的setter方法中使用@Autowired注释来除去元素
- @Qualifier("student1")可以对对象通过指定bean名来指定注入
#### spring事件监听
<br>Spring 提供了以下5中标准的事件：
- 上下文更新事件（ContextRefreshedEvent）：该事件会在ApplicationContext被初始化或者更新时发布。也可以在调用ConfigurableApplicationContext 接口中的refresh()方法时被触发。
- 上下文开始事件（ContextStartedEvent）：当容器调用ConfigurableApplicationContext的Start()方法开始/重新开始容器时触发该事件。
- 上下文停止事件（ContextStoppedEvent）：当容器调用ConfigurableApplicationContext的Stop()方法停止容器时触发该事件。
- 上下文关闭事件（ContextClosedEvent）：当ApplicationContext被关闭时触发该事件。容器被关闭时，其管理的所有单例Bean都被销毁。
- 请求处理事件（RequestHandledEvent）：在Web应用中，当一个http请求（request）结束触发该事件。

通过实现ApplicationListener进行监听
#### spring自定义事件
<br>通过实现ApplicationEvent类自定义事件
<br>通过ApplicationEventPublisherAware类识别事件发布者

### Oracle语法函数
#### DECODE()函数
SELECT DECODE(columnname，值1,翻译值1,值2,翻译值2,...值n,翻译值n,缺省值(类似else))有点类似case when else语句
### Oracle优化

#### 硬解析与软解析
对新sql语句进行执行时会生成解析树与执行计划，如果该语句与之前的一样既hash值一样，就直接使用之前的编译结果，减少开销，这就是软解析，非此便是硬解析，索引sql语句尽量保持一致，空格都会破坏软解析
#### 索引抑制
- 使用不等于运算符<>
- IS NULL / IS NOT NULL
    - 使用位图索引BITMAP INDEX(低基数数列)
    - 使用NVL索引(适用于高基数列) Xx.xxx is null →nvl(xx.xxx,-99999) = -99999
- LIKE ‘%somevalue%’不可使用索引，’somevalue%’可使用索引
- 改变列值的函数如trunc() to_char()等
- WHERE 子句中存在表达式前后值为不同数据类型，则ORACLE 会产生隐式转换

#### 将多次扫描合并为一次
通过case语句将对此扫描通过条件分成多个case语句在一个表扫描中完成

#### 权衡外键的使用
- 使用外键的好处：1保证数据的完整性，2.关联查询时，可以用到foreigner key的统计信息
- 不使用外键的好处：1.删队或更新关联数据时不用做检查，效率会大符提高

#### 反范式化
范式化的目的是减少不必要的更新，减少存储空间，但是会减少访问速度，空间的代价相对于查询速度来说代价更小一些，所有对于更新少，查询多的表设计，不一定要范式化

#### 前缀索引(mysql)
以字段的前左前缀做索引，索引的选择性既不重复数/总数，这使得需要选择前缀长度，做到长度与选择性都适合。一般用于文本等较长的字段，以及字符串列(varchar,char,text等)，需要进行全字段匹配或者前匹配比如 =‘xxx’ 或者 like ‘xxx%'
```sql
alter table tablename add key(字段名(5))
```
#### liqubase
基于java6用于数据库重构和迁移的开源工具,通过日志文件的形式记录数据库的变更。就是一个将数据库脚本转化为xml格式保存起来，其中包含了对数据库的改变，以及数据库的版本信息，方便数据的升级和回滚等操作。

#### 数据备份，mysqldump组件(MYSQL)
mysql自带的数据备份组件，将数据库初始创建语句一起同数据备份，所有无需创建数据库再还原
<br>使用source命令将可将sql备份文件写入数据库

#### binlog日志
基于日志的数据库恢复，恢复速度太忙

#### mysql分库分表
通过分库分表实现大量数据的负载均衡
<br>mysql proxy原生自带实现“读写分离”，基本原理是让主数据库处理写方面事务，让从库处理SELECT查询
<br>国内有MyCAT，Atlas等分库分表中间件
#### 数据库版本号，防止对人操作，数据丢失


----------------------------08-01------------------------
## 学习计划
- Kafka&Zookeeper ○
- Spring ○
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- JSP ✘
- Servlet ✘

## 今日的坑
## 今日学习
### 一. JAVA Spring
#### 1. Spring框架的AOP
AOP既面向切面的编程,既在设置横切关注点，在该关注点设置执行前，执行后，执行插入的功能，比如日志，缓存等功能
##### a. 静态代理
- 不用依赖包，自己实现。代理类与被代理类实现同一个接口的方式实现。还有就是，代理类继承被代理类进行功能扩展
- 使用aspectJ实现在编译时生成代理类，在字节码文件中修改代理类
    
    ```java
        public aspect aspect1 {
            void around():call(void 代理类.sayHello()){
                System.out.println("开始事务 ...");
                proceed();//代理类的执行方法
                System.out.println("事务结束 ...");
            }
        }
    ```
##### b. 动态代理
<br>动态代理真正实现不在源码与字节码中修改，而是在内存中生成aop对象实现的
- JDK动态代理，使用InvocationHandler这个中介接口实现功能扩展，再通过Proxy类实现对中介接口类的代理化实例(代理类是被代理类的接口对象，接受Proxy.newProxyInstance()通过反射技术生成实现代理接口的匿名类的实例化)

    ```java

    public class 代理类 implements 接口 { 
        public void 接口构造函数() { 
        System.out.println("In sell method"); 
        } 
        public void 代理类本身方法() { 
        System,out.println("ad method") 
        } 
        } 
    }
    public class 中介类 implements InvocationHandler { 
        private Object obj; //obj为委托类对象; 
        public 中介类(Object obj) { 
        this.obj = obj; 
        } 
        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable { 
        System.out.println("before"); 
        Object result = method.invoke(obj, args); 
        System.out.println("after"); 
        return result; 
        } 
    } 

    中介类 中介对象 = new 中类(new Vendor()); //创建中介类实例 
    接口 接口对象 = (借口)(Proxy.newProxyInstance(接口.class.getClassLoader(), new Class[] {接口.class}, 中介对象)); //获取代理类实例,反射技术
    //通过代理类对象调用代理类方法，实际上会转到invoke方法调用 
      
    } 
    ```
- CGLIB实现动态代理,对被代理对象类的class文件加载进来，通过修改其字节码生成子类来处理(在内存中修改，并不在字节码文件中修改)<strong>(在被代理类没有实现接口的时候使用)<strong>

    ```java
        /*使用@Aspect*/
    @Aspect
    public class 被代理类 {

        public 被代理类(){   
        }
    
        @Pointcut("execution(* *.被代理类原本功能())")
        public void 被代理类原本功能(){}

        @Before("被代理类原本功能()")
        public void 被执行前方法(){
        }

        @AfterReturning("被代理类原本功能()")
        public void 执行后方法(){
        }
    }
    ```
    ```xml
        命名空间:
        xmlns:aop="http://www.springframework.org/schema/aop"
        schema声明:
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop-2.0.xsd
        加上这个标签:
        <aop:aspectj-autoproxy/> Spring就能够自动扫描被@Aspect标注的切面
    ```
    也可以纯xml配置方式实现
    ```xml
    <bean id="sleepHelper" class="test.spring.aop.bean.SleepHelper">
        <aop:config>
            <aop:aspect ref="sleepHelper">
            <aop:before method="beforeSleep" pointcut="execution(* *.sleep(..))"/>
            <aop:after method="afterSleep" pointcut="execution(* *.sleep(..))"/>
        </aop:aspect>
    </aop:config>
    ```
    因为使用代理类的子类进行添加功能所有该代理类不能说final修饰，虽然简洁方便，但是没有做到松耦合，这似乎和Spring的结耦合相悖论

### 2. 数据库优化

#### Oracle执行计划解读
类似树的后序遍历，最深靠上的先执行
<br>![执行计划](http://pcpj2g4mj.bkt.clouddn.com/18-8-1/56048433.jpg)
这个的执行顺序就是
```
                TABLE ACCESSFULL
                INDEXFULL SCAN
            HASH JOIN OUTER
        SORT HROUP BY
            INDENXFULL SCAN
        SORT AGGREGAT
    FILTER
SELECT STATEMENT,CAL=ALL_ROWS
```
- TABLE ACCESS BY …  即描述的是该动作执行时表访问(或者说Oracle访问数据)的方式
    - TABLE ACCESS FULL(全表扫描)
    - TABLE ACCESS BY ROWID(通过ROWID的表存取)
    - TABLE ACCESS BY INDEX SCAN(索引扫描可再分为具体种类)等
- 表的连接方式NESTED LOOPS(嵌套循环),还有HASH JOIN(哈希连接),CARTESIAN PRODUCT(笛卡尔积)等

#### pt-query-digest的使用
通过查询日志分析sql中可以优化的sql
1. 查询次数多且每次查询时间较长的sql
<br>通常为pt-query-digest分析的前个查询

2. IO大的SQL（数据库的瓶颈之一是IO）
<br>注意pt-query-digest分析结果中 Rows examine项

3. 未命中索引的SQL
<br>注意pt-query-digest分析结果中 Rows examine很大 但是Rows Sent很小

----------------------------08-02------------------------
## 学习计划
- Kafka&Zookeeper ○
- Spring ○
- docker swarm ✘
- dcoker容器间的通信 ✘
- 设计模式 ✘
- JSP ✘
- Servlet ✘

## 今日的坑
- 今天考试遇到很多坑，比如B+树索引的特性，不怎么理解
    1. k个子树有k个元素，每个元素不保存数据，只保存索引，数据保存在叶子节点
    2. 所有的叶子结点中包含了全部元素的信息，及指向含这些元素记录的指针，且叶子结点本身依关键字自小而大顺序链接
    3. 中间节点的元素同时保存在子节点中(与第2条相符，层次叠加到最后的叶子节点上)，在子节点中是最大或最小
- 在centOS7中安装mysql使用windows上的navicat连接时遇到10061问题
    - ping虚拟机IP地址没问题
    - 虚拟机的mysql运行正常
解决方法是通过防火墙放3306接口到外边网络
```

yum -y install iptables-services//安装防火墙
#然后开启3306端口
vim  /etc/sysconfig/iptables #编辑
#添加下面命令开启3306端口
-A INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT 
#重启防火墙
service iptables restart
```
问题解决

## 今日学习

### 一. JAVA Spring
#### 1. Spring JDBC
Spring JDBC使得我们使用的时候更加注重sql语句逻辑，只有连接错误处理，关闭连接的操作由框架完成
- Spring中对数据连接的配置
```xml
<bean id="dataSource"
class="org.springframework.jdbc.datasource.DriverManagerDataSource">
   <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
   <property name="url" value="jdbc:mysql://localhost:3306/TEST"/>
   <property name="username" value="root"/>
   <property name="password" value="password"/>
</bean>
```
对数据库执行操作的是JdbcTemplate类,确实简化了很多，代码看起来也比较没那么乱，是线程安全的，可以多线程执行操作。
- Spring对jdbc异常转化为自己体现的异常
    - InvalidResultSetAccessException:无效的结果集合访问异常 
    - DataAccessException:数据访问异常
对于异常的具体信息，需要将异常通过getCause()返回SQLExcetion

通用mapper
pagehelper
参数
异常处理
拦截器
spring boot 1.5.13
spring-cloud
curl
7 spring+mybites+xml
10 curl返回结果
tomcat 

#### 1. Spring JDBC

Exception in thread "main" org.springframework.beans.factory.BeanDefinitionStoreException:IOException parsing XML document from class path resource [applicationContext.xml]; nested exception is java.io.FileNotFoundException: class path resource [applicationContext.xml] cannot be opened because it does not exist

#### 延迟加载--bean的lazy-init属性
看到JdbcTemplate的构造方法有一个boolean参数，是lazy_init,表示延迟加载，被使用的时候才被加载
<br>Spring Bean有个属性也是lazy-init类似的，被使用的时候才被加载，对于prototype多例来说本来是使用的时候(被getBean，被其他bean使用)被加载，而对于singleton单例来说，设置lazy-init可以使得被使用的时候被加载

#### JdbcTemplate类
<br>执行SQL语句，获得结果集，捕获异常并转换
##### 执行操作
如果不是简单的一个简单数据的查询，为了配合spring的Ioc和Aop思想，应该将这些操作进行整合，包装。既有一个对象数据访问对象掌控数据--DAO
- 一个DAO接口包含对对象包含所需要操作的
- 一个数据对象类
- 一个继承RowMapper的数据对象Mapapper类用来对结果集进行生成List操作
- 一个实现DAO接口的数据对象DAO类
    - 实现接口的数据访问操作(增删改查)
    - DataSouerce对象连接数据(通过注入)
    - JdbcTemplate对象(通过注入)实现sql操作
    - 数据对象

这样满足Ioc如果对于数据对象DAO接口的操作可以通过AOC进行扩展
##### 结果获取
- ResultSetExtractor接口

```java
jdbcTemplate.query(sql,
               new ResultSetExtractor(){
                   @Override
                   public Object extractData(ResultSet rs) throws SQLException,
                           DataAccessException {
                       while (rs.next()) {
                           rs.getByXxxx();
                       }
                       return 0;
                   }
               }
               );
```
相对于java的jdbc的结果集获取需要自己写next(),通过实例化接口的匿名类来传参
- RowCallbackHandler接口

```java
 jdbcTemplate.query(sql, new RowCallbackHandler() {
           @Override
           public void processRow(ResultSet rs) throws SQLException {
               System.out.print(rs.getString("actor_id"));
               System.out.print(" "+rs.getString("first_name"));
               System.out.print(" "+rs.getString("last_name"));
               System.out.println();
           }
       });
```
对ResultSetExtractor操作的简化使得只要写即可每次的操作即可，循环判断由spring完成
- RowMapper接口

返回值为List<自定义类型>，这个接口将查询结果返回为自定义的类的List
```java
List<E> elist = (List<E>)EDao.getJdbcTemplate().  
query("select * from T_USER", new RowMapper(){  
            @Override  
            public Object mapRow(ResultSet rs, int rowNumber)   
throws SQLException {  
                E e = new E();  
                E.setXxx(rs.getXxx());  
                E.setXxx(rs.getXxx());  
                elist.add(e)
                return user;  
            }  
      });  
```

--------------------08-04----------
## 今日的坑
- MyBatis在ActorMapper接口+ActorMapper.xml进行查询遇到
```
org.apache.ibatis.binding.BindingException: Invalid bound statement (not found): com.xiong.ActorMapper.findByname
```
### 分析
ActorMapper接口中定义方法findByname(),ActorMapper.xml中定义查询语句,需要将接口和xml绑定在一起,在MyBatis全局配置文件中进行配置。
```xml
<mappers>
    <mapper resource="ActorMapper.xml"/>
    <mapper class="com.xiong.ActorMapper"/>
  </mappers>
```
百度一下说是在ActorMapper.xml的namespace配置ActorMapper接口的路径但是出现
```
Type interface com.xiong.ActorMapper is already known to the MapperRegistry
```
于是删除全局配置文件终端<mapper class="com.xiong.ActorMapper"/>问题解决
<br>原因可能是


-----------------------The 4th Week----------
## 今日的坑

## 本周总结
### 一. Sql的优化
#### 1. 对Mysql的优化是通过:
- 表的设计适当的反范式化(适当增加冗余数据，将数据放在一个表里增加访问速度)
- 添加适当索引(普通索引、unique index、全文索引等),过多的索引会增加插入效率，同时避免sql语句出现索引抑制
- 分库分表
    - 水平分割(通过MRG_MySIAM存储引擎将一个表数据分到多个表中)
    - 垂直分割(将不经常查询的数据较大字段分成另一张表)
- 读写语句优化
    - not in xxx可以优化为 not exit(select 1 from where 列名=xxx)
    - count(*)的优化
        - a. select count(*) from world.city where id > 5; 
        - b. select (select count(*) from world.city) – count(*) from world.city where id <= 5;
        - b语句更快，因为count(*)没有where数据库可以很快获得
    - 避免使用!=或<>、IS NULL或IS NOT NULL、IN ，NOT IN等,会是索引失效,能用exists语句代替的就用exists
    - BETWEEN语法代替IN
    - GROUP BY分组，建立索引，分组前WHERE过滤掉数据
- mysql服务器硬件升级

##### 性能监控工具Percona Toolkit工具集
<br>基于日志的性能分析，慢日志。
- 开启慢日志(默认关闭)log_slow_queries
<br>通过不同的命令获取性能信息比如pt-duplicate-key-checker(列出并删除重复的索引和外键)等信息
##### 执行计划图形化工具Workbench
红色为严重使用资源，绿色为合理范围内的资源消耗
### Oracle优化
与上的Mysql类似sql操作等优化
#### 性能数据收集工具AWR
用来分析Oracle数据库的读写性能,TOP耗时的sql语句。 

### 二. Spring框架的学习
Spring框架的功能IOC/DI,AOP,Spring JDBC
## 今日学习

---------------Spring+Mybatis整合-------------------
## 学习计划

- ~~Spring ○~~
- ~~Mybatis ○~~
- ~~Spring+Mybatis整合 ○~~
- 设计模式 ○
- Kafka&Zookeeper ○
- Spring MVC ✘
- Spring Boot ✘
- docker swarm ✘
- dcoker容器间的通信 ✘

## 今日的坑

## 今日学习

### Spring+Mybatis整合
整合方案很多看着头大找了一个比较简单的整合方式

- 将对数据库的连接通过org.apache.commons.dbcp2.BasicDataSource类连接数据库
<br>通过在spring的配置文件对数据源进行配置
<br>org.apache.commons需要导入依赖包
```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-dbcp2</artifactId>
    <version>2.5.0</version>
</dependency>
```
#### Spring的配置文件
```xml
<!--这个类可以获取环境变量-->
 <bean id="propertyConfigurer" class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer"/>
<!--这个类可以获取环境变量-->
<bean id="dataSource" class="org.apache.commons.dbcp2.BasicDataSource" destroy-method="close">
    <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
    <property name="url" value="${MYSQL_URL}"/>
    <property name="username" value="${MYSQL_ROOT_PASSWORDS}"/>
    <property name="password" value="${MYSQL_ROOT_PASSWORDS}"/>
</bean>
<!-------------------------------------------------------------------------------------->
<!--这个是根据配置文件properties导入的数据库连接参数-->
<bean id="propertyConfigurer"class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
    <property name="location" value="classpath:jdbc.properties"/>
</bean>
<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">  
    <property name="driverClassName" value="${jdbc.driverClassName}"/>
    <property name="url" value="${jdbc.url}"/>
    <property name="username" value="${jdbc.username}"/>
    <property name="password" value="${jdbc.password}"/>
</bean>

<!------------------------------------------------------------------------------------->
<!--对SqlSessionFactory的配置-->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSource"/>
        <property name="configLocation" value="classpath:applicationContext-mybatis.xml"/><!--引入MyBatis配置文件-->
        <!--这个MyBatis配置文件目前只使用到来用来写<mappers>其他用途目前还没有应用到-->
</bean>
```
配置方式有所不同，其他的差不多,Mapper.xml与单独的mybatis没什么差别,就是使用之前mybatis的demo里的文件没有修改没什么问题出现
--------------08-07----------------
## 学习计划

- ~~Spring ○~~
- ~~Mybatis ○~~
- ~~Spring+Mybatis整合 ○~~
- 设计模式 ○
- Kafka&Zookeeper ○
- Spring MVC ✘
- Spring Boot ✘
- docker swarm ✘
- dcoker容器间的通信 ✘

## 今日的坑
- spring+mybatis以spring@Transactional注解的事务管理,第一个方法异常catch后第二个方法运行时报错
    ```java
    Error updating database.  Cause: java.sql.SQLException: connection holder is null
    ```
    - 分析:通过session的getConnect()查看状态,第一个方法抛出异常后数据库连接会关闭
    - 解决方法:再次通过会话工厂打开会话即可

- 还有一个大坑就是项目打包后出现
    ```
    Unable to locate Spring NamespaceHandler for XML schema namespace [e [http://www.springframework.org/schema/aop]
    ```
    - 解决方法:不要使用assembly插件,这个插件会把同名的文件忽略,要使用maven-shade-plugin插件
    
## 今日学习

### Mybatis事务
Mybati的seesion需要commit()才会插入数据库,使用Spring管理事务可以自动完成commit(),close()以及rollback()
<br>Spring对MyBatis事务管理的支持是通过aop来实现的所以需要的依赖需要有aop的依赖包

#### 使用Mybatis事务管理
如果想使用Mybayis的事务管理,在配置SqlSessionFactory的时候如下配置
```xml
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
  <property name="dataSource" ref="dataSource" />
  <property name="transactionFactory">
    <bean class="org.apache.ibatis.transaction.managed.ManagedTransactionFactory" />
  </property>  
</bean>
```
如果想使用Spring的事务管理
```xml
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
       <property name="dataSource" ref="dataSource"/>
       <property name="configLocation" value="classpath:applicationContext-mybatis.xml"/>

   </bean>
    <bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource" />
    </bean>
    <tx:annotation-driven transaction-manager="txManager" />
```
使用以上配置即可将事务管理改为Spring的事务管理

#### mybatis获取执行时间
题目要求拦截器,完全没有头绪,不懂什么拦截器,想着使用面向切面的方法对Mapper接口进行切面插入开始计时器和结束计算机获取执行时间。
```java
long startTime;
    public void beforeAdvice(){
        startTime = System.currentTimeMillis();
    }
    public void afterAdvice() {
        System.out.println("sql执行时间"+(System.currentTimeMillis()-startTime)+"ms");
    }
```
```xml
 <bean id="getSqlTime" class="com.hand.service.GetSqlTime"></bean>
    <aop:config>
        <aop:aspect id="sqltime" ref="getSqlTime">
            <aop:pointcut id="sql"
                          expression="execution(* com.hand.service.Insert.insert2(..))"/>
            <aop:before pointcut-ref="sql" method="beforeAdvice"/>
            <aop:after pointcut-ref="sql" method="afterAdvice"/>
        </aop:aspect>
    </aop:config>
```
可以得出结果,可是想想,mybatis对sql处理的时间也会被计算在里面,精确度可能不大

#### MyBatis拦截器
>可以选择在这些被拦截的方法执行前后加上某些逻辑
<br>看着有点像是AOP,可以对执行sql语句的方法进行拦截
运行以下这些接口方法的拦截,这些方法包含了大多数操作,
- Executor (update, query, flushStatements, commit, rollback, getTransaction, close, isClosed)
- ParameterHandler (getParameterObject, setParameters)
- ResultSetHandler (handleResultSets, handleOutputParameters)
- StatementHandler (prepare, parameterize, batch, update, query)

```java
@Intercepts({@Signature(
  type= Executor.class,
  method = "update",
  args = {MappedStatement.class,Object.class})})
public class ExamplePlugin implements Interceptor {
  public Object intercept(Invocation invocation) throws Throwable {
    return invocation.proceed();
  }
  public Object plugin(Object target) {
    return Plugin.wrap(target, this);
  }
  public void setProperties(Properties properties) {
  }
}
```
<br>Interceptor接口，通过实现该接口就可以定义拦截器,指定被拦截的方法
-------------------------08-08-----------
## 学习计划

- 设计模式 ○
- Kafka&Zookeeper ○
- Spring MVC ○
- Spring Boot ✘
- docker swarm ✘
- dcoker容器间的通信 ✘

## 今日的坑

## 今日学习

### Spring MVC



##### @Controller
用于标记在一个类上，使用它标记的类就是一个SpringMVC Controller 对象。分发处理器将会扫描使用了该注解的类的方法，并检测该方法是否使用了@RequestMapping 注解。

##### @RequestMapping("/xxx")
用来处理xxx请求地址映射的注解，可用于类或方法上。用于类上，表示类中的所有响应请求的方法都是以该地址作为父路径。
<br>方法的返回值会被SpringMCV配置文件中的解析器解析为物理视图既为prefix/返回值/suffix(/WEB-INF/jsp/xxx.jsp)
```xml
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/jsp/" />
        <property name="suffix" value=".jsp" />
</bean>
```
###### @RequestMapping的请求
除了URL请求外，还可以使用请求方法，请求参数，请求头来精确映射请求。value(URL)、method(请求方法)、params(请求参数) 及 heads(请求头)。
####### params 和 headers支持简单的表达式：
- param1: 表示请求必须包含名为 param1 的请求参数 
- !param1: 表示请求不能包含名为 param1 的请求参数 
- param1 != value1: 表示请求包含名为 param1 的请求参数，但其值不能为 value1 
- {“param1=value1”, “param2”}: 请求必须包含名为 param1 和param2的两个请求参数数，且 param1 参数的值必须为 value1

##### @PathVariable
```java
@RequestMapping(value = "/test/{username}")
String test(@PathVariable("username")String username){}
```
可获取占位符的值
##### HiddenHttpMethodFilter过滤器
在restful架构中实现表现层状态转化,既URL是资源或是服务,不是具体的操作,那将操作交给请求方式实现，需要实现GET用来获取资源，POST用来新建更新资源，PUT用来更新资源，DELETE用来删除资源。通过POST方式模拟这四种操作。
<br>首先是配置这个过滤器
```xml
<filter>
    <filter-name>HiddenHttpMethodFilter</filter-name>
    <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
</filter>

    <!--配置对那些进行过滤,这里过滤所有请求-->
<filter-mapping>
    <filter-name>HiddenHttpMethodFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>

```
视图的写法(这是一个模拟Get请求对应于select获取)
```jsp
<form action="/xxx/参数(比如id)" method="post">
    <input type="hidden" name="_method" value="GET">
    <input type="submit" value="submit">
</form>
```
Controller的写法(这里控制在页面上输出得到的参数,id)
```java
@Controller
public class HMethodFilterTest {
    @RequestMapping(value = "/xxxx/{参数名}",method = RequestMethod.PUT)
    @ResponseBody
    String toputtest(@PathVariable("参数名") String id) {
        return id;
    }
}

```
-------------------------08-09------------
## 学习计划

- 设计模式 ○
- Kafka&Zookeeper ○
- Spring MVC ○
- Spring Boot ✘
- docker swarm ✘
- dcoker容器间的通信 ✘

## 今日的坑

## 今日学习

### Spring MVC
#### @RequestParam
获取URL上?xx=xx&xx=xx上的参数
<br>@RequestParam(value="xx",required=true,default="xx")是否必须,无值时默认值是xx
#### @RequestHeader
用法与RequestParam类似,获取如下信息的参数
[Header](http://pcpj2g4mj.bkt.clouddn.com/18-8-9/17628758.jpg)
#### @CookieValue
获取Header上的cookie值
#### pojo作为参数
可将表单里的信息获取，以普通实体类的方式获得，直接在mapping方法中设参即可，可以级联属性,级联属性在表单里通过对象名.属性作为表单的name,如name="address.id"
#### mapping方法使用servlet原生的API
mappring的方法可以使用以下servlet原生API
```servlet
1.HttpServletRequest
2.HttpServletResponse
3.HttpSession
4.Writer
5.Reader
6.OutputStream
7.InputStream
8.java.security.Principal
```
#### 处理模型数据ModelAndView (请求域内)
ModelAndView类就是Model+View在view上添加Model模型
```java

public ModelAndView modelAndView(){
    ModelAndView modelAndView=new ModelAndView("index");//视图
    modelAndView.addObject("World","hello");//添加键值对
    return  modelAndView;//返回一个添加了数据模型的键值对
}
/*在Jsp视图中可以使用的时候*/
${requestScope.Word}的方式获取这个键的值

```
#### Map方式进行处理 (请求域内)
往Mapping方法内传入Map参数,往Map对象内放入数据,即可数据绑定到视图上
```java
public String MapTest(Map map)
{
    map.put("names", Arrays.asList("lin","song","xiong"));
    return "index";
}
//与ModelAndView类似可以通过${requestScope.names}的方式获取这个键的值

```
#### @SessionAttributes
这个注解的作用是将数据模型存放在session中就不仅仅是请求域里面
```java
//使用方法是修饰Controller类,然后指定需要放入session域中的数据,可以是普通参数,也可以是参数类型
@SessionAttributes(types = {User.class,Dept.class},value={“attr1”,”attr2”})
```
#### @ModelAttributes
- 在<strong>方法定义<strong>上使用@ModelAttribute注解:Spring MVC 在调用目标处理方法前，会先逐个调用在方法级上标注了@ModelAttribute 的方法

- 在<strong>方法的入参前<strong>使用@ModelAttribute注解:可以从隐含对象中获取隐含的模型数据中获取对象，再将请求参数–绑定到对象中，再传入入参将方法入参对象添加到模型中(用于数据的修改操作)

### Spring Boot学习
可以简化开发,简化Spring的配置,可以不需要XML配置。Spring Boot内置了tomcat可以不用tomcat运行程序,直接执行@SpringBootApplication注解的类的主方法即可
#### 外部配置
application.properties可以用来配置数据，日志等。可以通过@Value("${xx}")对变量赋值
<br>配置可以在java -jar xxx.jar --xxx=xxx，这是可以关闭的,通过。SpringApplication.setAddCommandLineProperties(false)。
<br>对于多个配置环境,可以使用application-{name}.properties命名,在主application.properties内使用spring.profiles.active=name的方式指定使用哪一个配置文件进行配置。
###### 获取配置文件的数据
<br>将数据封装成一个类然后使用@component对该类表明是一个java Bean
<br>使用@ConfigurationProperties(prefix = "xxxx")提取出以xxxx为前缀的属性值自动绑定到对应的字段中。感觉自动性好高,不用特意为每个字段赋值,只要字段的名字与xxx.的后缀相同即可

#### Spring Boot的热部署
通过JVM Hot-swapping可以直接使用热部署既不需要通过重新容器，但是JVM Hot-swapping对于能够替换的字节码有些限制，所以使用Spring Loaded这种方式不能直接运行main方法进行启动需要mvn spring-boot:run 启动
 <dependency>
        <groupId>org.springframework</groupId>            <artifactId>springloaded</artifactId>
        <version>1.2.6.RELEASE</version>
</dependency>

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional> 
</dependency>
```

#### 集成mybatis和mysql支持
```xml
<!-- mybatis -->
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>1.1.1</version>
</dependency>
<!-- mysql -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.21</version>
</dependency>

```
可以实现热部署,既如何类出现变化都会被JVM类加载,不需要重新加载即可看到结果





spring mvc
spring + springmvc + mybatis
springboot: https://docs.spring.io/spring-boot/docs/1.5.13.RELEASE/reference/htmlsingle/
spring4all: http://www.spring4all.com/article/246
spring boot + springmvc + mybatis


--------------------------08-10---------------
### HttpServletRequest和HttpServletResponse
#### HttpServletRequest
代表请求对象,包含客户机信息
- getRequestURL  返回客户端发出请求时的完整URL。
- getRequestURI  返回请求行中的资源名部分。
- getQueryString 返回请求行中的参数部分。
- getPathInfo    返回请求URL中的额外路径信息。额外路径信息是请求URL中的位于Servlet的路径之后和查询参数之前的内容，它以“/”开头。
- getRemoteAddr  返回发出请求的客户机的IP地址。
- getRemoteHost  返回发出请求的客户机的完整主机名。
- getRemotePort  返回客户机所使用的网络端口号。
- getLocalAddr   返回WEB服务器的IP地址。
- getLocalName   返回WEB服务器的主机名。

客户机请求参数(客户端提交的数据)
- getParameter(String) 
- getParameterValues(String name)
- getParameterNames()
- getParameterMap()方法

#### HttpServletResponse
服务端响应对象
向客户端发送信息的方法
- getOutputStream() 返回一个ServletOutputStream类用来字节流传输
- getWriter() 返回一个java.io.PrintWriter类来传输字符流

### 隐藏域
在RESTful写求方式的时候用到了type="hidden"这个属性,这个属性代表这个标签是对于客户端不可见的

### 如果希望服务器输出什么浏览器就能看到什么，那么在服务器端都要以字符串的形式进行输出

### PageHelper
实现select * from table limit x,x操作然后将结果通过分页分成多页
```java
@RequestMapping("/")
Resultlist(HttoServletRequest request,HttpServletResponse respons,Model model,Integer page){
    PageHelper.startPage(page,everyNum);
    List<User> users = selectByList();
    PageInfo pageinfo =new PageInfo(users);
    model.addAttribute("page",page);
    model.addAttribute("users",users);  
}
```
### JPA
JAVA持久层API,使程序以统一的方式访问持久层


### Mybatis全注解操作

对于一个插入语句,可以使用@Insert注解,#{}获取参数,或是类类型参数的成员变量赋值
<br>@Options注解的userGeneratedKeys和keyProperty属性让数据库产生 auto_increment（自增长）列的值，然后将生成的值设置到输入参数对象的属性中
```java
@Insert("insert into students(name,email,addr_id, phone) values(#{name},#{email},#{address.addr Id},#{tell})")  
@Options(useGeneratedKeys = true, keyProperty = "studId")  
int insertStudent(Student student);  
```
对于SELECT操作可以使用@Select标签
对于放回结果使用@Result
```java
 @Results(  {  
                @Result(id = true, column = "stud_id", property = "studId"),  
                @Result(column = "name", property = "name"),  
                @Result(column = "email", property = "email"),  
                @Result(column = "addr_id", property = "address.addrId")  
            })  
```
- 提供@One注解来获得一对一的查询结果

```java
@Select("select * from students where stud_id=#{studId} ")  
@Results({  
            @Result(id = true, column = "stud_id", property = "studId"),  
            @Result(column = "name", property = "name"),  
            @Result(column = "email", property = "email"),  
            @Result(property = "address", column = "addr_id",  
            one = @One(select = "com.briup.mappers.Student Mapper.findAddressById"))  
        })  
Student selectStudentWithAddress(int studId); 
``` 
- @Many注解，用来使用嵌套Select语句加载一对多关联查询。
```java    
        @Select("SELECT tutor_id, name as tutor_name, email, addr_id  
                FROM tutors where tutor_id=#{tutorId}")  
        @Results(  
        {  
            @Result(id = true, column = "tutor_id", property = "tutorId"),  
            @Result(column = "tutor_name", property = "name"),  
            @Result(column = "email", property = "email"),  
            @Result(property = "address", column = "addr_id",  
            one = @One(select = "com.briup.mappers.Tutor Mapper.findAddressById")),  
            @Result(property = "courses", column = "tutor_id",  
            many = @Many(select = "com.briup.mappers.Tutor Mapper.findCoursesByTutorId")
        })  
        Tutor findTutorById(int tutorId);  
```  

### 通用Mapper类
通用Mapper类中包含了基本的数据库操作,可以使用其中的操作，如果不够可以使用自己写的方法
####通用Mapper的配置

- 基于 starter 的自动配置

在所有接口上添加@Mapper注解
<br>在properties配置文件中指定Mapper接口
```
mapper.mappers=com.hand.springbootmybatis.api.infra.mapper
## 是否判断字符串类型 !=''
mapper.not-empty=false
## 取回主键方式
mapper.identity=MYSQL
```
- 基于 @MapperScan 注解的手工配置

在有@Configuration的类配置该注解，或者配置到Spring Boot的启动类上
```java
@tk.mybatis.spring.annotation.MapperScan(basePackages = "扫描包")
```
#### @NameStyle 注解(Mapper)
这个注解可以在实体类上进行配置,可以用来使之与数据库的字段名相匹配，优先级高于对应的 style 全局配置。
```
normal,                     //原值
camelhump,                  //驼峰转下划线
uppercase,                  //转换为大写
lowercase,                  //转换为小写
camelhumpAndUppercase,      //驼峰转下划线大写形式
camelhumpAndLowercase,      //驼峰转下划线小写形式
```
#### @Table注解
注解在实体类中,配置 name,catalog 和 schema 三个属性，配置 name 属性后，直接使用提供的表名，不再根据实体类名进行转换。
#### @Column注解
配置在实体类的成员变量中使之对应数据库的字段，支持name,insertable和updateable三个属性。
```
name 配置映射的列名。
insertable 对提供的insert方法有效，如果设置false就不会出现在SQL中
updateable 对提供的update方法有效，设置为false后不会出现在SQL中
```
## 今日的坑
- 出现通用Mapper查询不到内容,并未返回错误就是没有数据,返回的对象为空

## 本周总结
本周学习了Spring MVC web框架以及Spring boot框架。
### Spring MVC框架
MVC(Model,View,Controller),模型既数据是进行数据库交互的层,视图层既前端页面显示将数据处理后呈现在用户面前的一层,控制层就是模型层与视图层交互的控制,将前端的操作进行处理,如页面请求,数据请求等。
<br>对于Spring MVC框架结合老师要求的结构形成的目录结构如下
![](http://pcpj2g4mj.bkt.clouddn.com/18-8-12/83112348.jpg)
<br>对于页面请求控制写在Controller内
<br>Webapp是用来放置页面视图,web设置的
#### web.xml
这个配置文件用来配置mvc配置文件位置,Classpath是以resource为根路径的,也是用来配置请求方式模拟的
#### SpringMVC.xml
这个配置文件是用来配置视图的路径的
```xml
 <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/jsp/" />
        <property name="suffix" value=".jsp" />
</bean>
得到/WEB-INF/jsp/xxx.jsp这样的路径
```
对于全部的详细的总结在SpringMVC中
#### Springboot
Springboot简化了很多的注解,自动性很强,他的配置文件简化到只有一个application.properties,使用这个默认的命名Spring boot会自动进行加载数据配置。
<br>SpringBoot内置了tomcat容器所有不用本地配置tomcat,而且如果需要使用jsp的话需要配置依赖包并开启tomcat,官网上的建议是不要使用Jsp。
Spring boot的开启很方便只需运行启动类即可
```java

@SpringBootApplication
public class SpringbootmybatisApplication {
    public static void main(String[] args) {
        SpringApplication.run(SpringbootmybatisApplication.class, args);
    }
}
```
详细内容在SpringBoot里

## 今日学习

----------------------08-13-------------
## 今日的坑
- 出现通用Mapper查询不到内容,并未返回错误就是没有数据,返回的对象为空
昨天各种百度没找到今天就偶然间将实体类的int类型改为Integer包装类就可以了

---------------------98-14--------------
## 今日学习

### Spring重拾

### Spring CloudS
```
总结一下spring cloud 的结构： 
1、请求统一通过API网关（Zuul）来访问内部服务. 
2、网关接收到请求后，从注册中心（Eureka）获取可用服务 
3、由Ribbon进行均衡负载后，分发到后端具体实例 
4、微服务之间通过Feign进行通信处理业务 
5、Hystrix负责处理服务超时熔断 
6、Turbine监控服务间的调用和熔断相关指标
```
#### 一. 概念
##### 1. 服务治理

#### 二. 搭建服务注册中心
##### 依赖包
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka-server</artifactId>
    <version>1.4.5.RELEASE</version>
</dependency>

 <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>${spring-cloud.version}</version>
            <type>pom</type>
            <scope>import</scope>
</dependency>

```
管理多个服务
- 在启动类配置

@EnableEurekaServer

- 在配置文件文件中

```
server.port=1111 #服务注册中心的端口
eureka.instance.hostname=localhost
eureka.client.register-with-eureka=false #代表不向注册中心注册自己
eureka.client.fetch-registry=false #设置不去检索服务
eureka.client.service-url.defaultZone=http://${eureka.instance.hostname}:${server.port}/eureka/
```

#### 创建服务提供者并注册
##### 依赖包
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>2.0.4.RELEASE</version>
</dependency>

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka</artifactId>
    <version>1.4.5.RELEASE</version>
</dependency>

```
创建服务提供者并在服务中心进行注册
- 启动类加上注解

@EnableDiscoveryClient

- 配置
```
spring.application.name=hello-service #服务名字
eureka.client.service-url.defaultZone=http://localhost:1111/eureka/ #往服务中心上注册
```
### 高可用的注册中心
使用多节点的服务注册中心集群
- 在注册中心项目中配置

application-peer1.properties,application-peer2.properties两个配置文件使之通过--spring.profiles.actives指定运行配置使之成为两个服务中心节点

```
peer1:
spring.application.name=eureka-server
server.port=1111
eureka.instance.hostname=peer1
eureka.client.service-url.defaultZone=http://peer2:1112/eureka/
peer2:
spring.application.name=eureka-server
server.port=1111
eureka.instance.hostname=peer1
eureka.client.service-url.defaultZone=http://peer2:1112/eureka/

```
配置文件使之互相注册在注册中心中System32/driver/etc/hosts文件中写入
```
127.0.0.1 peer1
127.0.0.1 peer2
```

修改本地hosts文件
- 服务提供者配置

```
eureka.client.service-url.defaultZone=http://peer1:1111/eureka/,http://peer2:1112/eureka/

```
将服务注册到服务中心集群中,这个时候如果peer1服务器宕机了,依然可以在peer2服务器中
这里通过http://peer1:1111/eureka/ 定义地址,可以使用http://127.0.1:1111/eureka/ 即ip地址访问,这就要配置eureka.instance.perfer-ip-address=true来设置

### 关于Spring Boot的打包
对于有子模块的项目
- 主模块的pom.xml

```xml
 <packaging>pom</packaging>
```
- 子模块的pom.xml

自动生成的子模块的<parent>改为父模块,然后指定<relativePath>../pom.xml</relativePath>
<br>将<groupId><packaging>这些标签删去
```xml
  <parent>
        <groupId>com.xiong</groupId>
        <artifactId>springcloud</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <relativePath>../pom.xml</relativePath>
    </parent>
```
### 消费者(客户端)
使用Ribbon实现客户端的负载均衡

#### 依赖
```xml
<dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-ribbon</artifactId>
</dependency>   
```
#### 启动类中
注解@LoadBalanced开启负载均衡
<br>创建RestTemplate的Bean用来客户端消费者获取服务端的服务提供者
#### RestTemplate类
通过getForEntity()方法进行服务请求
### 服务容错保护:Spring Cloud Hystrix
能够保证在一个依赖出问题的情况下，不会导致整体服务失败，这个就是Hystrix需要做的事情。Hystrix提供了熔断、隔离、Fallback、cache、监控等功能，能够在一个、或多个依赖同时出现问题时保证系统依然可用。通过断路器的故障监控,当某个服务单元发生故障后,向调用方返回错误响应,避免长时间的等待。
#### 原理
![原理图](http://pcpj2g4mj.bkt.clouddn.com/18-8-15/91925440.jpg)
##### 1. HystrixCommand和HystrixObservableCommand
使用命令模式对请求进行封装成对象
- Receiver执行业务逻辑
- Command命令接口用来被具体的命令类进行继承
- ConcreteCommand具体的命令,成员为Receiver与命令
- Invoker调用者获取具体实现的命令并调用其中Receiver的业务逻辑

HystrixCommand和HystrixObservableCommand就是其中的ConcreteCommand,实现了具体的方法

- 设置超时时间

hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds=(ms)

- 异步执行
```java
    @HystrixCommand
    public Future<User> getUserByIdAsync(final String id) {
        return new AsyncResult<User>() {
            @Override
            public User invoke() {
                return userResource.getUserById(id);
            }
        };
    }
```
## Feign

### 1. 功能介绍
服务消费端的调用框架，支持Hystrix容错保护和Ribbon负载均衡,
<br>启动类注解@EnableFeignClients开启Feign

### 2. Robbin支持
Feign使的Robbin的实现只需声明即可,非常的优雅的配置
@FeignClient(name="服务名",fallback=fallback类.class)即可映射服务,绑定fallback
<br>fallback类要实现service接口并注解@Component进行实例化
### 3. Hystrix支持
配置文件中使用设置feign.hystrix.enabled=true开启支持
- 写一个fallback类继承与服务接口
- 写一个服务接口,声明映射到对应的服务

@FeignClient(value = "hello-server",fallback = HelloServiceFallback.class)

### 3. 配置

#### 1. 请求压缩

feign请求响应压缩
<br>将超过阀值的请求进行GZIP压缩
```
feign.compression.request.enabled=true
feign.compression.response.enabled=true
feign.compression.request.mine-types=text/xml,application/xml,application/json
feign.compression.request.min-request-size=2048
```
#### 2. 日志配置
1. 配置开启日志
```
#feign日志配置
logging.level.com.xiong.springcloud.Api.Service.HelloService=DEBUG
```
2. 写配置类
```java
public class FeignClientConfiguration {
    @Bean
    Logger.Level feignLoggerLevel(){
        return Logger.Level.FULL;
    }
}
```
3. 对FeignClient指定配置类
@FeignClient(configuration = FeignClientConfiguration.class)

## Spring Cloud Zuul
### 配置
指定端口号并注册到服务中心
```
spring.application.name=GateWay
server.port=8083
eureka.client.service-url.defaultZone=http://localhost:1111/eureka/

```
### 路由配置
微服务应用提供的接口,通过统一的API网关入口被客户端访问
#### 路径匹配
使用Ant风格
- ?     匹配任意单个字符
- *     匹配任意数量的字符
- **    支持多级目录,匹配任意数量的字符

```
#传统的路由配置
##单例
zuul.routes.api-a.path=/user-service/**
zuul.routes.api-a.url=http://localhost:8080/

##多例
zuul.routes.api-a.path=/user-service/**
zuul.routes.api-a.serviceId=user-service
ribbon.eureka.enabled=false
user-service.ribbon.listOfServers=http://localhost:8080/,http://localhost:8081/

```
```
#面向服务的路由,不用指定具体URL
zuul.routes.api-a.path=/user-service/**
zuul.routes.api-a.serviceId=user-service
#或
zuul.routes.api-a=/user-service/**
```
这样配置之后可以通过网关以及映射的服务进行访问
```
http://localhost:8083/api-a/hello
```
#### 忽略路由
zuul.ignored-patterns=/**/xxxx/**/

### 请求过滤
[](https://blog.csdn.net/liuchuanhong1/article/details/62236793)

### 动态加载
在不关闭或重启的情况下实现修改路由规则，添加修改过滤器
 create user RSGL                //创建用户名
  identified by "RSGL"             //创建密码
  default tablespace RSGL      //默认表空间 
  temporary tablespace TEMP     //临时表空间（默认的）
  profile DEFAULT                     //默认权限（下面给分配）
  quota unlimited on rsgl;       //该用户在ydrsgl表空间里的配额不限

create user root                
identified by "root"            
default tablespace  myoracle     
temporary tablespace TEMP     
profile DEFAULT              
    
quota unlimited on myoracle;  


  grant dba to root;            // 分配管理员权限 

  grant unlimited tablespace to root; //开放所有的表空间对此用户

------------------------------08-22----------------------
# 今日的坑
# 今日学习
## Oracle创建角色

create user USER2 --用户名 
identified by user2 --口令 
default tablespace USERS --默认表空间
temporary tablespace TEMP --临时表空间
grant connect to USER2;grant resource to USER2; -- 设置权限

## Oracle自增序列在Mybatis中的使用
```xml
 <insert id="insertApplication">
        <selectKey keyProperty="header_id"  resultType="int" order="BEFORE">
            SELECT headerid.nextval as id FROM dual
        </selectKey>
        INSERT INTO fin_expense_header (header_id,expense_num,applicant,apply_time,project_id,expense_desc,status,total_amount,approval_node,approval_time,pay_time,approver,created_by,creation_date,last_updated_by,last_update_date)
        VALUES( #{header_id},#{header_id},'217',sysdate,'5','路费','审批中',99,'项目经理审批',sysdate,sysdate,'吕顺',#{name},sysdate,#{name},sysdate)
    </insert>
```
- 先在oracle中创建sequence自主序列如CREATE SEQUENCE headerid
- 
    ```
        <selectKey keyProperty="header_id"  resultType="int" order="BEFORE">
        SELECT headerid.nextval as id FROM dual
        </selectKey>
    ```
    会将序列值赋给keyProperty(这个的作用结合<selectKey>标签是获取当前插入的主键的值)
- 可以通过#{header_id}获取本次的值

# 疑问
- 全局变量
- mybatis结果一定需要类吗
- mybatis查询结果在mapper.xml中传递

----------08-23-----

# 今日的坑
# 今日学习
## swagger2

## Redis

### 1.开机自启动
1. 拷贝 redis 安装目前下的 /usr/local/redis-4.0.2/utils/redis_init_script 到 /etc/init.d/redis文件中

cp /usr/local/redis-4.0.2/utils/redis_init_script /etc/init.d/redis
2. 修改/etc/init.d/redis 文件。修改redis安装的相关文件安装目录

```sh

#!/bin/sh
# chkconfig: 2345 10 90  
# description: Start and Stop redis
REDISPORT=6379
EXEC=/usr/local/redis-4.0.2/src/redis-server
CLIEXEC=/usr/local/redis-4.0.2/src/redis-cli
PIDFILE=/var/run/redis_${REDISPORT}.pid
#CONF="/etc/redis/${REDISPORT}.conf"
CONF="/usr/local/redis-4.0.2/redis.conf"

```
3. 开机启动设置，执行一下命令：

4. 添加redis服务：
chkconfig --add redis
5. 设为开机启动 ：
chkconfig redis on

- 打开redis命令:
service redis start

- 关闭redis命令:
service redis stop

- 客户端

/usr/redis-3.2.1/src/redis-cli

- 设置密码后使用客户端关闭
/usr/redis-3.2.1/src/redis-cli -a root shutdown

客户端操作下
- auth password 输入密码

### 2.使

## RabbitMQ

### 使用rabbitmqctl管理，常用的命令有：
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

```
### 用户管理
#### 1. 创建与授权 
```
rabbitmqctl add_user username pssword  //添加用户，后面两个参数分别是用户名和密码
rabbitmqctl set_permissions -p / username ".*" ".*" ".*"  //添加权限
rabbitmqctl set_user_tags username administrator  //修改用户角色,将用户设为管理员

```
##### 权限说明：
rabbitmqctl set_permissions [-pvhostpath] {user} {conf} {write} {read}
Vhostpath：Vhost路径。
user：用户名。
Conf：一个正则表达式match哪些配置资源能够被该用户访问。
Write：一个正则表达式match哪些配置资源能够被该用户读。
Read：一个正则表达式match哪些配置资源能够被该用户访问。

#### 2. 删除与修改
```
删除用户：rabbitmqctl delete_user username
改密码: rabbimqctl change_password {username} {newpassword}
设置用户角色：rabbitmqctl set_user_tags {username} {tag ...}

```



## 虚拟机的克隆
cd /etc/sysconfig/network-scripts/
需要删除UUID
rm 配置文件70-persistent-ipoib.rules
rm /etc/udev/rules.d/70-persistent-ipoib.rules

----------------------08-30-------------
# 计划

# 今日任务

# 今日的坑

# 今日学习
##  @Transient
这个注解用在数据库映射实体类中表示忽略该成员，表示该成员不是数据库映射字段

## Swagger2接口文档
### 1. 依赖包
```xml
  <!-- swagger2 -->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
            <version>2.9.2</version>
        </dependency>
        <!-- swagger-ui -->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger-ui</artifactId>
            <version>2.9.2</version>
        </dependency>
```
### 2. 启动类注解@EnableSwagger2 开启注解
### 3. 配置类
```java

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

@Configuration
public class Swagger2Config {
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.xiong.useredis.Controller")) //控制层包
                .paths(PathSelectors.any())
                .build();
    }
    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("CashBack's RESTful APIs")
                .description("description")
                .termsOfServiceUrl("http://bdcresttest.hexun.com/cashback2server")
                .version("1.0")
                .build();
    }
}
```
### 4. 注解

1. @Api：用在请求的类上，说明该类的作用

@Api：用在请求的类上，说明该类的作用
    tags="说明该类的作用"
    value="该参数没什么意义，所以不需要配置"

2. @ApiOperation：用在请求的方法上，说明方法的作用

@ApiOperation："用在请求的方法上，说明方法的作用"
    value="说明方法的作用"
    notes="方法的备注说明"
示例：

@ApiOperation(value="用户注册",notes="手机号、密码都是必输项，年龄随边填，但必须是数字")

3. @ApiImplicitParams：用在请求的方法上，包含一组参数说明

@ApiImplicitParams：用在请求的方法上，包含一组参数说明
    @ApiImplicitParam：用在 @ApiImplicitParams 注解中，指定一个请求参数的配置信息       
        name：参数名
        value：参数的汉字说明、解释
        required：参数是否必须传
        paramType：参数放在哪个地方
            · header --> 请求参数的获取：@RequestHeader
            · query --> 请求参数的获取：@RequestParam
            · path（用于restful接口）--> 请求参数的获取：@PathVariable
            · body（不常用）
            · form（不常用）    
        dataType：参数类型，默认String，其它值dataType="Integer"       
        defaultValue：参数的默认值
示例
@ApiImplicitParams({
    @ApiImplicitParam(name="mobile",value="手机号",required=true,paramType="form"),
    @ApiImplicitParam(name="password",value="密码",required=true,paramType="form"),
    @ApiImplicitParam(name="age",value="年龄",required=true,paramType="form",dataType="Integer")
})

4. @ApiResponses：用于请求的方法上，表示一组响应

@ApiResponses：用于请求的方法上，表示一组响应
    @ApiResponse：用在@ApiResponses中，一般用于表达一个错误的响应信息
        code：数字，例如400
        message：信息，例如"请求参数没填好"
        response：抛出异常的类
示例
@ApiOperation(value = "select1请求",notes = "多个参数，多种的查询参数类型")
@ApiResponses({
    @ApiResponse(code=400,message="请求参数没填好"),
    @ApiResponse(code=404,message="请求路径没有或页面跳转路径不对")
})

5. @ApiModel：用于响应类上，表示一个返回响应数据的信息
@ApiModel：用于响应类上，表示一个返回响应数据的信息
            （这种一般用在post创建的时候，使用@RequestBody这样的场景，
            请求参数无法使用@ApiImplicitParam注解进行描述的时候）
    @ApiModelProperty：用在属性上，描述响应类的属性

示例
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
 
import java.io.Serializable;
 
@ApiModel(description= "返回响应数据")
public class RestMessage implements Serializable{
 
    @ApiModelProperty(value = "是否成功")
    private boolean success=true;
    @ApiModelProperty(value = "返回对象")
    private Object data;
    @ApiModelProperty(value = "错误编号")
    private Integer errCode;
    @ApiModelProperty(value = "错误信息")
    private String message;
 
    /* getter/setter */
}
---------------------------  9-03 ------------
# 计划

# 今日任务

# 今日的坑

# 今日学习

---------------------------
# 计划
- 信息安全
- kubernet

# 今日任务

# 今日的坑

# 今日学习


------------------09-05--------
# 计划
09-06 19:00-21:00 三七互娱笔试








-----------------10-24------------
# Spring Boot cache

## CacheManager
缓存管理器，用来管理缓存的组件，spring提供的各种缓存技术抽象接口

## @Cacheable/@CachePut/@CacheEvict 主要的参数

- value	缓存的名称(类似于命名空间)，必须指定至少一个
@Cacheable(value=”mycache”)

- key	缓存的 key，可以为空，如果指定要按照 SpEL 表达式编写，如果不指定，则缺省按照方法的所有参数进行组合
@Cacheable(value=”testcache”,key=”#id”)

- condition	缓存的条件，可以为空，使用 SpEL 编写，返回 true 或者 false，只有为 true 才进行缓存/清除缓存
@Cacheable(value=”testcache”,condition=”#userName.length()>2”)

- unless	否定缓存。当条件结果为TRUE时，就不会缓存。
@Cacheable(value=”testcache”,unless=”#userName.length()>2”)

- allEntries(@CacheEvict )	是否清空所有缓存内容，缺省为 false，如果指定为 true，则方法调用后将立即清空所有缓存
@CachEvict(value=”testcache”,allEntries=true)

- beforeInvocation(@CacheEvict)	是否在方法执行前就清空，缺省为 false，如果指定为 true，则在方法还没有执行的时候就清空缓存，缺省情况下，如果方法执行抛出异常，则不会清空缓存
@CachEvict(value=”testcache”，beforeInvocation=true)











-----------------------09-10-------
# 今日学习
- Spring Cloud深入学习



-----------------------09-19--------
# 今日学习

- AWS ESC

# Linux

## 文件权限
- r 读权限，查看目录，读文件内容
- w 写权限，修改目录，修改文件内容
- x 执行权限，进入目录，执行文件(如果是可执行文件) 

### 权限显示

```
-rwxr---x- 1 root root 
d-w------- 1 root root
lrwxrwxrwx 1 root root 
```
- 最左侧"-"开头表示为文件，"d"开头表示为目录，"l”开头表示为链接（如同windows下的快捷方式）。
- "- rwx r-- -x-" 前三个字母表示 **创建者** 的权限，中间三个表示 **所属组** 的权限，后面三个表示 **其他用户** 的权限。其中-表示无权限。
- 后面的数字表示连接数。
- 再后面的两个用户，分别表示所有者(创建者)和所属组

### chmod 命令
```sh
chmod xxx 文件
chmod ×(所有者)×(组用户)×(其他用户) 

0 [000] 无任何权限 
1 [001] 执行权限 x 
2 [010] 只写权限 w 
4 [100] 只读权限 r 
5 [101] 读执行权限 
6 [110] 读写权限 
7 [111] 读写执行权限

```
```sh
chmod [-R] xyz 文件或者目录
x:代表角色：u(所有者)、g(所属组)、o(其他用户)、a(所有用户)
y:代表设置：+(增加权限)、-(减少权限)、=(设置权限)
z:代表权限: r w x

```

## NFS系统
依赖于RPC协议




--------09-21------
# 学习计划

- Kubernetes
- Rancher
- Golang基础
- Jenkins
- Spring复学

# 今日学习
## AWS ESC学习
- Application Load Balancer
- Jenkins
安装到容器
```
docker run -p 8080:8080 -p 50000:50000 -d -v /root/jenkins:/var/jenkins_home -u 0 --name jenkins-server jenkins
```
挂载卷时候需要-u 0指定用户 

# 今日的坑
-----------------------10-10------------
# 今日学习
Jenkins学习
---------10-26------------------------
# admin学习
# spring cloud Sleuth




------------------------11-13-------------------
# Spring Bean的注入

-----------------------11-20--------------------
# spring RestTemplate学习
```java
java.lang.Object
    org.springframework.http.client.support.HttpAccessor
        org.springframework.http.client.support.InterceptingHttpAccessor
            org.springframework.web.client.RestTemplate
public class RestTemplate extends InterceptingHttpAccessor implements RestOperations
```
5.0官方文档说，这个类在未来版本中将被启用