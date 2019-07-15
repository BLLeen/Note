

# docker-compose 命令:
  build              Build or rebuild services
  config             Validate and view the compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  help               Get help on a command
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pulls service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  unpause            Unpause services
  up                 Create and start containers
  version            Show the Docker-Compose version information

-f   指定docker-compose.xml文件，默认是 docker-compose.xml  ，  当一条命令有多个-f参数时，会做替换操作
-p  指定docker-compose的项目目录，也就是docker-compose.xml文件的存储目录
# 参数:
  -f, --file FILE             Specify an alternate compose file (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name (default: directory name)
  --verbose                   Show more output
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the name specified
                              in the client certificate (for example if your docker host
                              is an IP address)

# 环境变量
以DOCKER_开头的变量和用来配置 Docker 命令行客户端的使用一样。如果使用 boot2docker , $(boot2docker shellinit) 将会设置它们为正确的值。
COMPOSE_PROJECT_NAME
设置通过 Compose 启动的每一个容器前添加的项目名称，默认是当前工作目录的名字。

- COMPOSE_FILE
设置要使用的 docker-compose.yml 的路径。默认路径是当前工作目录。

- DOCKER_HOST
设置 Docker daemon 的地址。默认使用 unix:///var/run/docker.sock，与 Docker 客户端采用的默认值一致。

- DOCKER_TLS_VERIFY
如果设置不为空，则与 Docker daemon 交互通过 TLS 进行。

- DOCKER_CERT_PATH
配置 TLS 通信所需要的验证（ca.pem、cert.pem 和 key.pem）文件的路径，默认是 ~/.docker

build
Usage: build [options] [SERVICE...]

Options:
--force-rm  Always remove intermediate containers.
--no-cache  Do not use cache when building the image.
--pull      Always attempt to pull a newer version of the image.
当修改dockerfile或者docker-compose时，运行docker-compose build 重建镜像。  生成镜像后，可使用docker-compose up启动

config
Usage: config [options]

Options:
-q, --quiet     只验证配置，不输出。 当配置正确时，不输出任何内容，当文件配置错误，输出错误信息。
--services      打印服务名，一行一个
验证和查看compose文件配置。
create
为服务创建容器.只是单纯的create，还需要使用start启动compose

Usage: create [options] [SERVICE...]

Options:
    --force-recreate       重新创建容器，即使他的配置和镜像没有改变，不兼容--no-recreate参数
    --no-recreate          如果容器已经存在，不需要重新创建. 不兼容--force-recreate参数
    --no-build             不创建镜像，即使缺失.
    --build                创建容器前，生成镜像.
down
Usage: down [options]

Options:
    --rmi type          删除镜像，类型必须是:
                        'all': 删除compose文件中定义的所以镜像.
                        'local': 删除镜像名为空的镜像
     -v, --volumes       删除卷
                        attached to containers.
    --remove-orphans    Remove containers for services not defined in the
                        Compose file
停止和删除容器、网络、卷、镜像，这些内容是通过docker-compose up命令创建的.  默认值删除 容器 网络，可以通过指定 rmi volumes参数删除镜像和卷

events
Usage: events [options] [SERVICE...]

Options:
    --json      输出事件日志，json格式
输出docker-compose 事件的日志，当执行docker-compose命令操作时，docker-compose even命令就会监控日志:
{
    "service": "web",
    "event": "create",
    "container": "213cf75fc39a",
    "image": "alpine:edge",
    "time": "2015-11-20T18:01:03.615550",
}
exec
Usage: exec [options] SERVICE COMMAND [ARGS...]

Options:
-d                分离模式，后台运行命令.
--privileged      获取特权.
--user USER       指定运行的用户.
-T                禁用分配TTY. By default `docker-compose exec`
                  分配 a TTY.
--index=index     当一个服务拥有多个容器时，可通过该参数登陆到该服务下的任何服务，例如：docker-compose exec --index=1 web /bin/bash ，web服务中包含多个容器
                  instances of a service [default: 1]
和docker exec命令功能相同，可以通过service name登陆到容器中
e.g. docker-compose exec web sh 
kill
Usage: kill [options] [SERVICE...]

Options:
-s SIGNAL         向容器发送信号. 默认是SIGKILL.
通过发送 SIGKILL 信号来强制停止服务容器。支持通过参数来指定发送的信号:
$ docker-compose kill -s SIGINT
logs
Usage: logs [options] [SERVICE...]

Options:
--no-color          单色输出，不显示其他颜.
-f, --follow        跟踪日志输出，就是可以实时查看日志
-t, --timestamps    显示时间戳
--tail              从日志的结尾显示，--tail=200
显示日志输出.
pause
Usage: pause [SERVICE...]
暂停容器服务. docker-compose pause  暂停所有服务. docker-compose pause web，之后暂停web服务的容器。
unpause
Usage: unpause [SERVICE...]
恢复容器服务. docker-compose unpause  恢复所有服务. docker-compose unpause web，之后恢复web服务的容器。
port
Usage: port [options] SERVICE PRIVATE_PORT

Options:
--protocol=proto  tcp or udp [default: tcp]
--index=index     index of the container if there are multiple
                  instances of a service [default: 1]
输出服务的共有端口.
# docker-compose port web 8080   -- 8080为容器内部端口
0.0.0.0:8884
ps
Usage: ps [options] [SERVICE...]

Options:
-q    只显示ID
显示容器. 默认显示name、command、state、ports
pull
Usage: pull [options] [SERVICE...]

Options:
--ignore-pull-failures  忽略pull失败的镜像，继续pull其他镜像.
pull compose文件中所指明的镜像.
push
Usage: push [options] [SERVICE...]

Options:
    --ignore-push-failures  忽略错误.
push compose文件中所指明的镜像
restart
Usage: restart [options] [SERVICE...]
 
Options:
-t, --timeout TIMEOUT      Specify a shutdown timeout in seconds. (default: 10)
Restarts services.
rm
Usage: rm [options] [SERVICE...]

Options:
    -f, --force   Don't ask to confirm removal
    -v            期初加载到容器的任何匿名卷
    -a, --all     Also remove one-off containers created by
                  docker-compose run
Removes stopped service containers. 如果服务在运行，需要先docker-compose stop 停止容器
By default, anonymous volumes attached to containers will not be removed. You can override this with -v. To list all volumes, use docker volume ls.

Any data which is not in a volume will be lost.
run
Usage: run [options] [-e KEY=VAL...] SERVICE [COMMAND] [ARGS...]

Options:
 -d                   后台运行，输出容器名.
-e KEY=VAL            设置环境变量参数，可以使用多次
-u, --user=""         指定运行的用户
--no-deps             不启动link服务，只启动run的服务.
--rm                  运行后删除容器，后台运行模式除外(-d).
-p, --publish=[]      开放端口
--service-ports       compose文件中配置什么端口，就映射什么端口.
-T                    禁用TTY.
-w, --workdir=""      设置工作目录
启动web服务器，并执行bash命令.

$ docker-compose run web bash
根据compose配置文件制定的端口，映射到主机:
$ docker-compose run --service-ports web python manage.py shell
指定端口映射到主机:
$ docker-compose run --publish 8080:80 -p 2022:22 -p 127.0.0.1:2021:21 web python manage.py shell

link db容器:
$ docker-compose run db psql -h db -U docker
不linke容器，单独启动指定容器:

$ docker-compose run --no-deps web python manage.py shell
scale
Usage: scale [SERVICE=NUM...]
设置服务的个数.
$ docker-compose scale web=2 worker=3
start
Usage: start [SERVICE...]
启动服务.
stop
Usage: stop [options] [SERVICE...]

Options:
-t, --timeout TIMEOUT     关闭超时时间 (default: 10).
停止容器.
up
Usage: up [options] [SERVICE...]

Options:
    -d                         后台运行，输出容器的名字.
                               Incompatible with --abort-on-container-exit.
    --no-color                  单色输出.
    --no-deps                  不启动link服务.
    --force-recreate           强制重新创建compose服务，即使没有任何改变。重新创建后启动容器
                               Incompatible with --no-recreate.
    --no-recreate               如果容器已经存在，不重新创建.
                               Incompatible with --force-recreate.
    --no-build                 不创建重启，即使镜像不存在.
    --build                    重新创建镜像，然后生成容器.
    --abort-on-container-exit  任何容器停止，自动停止所有容器.
                               Incompatible with -d.
    -t, --timeout TIMEOUT      超时时间. (default: 10)
    --remove-orphans           移除compose文件中未定义服务的容器
