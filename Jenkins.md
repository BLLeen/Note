# Jenkins安装


# Maven安装
```sh
	cd /usr/local/src/

	wget   http://mirrors.hust.edu.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
	
	解压改名
	tar zxf apache-maven-3.5.4-bin.tar.gz 
	mv apache-maven-3.5.4 /usr/local/maven3
	vi /etc/profile然后还需要 配置环境变量。
	#在适当的位置添加

	export M2_HOME=/usr/local/maven3
	export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin
	
	保存退出后运行下面的命令使配置生效，或者重启服务器生效。
	source /etc/profile
	
	验证版本
	mvn -v
	出现maven版本即成功

```
# JDK
## 卸载自带JDK
```s
rpm -qa|grep jdk
# 列出一堆安装
yum -y remove copy-jdk-configs-3.3-2.el7.noarch
# 卸载 copy-jdk-configs-***.noarch
```
## 安装JDK
```s
	#!/bin/bash
	while true
	do
		if [ -f "jdk-8u141-linux-x64.tar.gz" ];then break;fi
		wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"
	done

	tar -zxvf jdk-8u141-linux-x64.tar.gz
	rm -f jdk-8u141-linux-x64.tar.gz
	mv jdk1.8.0_141 java
	rm -rf /usr/local/java
	mv java/ /usr/local/

	# 配置JDK变量环境

	echo "export JAVA_HOME=/usr/local/java"  >> /etc/profile
	echo "export PATH=\$PATH:\$JAVA_HOME/bin"  >> /etc/profile

	java -version
```
# 使用Docker安装
```s
docker run --name jenkins_server -p 8088:8080 -p 50000:50000 -d  -u 0 -v /usr/local/java:/usr/java/  -v /usr/local/maven3:/usr/maven3 -v /root/jenkins:/var/jenkins_home jenkins

# 更改接口映射容器的8080映射到8088，挂载卷时候需要-u 0指定用户
# 将JDK和MAVEN挂载到容器内 

```

# rpm包安装
[Jenkins官方下载地址](https://pkg.jenkins.io/redhat-stable/)
```s
rpm -ivh jenkins-2.138.1-1.1.noarch.rpm

## http://pkg.jenkins-ci.org/redhat/

wget http://pkg.jenkins-ci.org/redhat/jenkins-2.39-1.1.noarch.rpm 

## 下载(也可以Windows下载再转过来)

rpm --import http://pkg.jenkins-ci.org/redhat/jenkins.io.key ## 公钥

yum -y install jenkins-*.noarch.rpm

```

## 修改配置
1. jenkins的默认JENKINS_PORT是8080，JENKINS_AJP_PORT默认端口是8009，这同tomcat的默认端口冲突。我这更改为8088和8089
> vi /etc/sysconfig/jenkins
<br>JENKINS_USER="root" ## 原值 "jenkins" 必须修改，否则权限不足
2. 修改JDK配置
> vi /etc/rc.d/init.d/jenkins
```conf
candidates="
/etc/alternatives/java
/usr/lib/jvm/java-1.8.0/bin/java
/usr/lib/jvm/jre-1.8.0/bin/java
/usr/lib/jvm/java-1.7.0/bin/java
/usr/lib/jvm/jre-1.7.0/bin/java
/usr/bin/java
$JAVA_HOME/bin/java
"
```

## 防火墙开放端口
```s
firewall-cmd --zone=public --add-port=8088/tcp --permanent 
firewall-cmd --reload
```

# 使用 

# 构建触发器

## 版本提交触发构建
```
Poll SCM
```
指定时间扫描提交

# 名词

