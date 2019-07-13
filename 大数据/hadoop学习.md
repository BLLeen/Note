# 安装

## 伪分布式

- version 2.6.5

[下载地址](https://archive.apache.org/dist/hadoop/core/hadoop-2.6.5/hadoop-2.6.5.tar.gz)

### 修改主机hostname（option）

```sh
[root@centos7 ~]$ hostnamectl set-hostname bigdate      # 使用这个命令会立即生效且重启也生效
[root@centos7 ~]$ hostname                              # 查看下
bigdate
[root@centos7 ~]$ vim /etc/hosts                 # 编辑下hosts文件,给127.0.0.1添加hostname
[root@centos7 ~]$ cat /etc/hosts                 # 检查
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 bigdate
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

### 1.下载hadoop安装包并解压

下载2.6.5版本，因为是结合2.4.3版本spark使用

https://archive.apache.org/dist/hadoop/core/hadoop-2.6.5/hadoop-2.6.5.tar.gz

### 2.配置

- hadoop-env.sh

  配置JAVA_HOME

- core-site.xml

  ```xml
  <property>
      <name>fs.defaultFs</name>
      <value>hdfs://bigdate:8020</value>
  </property>
  <property>
      <name>hadoop.tmp.dir</name>
      <value>/usr/local/hadoop/data/tmp</value>
  </property>
  ```

- hdfs-site.xml

  设置备份数，hadoop默认是三份，由于是伪分布式，所以一份就够了

  ```xml
  <property>
      <name>dfs.replication</name>
  	<value>1</value>
  </property>
  
  ```

  

- 格式化文件系统

  ```sh
  bin/hdfs namenode –format
  ```

  

  