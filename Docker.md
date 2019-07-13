
# centOS7 安装
## 卸载旧版本
旧版本的 Docker 称为 docker 或者 docker-engine，使用以下命令卸载旧版本：
```
yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine
```
## 使用 yum 源 安装
执行以下命令安装依赖包：
```
yum install -y yum-utils device-mapper-persistent-data lvm2
```
执行下面的命令添加docker阿里的yum 软件源：
```
$ sudo yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```
以上命令会添加稳定版本的 Docker CE yum 源。从 Docker 17.06 开始，edge test 版本的 yum 源也会包含稳定版本的 Docker CE。

## 如果需要最新版本的 Docker CE(非stable)
```
$ yum-config-manager --enable docker-ce-edge
$ yum-config-manager --enable docker-ce-test
```
## 安装 Docker CE

更新 yum 软件源缓存，并安装 docker-ce。
```
$ yum clean all
$ yum makecache fast
$ yum list docker-ce --showduplicates|sort -r
$ yum install docker-ce

```
## 更改镜像源
vi /etc/docker/daemon.json
```json
{
"registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```
systemctl restart docker.service



# 创建harbor私库
[参考博客](https://my.oschina.net/guol/blog/1840960)
<br>http://harbor.orientsoft.cn/ 下载harbor安装

## 工作目录
/opt/programs/harbor

## 配置文件夹
/opt/programs/harbor/harbor.cfg
<br>修改hostname
## 安装harbor
/opt/program/install.sh
## 配置docker私人仓库
vim /etc/docker/daemon.json
```
{

"registry-mirrors": ["http://hub-mirror.c.163.com"],
"insecure-registries":["http://192.168.88.128"]
}

```
## 重启
```s
cd /opt/programs/harbor/
docker-compose stop
docker-compose up -d
```
## 登陆
docker login 192.168.88.128

admin/Harbor12345

# 推镜像
## tag打标签
```s
docker tag [镜像名1]:[tag1] [镜像名2]:[tag2]
```
## push到镜像库
```s
docker push  
```

# Docker命令
## docker run 


## docker diff 容器名 
查看容器的文件差异
- A Add
- D Delete
- C Change

## docker commit [选项] <容器> [<仓库名>[:<标签>]]
将容器保存为镜像
- --author "指定修改的作者"
- --message "记录本次修改的内容"
### 使用commit方式生成镜像为暗箱镜像不推荐使用，使用Dockerfile可以清楚知道执行了什么构建步骤

# Dockerfile
根据Dockerfile构建镜像
## 1. FROM 
镜像的基础镜像
## 2. RUN
- RUN shell格式的命令 (不同的命令以 && 隔开,换行为\ )
- RUN ["可执行文件", "参数1", "参数2"]

## 3. COPY ["<源路径1>",... "<目标路径>"]
从上下文路径下源路径复制到镜像内目标路径(路径如不存在会自动创建)
<br>源路径可以是多路径，也可以说是通配符(Go 的 filepath.Match )
## 4. ADD ["<源路径1>",... "<目标路径>"]
相对于COPY指令，可以是URL
<br>对于 gzip , bzip2 以及 xz 压缩包会自动解压缩
## 5. CMD
与RUN类似但是是容器启动后执行的命令
<br>一个Dockerfile只能有一个CMD
<br>推荐使用exec 格式： CMD ["可执行文件", "参数1", "参数2"...]
## docker build [选项] 镜像名:标签 <上下文路径/URL/(- < 压缩包)>(.表示当前目录为上下文环境的根目录)
## .dockerignore与gitignore一样忽略上下文目录的文件 


# docker-compose 安装
```s
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose 
docker-compose --version
```

# docker-compos命令





# Docker理解(持续补充)
技术

# namespace

- 进程隔离
通过命名空间创建出隔离进程和网络

- 网络隔离

Host、Container、None 和 Bridge 模式

Bridge 模式
![](http://pcpj2g4mj.bkt.clouddn.com/18-10-28/17888502.jpg)
Docker Server创建网桥docker0，接下来的容器通过与docker0网桥进行数据交互，通过 iptables 进行数据包转发，让 Docker 容器能够优雅地为宿主机器或者其他容器提供服务

- 宿主机文件隔离 
使用Chroot改变当前的系统根目录结构，通过改变当前系统的根目录，限制用户的权利，在新的根目录下并不能够访问旧系统根目录的结构文件，也就建立了一个与原系统完全隔离的目录结构

# CGroups
对宿主机的物理资源，如CPU，内存，IO等上的隔离
- CGroup
每一个CGroup都是**一组**被相同的标准和参数限制的进程，能够为一组进程分配资源，不同的 CGroup 之间是有层级关系的，也就是说它们之间可以从父类继承一些用于限制资源使用的标准和参数
<br>启动一个容器时，Docker 会为这个容器创建一个与容器标识符相同的 CGroup

# UnionFS
linux文件服务
<br>Docker 镜像其实本质就是一个压缩包
<br>每一个镜像层或者容器层都是 /var/lib/docker/ 目录下的一个子文件夹
<br>所有镜像层和容器层的内容都存储在 /var/lib/docker/aufs/diff/目录中
<br>/var/lib/docker/aufs/layers/ 中存储着镜像层的元数据，每一个文件都保存着镜像层的元数据
<br>/var/lib/docker/aufs/mnt/ 包含镜像或者容器层的挂载点，最终会被 Docker 通过联合的方式进行组装


# 网络
## 容器互联
## --link container1:alias 
将container1的环境变量添加到容器，container1的host更新到目标容器的/etc/hosts
<br>但是container1的ip在添加的环境变量中不会自动更新，host会自动更新。
<br>环境变量
- container1容器Dockerfile中ENV标签设置的环境变量
- container1容器用docker run命令创建，命令中包含的 -e或--env或--env-file设置的环境变量

```
<alias>PORT<port>_<protocol(TCP/UDP)>ADDR
<alias>PORT<port>_<protocol>PORT
<alias>PORT<port>_<protocol>_PROTO
```

```
<alias>_ENV_<envname>
```

# 容器部署
