# 基本概念

## Master
集群控制节点，负责对命令的执行管理整个集群
### kube-apiserverr
提供HTTP Rest接口的关键服务进程，是所有资源的增删改查等操作的唯一入口，是集群控制的入口进程
### kube-controller-manager
所有资源对象的自动化管理中心进程，kubernetes里大部分概念都可以称为资源对象
### kube-scheduler
负责Pod调度的进程

## Node
集群中除了Master的机器都是Node
### kubelet
负责Pod对应的容器的创建，启停等任务，协作Master管理集群(kubelet向Master注册自己，并上报该Node的信息，对于超时未上报的Node，标记为失联，并进行负载迁移工作)
### kube-proxy
实现服务间的负载均衡与通信
### Docker Engine
Docker引擎

## Pod
Node中对一组容器的管理，一个Pod内有一组某种业务关联的容器，以及一个Pause根容器
- 一组容器作为一个单元，Pod可以代表这单元的整体状态，共享一个IP信息
- 通过根Pause容器作为公共挂载点实现文件共享

Pod通过TCP/IP协议一虚拟二层网络技术实现不同Pod间容器的通信
### 普通Pod/静态Pod
普通Pod创建后被存放在etcd中，并被调度到某个Node上，并启动，如果Node宕机，Kubernetes会将Pod调度到其他Node上。而静态Pod存放在具体的Node上，只在该Node上启动。

## Label标签
自定义定义键值对
```yml
label:
    release: stable
    environment: dev
```
通过selector进行定向调度
```yml
selector:
    release: stable
```

## Replication Controler
预期数量场景控制，定义一个Pod模版，自动扩容，滚动升级。
<br>(升级成Replica Set，唯一区别是，只支持基于等式的Lable Selector)

## Deployment
RC的升级内部由RS实现，相对与RC，Deployment随时知道当前“Pod”的部署进度

## Horizontal Pod Autoscaler


# 核心组件

# 实践

## etcd配置
vim /etc/etcd/etcd.conf 

```sh
#[Member]
#ETCD_CORS=""
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
#ETCD_WAL_DIR=""
ETCD_LISTEN_PEER_URLS="http://192.168.197.131:2380"
ETCD_LISTEN_CLIENT_URLS="http://192.168.197.131:2379,http://127.0.0.1:2379"
ETCD_MAX_SNAPSHOTS="5"
#ETCD_MAX_WALS="5"
ETCD_NAME="etcd3"
#ETCD_SNAPSHOT_COUNT="100000"
#ETCD_HEARTBEAT_INTERVAL="100"
#ETCD_ELECTION_TIMEOUT="1000"
#ETCD_QUOTA_BACKEND_BYTES="0"
#
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.197.131:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://192.168.197.131:2379"
#ETCD_DISCOVERY=""
#ETCD_DISCOVERY_FALLBACK="proxy"
#ETCD_DISCOVERY_PROXY=""
#ETCD_DISCOVERY_SRV=""
ETCD_INITIAL_CLUSTER="etcd1=http://192.168.197.130:2380,etcd2=http://192.168.197.132:2380,etcd3=http://192.168.197.131:2380"
#ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
#ETCD_INITIAL_CLUSTER_STATE="new"
#ETCD_STRICT_RECONFIG_CHECK="true"
#ETCD_ENABLE_V2="true"
#
#[Proxy]
#ETCD_PROXY="off"
#ETCD_PROXY_FAILURE_WAIT="5000"
#ETCD_PROXY_REFRESH_INTERVAL="30000"
#ETCD_PROXY_DIAL_TIMEOUT="1000"
#ETCD_PROXY_WRITE_TIMEOUT="5000"
#ETCD_PROXY_READ_TIMEOUT="0"
#
#[Security]
#ETCD_CERT_FILE=""
#ETCD_KEY_FILE=""
#ETCD_CLIENT_CERT_AUTH="false"
#ETCD_TRUSTED_CA_FILE=""
#ETCD_AUTO_TLS="false"
#ETCD_PEER_CERT_FILE=""
#ETCD_PEER_KEY_FILE=""
#ETCD_PEER_CLIENT_CERT_AUTH="false"
#ETCD_PEER_TRUSTED_CA_FILE=""
#ETCD_PEER_AUTO_TLS="false"
#
#[Logging]
#ETCD_DEBUG="false"
#ETCD_LOG_PACKAGE_LEVELS=""
#ETCD_LOG_OUTPUT="default"
#
#[Unsafe]
#ETCD_FORCE_NEW_CLUSTER="false"
#
#[Version]
#ETCD_VERSION="false"
#ETCD_AUTO_COMPACTION_RETENTION="0"
#
# [Profiling]
#ETCD_ENABLE_PPROF="false"
#ETCD_METRICS="basic"
#
#[Auth]
#ETCD_AUTH_TOKEN="simple"
```

master：192.168.197.130

## Kubernetes集群配置

### master节点配置

```sh
###
# kubernetes system config
#
# The following values are used to configure the kube-apiserver
#

# The address on the local server to listen to.
KUBE_API_ADDRESS="--insecure-bind-address=127.0.0.1"

# The port on the local server to listen on.
KUBE_API_PORT="--port=8080"

# Port minions listen on
KUBELET_PORT="--kubelet-port=10250"

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd-servers=http://192.168.197.130:2379,http://192.168.197.132:2379,http://192.168.197.131:2379"

# Address range to use for services
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=192.254.0.0/16"

# default admission control policies
KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,ResourceQuota"

# Add your own!
KUBE_API_ARGS=""

```
### 开启服务
systemctl start kube-apiserver&&systemctl enable kube-apiserver
systemctl start kube-controller-manager&&systemctl enable kube-controller-manager
systemctl start kube-scheduler&&systemctl enable kube-scheduler

## Node配置

### 配置kubelet

```sh


###
# kubernetes kubelet (minion) config
 
# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
KUBELET_ADDRESS="--address=127.0.0.1"
 
# The port for the info server to serve on
# KUBELET_PORT="--port=10250"
 
# You may leave this blank to use the actual hostname
KUBELET_HOSTNAME="--hostname-override=192.168.197.131"
 
# location of the api-server
KUBELET_API_SERVER="--api-servers=http://192.168.197.130:8080"
 
# pod infrastructure container
KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=registry.access.redhat.com/rhel7/pod-infrastructure:latest"
 
# Add your own!
KUBELET_ARGS=""
```

## 网络配置
```
###
##
# Flanneld configuration options
 
# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD_ENDPOINTS="http://192.168.197.130:2379"
 
# etcd config key.  This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_PREFIX="/atomic.io/network"
 
# Any additional options that you want to pass
#FLANNEL_OPTIONS=""

```
