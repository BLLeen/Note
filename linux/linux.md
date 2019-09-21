# 分区
## /
主分区，用于安装系统与软件 30G左右
## /home
逻辑分区，用于放置文件等 多一些
## swap
交换分区，虚拟内存 与内存大小差不多
## /boot 
引导分区，包含了操作系统的内核和在启动系统过程中所要用到的文件 200M左右

# 查看linux版本
```s
cat /proc/version   # 查看linux版本
cat /etc/issue      # 查看linux当前版本系统的发行版信息
cat /proc/cpuinfo   # 查看cpu信息
getconf LONG_BIT    # 查看计算机位数
```

# linux线程

# SSH(OpenSSH)
Secure SHell

# hostname

## 静态的（Static hostname）

“静态”主机名也称为内核主机名，是系统在启动时从/etc/hostname自动初始化的主机名。

## 瞬态的（Tansient hostname）

“瞬态”主机名是在系统运行时临时分配的主机名，例如，通过DHCP或mDNS服务器分配。

## 灵活的（Pretty hostname）

“灵活”主机名也有人叫做“别名”主机名，允许使用自由形式（包括特殊/空白字符）的主机名，以展示给终端用户（如xh01@f5）。
“静态”主机名和“瞬态”主机名都遵从作为互联网域名同样的字符限制规则。

## 修改方法

```sh
[root@centos7 ~]$ hostnamectl set-hostname bigdate      # 使用这个命令会立即生效且重启也生效
[root@centos7 ~]$ hostname                              # 查看下
bigdate
[root@centos7 ~]$ vim /etc/hosts                 # 编辑下hosts文件,给127.0.0.1添加hostname
[root@centos7 ~]$ cat /etc/hosts                 # 检查
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 bigdate
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
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

