# Nginx配置

参考资料：

- [Module ngx_http_core_module](http://nginx.org/en/docs/http/ngx_http_core_module.html)
- [nginx 这一篇就够了](https://juejin.im/post/5d81906c518825300a3ec7ca#heading-45)
- 



## 配置文件
```
#定义 nginx 运行的用户和用户组
user www www;

#nginx 进程数，建议设置为等于 CPU 总核心数。
worker_processes 8;

#nginx 默认没有开启利用多核 CPU, 通过增加 worker_cpu_affinity 配置参数来充分利用多核 CPU 以下是 8 核的配置参数
worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000 10000000;

#全局错误日志定义类型，[ debug | info | notice | warn | error | crit ]
error_log /var/log/nginx/error.log info;

#进程文件
pid /var/run/nginx.pid;

#一个 nginx 进程打开的最多文件描述符数目，理论值应该是最多打开文件数（系统的值 ulimit -n）与 nginx 进程数相除，但是 nginx 分配请求并不均匀，所以建议与 ulimit -n 的值保持一致。
worker_rlimit_nofile 65535;

#工作模式与连接数上限
events
{
    #参考事件模型，use [ kqueue | rtsig | epoll | /dev/poll | select | poll ]; epoll 模型是 Linux 2.6 以上版本内核中的高性能网络 I/O 模型，如果跑在 FreeBSD 上面，就用 kqueue 模型。
    #epoll 是多路复用 IO(I/O Multiplexing) 中的一种方式，但是仅用于 linux2.6 以上内核，可以大大提高 nginx 的性能
    use epoll;

    ############################################################################
    #单个后台 worker process 进程的最大并发链接数
    #事件模块指令，定义 nginx 每个进程最大连接数，默认 1024。最大客户连接数由 worker_processes 和 worker_connections 决定
    #即 max_client=worker_processes*worker_connections, 在作为反向代理时：max_client=worker_processes*worker_connections / 4
    worker_connections 65535;
    ############################################################################
}

#设定 http 服务器
http {
    include mime.types; #文件扩展名与文件类型映射表
    default_type application/octet-stream; #默认文件类型
    #charset utf-8; #默认编码

    server_names_hash_bucket_size 128; #服务器名字的 hash 表大小
    client_header_buffer_size 32k; #上传文件大小限制
    large_client_header_buffers 4 64k; #设定请求缓
    client_max_body_size 8m; #设定请求缓
    sendfile on; #开启高效文件传输模式，sendfile 指令指定 nginx 是否调用 sendfile 函数来输出文件，对于普通应用设为 on，如果用来进行下载等应用磁盘 IO 重负载应用，可设置为 off，以平衡磁盘与网络 I/O 处理速度，降低系统的负载。注意：如果图片显示不正常把这个改成 off。
    autoindex on; #开启目录列表访问，合适下载服务器，默认关闭。
    tcp_nopush on; #防止网络阻塞
    tcp_nodelay on; #防止网络阻塞

    ##连接客户端超时时间各种参数设置##
    keepalive_timeout  120;          #单位是秒，客户端连接时时间，超时之后服务器端自动关闭该连接 如果 nginx 守护进程在这个等待的时间里，一直没有收到浏览发过来 http 请求，则关闭这个 http 连接
    client_header_timeout 10;        #客户端请求头的超时时间
    client_body_timeout 10;          #客户端请求主体超时时间
    reset_timedout_connection on;    #告诉 nginx 关闭不响应的客户端连接。这将会释放那个客户端所占有的内存空间
    send_timeout 10;                 #客户端响应超时时间，在两次客户端读取操作之间。如果在这段时间内，客户端没有读取任何数据，nginx 就会关闭连接
    ################################

    #FastCGI 相关参数是为了改善网站的性能：减少资源占用，提高访问速度。下面参数看字面意思都能理解。
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;

    ###作为代理缓存服务器设置#######
    ###先写到 temp 再移动到 cache
    #proxy_cache_path /var/tmp/nginx/proxy_cache levels=1:2 keys_zone=cache_one:512m inactive=10m max_size=64m;
    ###以上 proxy_temp 和 proxy_cache 需要在同一个分区中
    ###levels=1:2 表示缓存级别，表示缓存目录的第一级目录是 1 个字符，第二级目录是 2 个字符 keys_zone=cache_one:128m 缓存空间起名为 cache_one 大小为 512m
    ###max_size=64m 表示单个文件超过 128m 就不缓存了  inactive=10m 表示缓存的数据，10 分钟内没有被访问过就删除
    #########end####################

    #####对传输文件压缩###########
    #gzip 模块设置
    gzip on; #开启 gzip 压缩输出
    gzip_min_length 1k; #最小压缩文件大小
    gzip_buffers 4 16k; #压缩缓冲区
    gzip_http_version 1.0; #压缩版本（默认 1.1，前端如果是 squid2.5 请使用 1.0）
    gzip_comp_level 2; #压缩等级，gzip 压缩比，1 为最小，处理最快；9 为压缩比最大，处理最慢，传输速度最快，也最消耗 CPU；
    gzip_types text/plain application/x-javascript text/css application/xml;
    #压缩类型，默认就已经包含 text/html，所以下面就不用再写了，写上去也不会有问题，但是会有一个 warn。
    gzip_vary on;
    ##############################

    #limit_zone crawler $binary_remote_addr 10m; #开启限制 IP 连接数的时候需要使用

    upstream blog.ha97.com {
        #upstream 的负载均衡，weight 是权重，可以根据机器配置定义权重。weigth 参数表示权值，权值越高被分配到的几率越大。
        server 192.168.80.121:80 weight=3;
        server 192.168.80.122:80 weight=2;
        server 192.168.80.123:80 weight=3;
    }

    #虚拟主机的配置
    server {
        #监听端口
        listen 80;

        #############https##################
        #listen 443 ssl;
        #ssl_certificate /opt/https/xxxxxx.crt;
        #ssl_certificate_key /opt/https/xxxxxx.key;
        #ssl_protocols SSLv3 TLSv1;
        #ssl_ciphers HIGH:!ADH:!EXPORT57:RC4+RSA:+MEDIUM;
        #ssl_prefer_server_ciphers on;
        #ssl_session_cache shared:SSL:2m;
        #ssl_session_timeout 5m;
        ####################################end

        #域名可以有多个，用空格隔开
        server_name www.ha97.com ha97.com;
        index index.html index.htm index.php;
        root /data/www/ha97;
        location ~ .*.(php|php5)?$ {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi.conf;
        }

        #图片缓存时间设置
        location ~ .*.(gif|jpg|jpeg|png|bmp|swf)$ {
            expires 10d;
        }

        #JS 和 CSS 缓存时间设置
        location ~ .*.(js|css)?$ {
            expires 1h;
        }

        #日志格式设定
        log_format access '$remote_addr - $remote_user [$time_local] "$request" ' '$status $body_bytes_sent "$http_referer" ' '"$http_user_agent" $http_x_forwarded_for';

        #定义本虚拟主机的访问日志
        access_log /var/log/nginx/ha97access.log access;

        #对 "/" 启用反向代理
        location / {
            proxy_pass http://127.0.0.1:88;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            #后端的 Web 服务器可以通过 X-Forwarded-For 获取用户真实 IP
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #以下是一些反向代理的配置，可选。
            proxy_set_header Host $host;
            client_max_body_size 10m; #允许客户端请求的最大单文件字节数
            client_body_buffer_size 128k; #缓冲区代理缓冲用户端请求的最大字节数，

            ##代理设置 以下设置是 nginx 和后端服务器之间通讯的设置##
            proxy_connect_timeout 90; #nginx 跟后端服务器连接超时时间（代理连接超时）
            proxy_send_timeout 90; #后端服务器数据回传时间（代理发送超时）
            proxy_read_timeout 90; #连接成功后，后端服务器响应时间（代理接收超时）
            proxy_buffering on;    #该指令开启从后端被代理服务器的响应内容缓冲 此参数开启后 proxy_buffers 和 proxy_busy_buffers_size 参数才会起作用
            proxy_buffer_size 4k;  #设置代理服务器（nginx）保存用户头信息的缓冲区大小
            proxy_buffers 4 32k;   #proxy_buffers 缓冲区，网页平均在 32k 以下的设置
            proxy_busy_buffers_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
            proxy_max_temp_file_size 2048m; #默认 1024m, 该指令用于设置当网页内容大于 proxy_buffers 时，临时文件大小的最大值。如果文件大于这个值，它将从 upstream 服务器同步地传递请求，而不是缓冲到磁盘
            proxy_temp_file_write_size 512k; 这是当被代理服务器的响应过大时 nginx 一次性写入临时文件的数据量。
            proxy_temp_path  /var/tmp/nginx/proxy_temp;    ##定义缓冲存储目录，之前必须要先手动创建此目录
            proxy_headers_hash_max_size 51200;
            proxy_headers_hash_bucket_size 6400;
            #######################################################
        }

        #设定查看 nginx 状态的地址
        location /nginxStatus {
            stub_status on;
            access_log on;
            auth_basic "nginxStatus";
            auth_basic_user_file conf/htpasswd;
            #htpasswd 文件的内容可以用 apache 提供的 htpasswd 工具来产生。
        }

        #本地动静分离反向代理配置
        #所有 jsp 的页面均交由 tomcat 或 resin 处理
        location ~ .(jsp|jspx|do)?$ {
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://127.0.0.1:8080;
        }

        #所有静态文件由 nginx 直接读取不经过 tomcat 或 resin
        location ~ .*.(htm|html|gif|jpg|jpeg|png|bmp|swf|ioc|rar|zip|txt|flv|mid|doc|ppt|pdf|xls|mp3|wma)$
        { expires 15d; }

        location ~ .*.(js|css)?$
        { expires 1h; }
    }
}

```

docker启动

```sh
docker run --name my_nginx -v /dockerData/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /dockerData/nginx/data:/nginx/data -v /dockerData/nginx/log:/var/log/nginx -p 8080:8080 -d nginx:1.17.5

docker run  --name myredis -v /dockerData/redis/conf/redis.conf:/usr/local/etc/redis/redis.conf - v /dockerData/redis/data:/var/lib/redis -d -p 6379:6379 redis:5.0.6 redis-server /usr/local/etc/redis/redis.conf
```

## 全局模块

**user nobody**

定义运行nginx服务的用户,还可以加上组,如 user nobody nobody;使用**root**启动**master**进程，默认会使用**nginx**启动**worker**进程



**worker_processes 1**

 定义nginx子进程（工作进程）数量，即提供服务的进程数量，该数值建议和服务cpu核数保持一致。
除了可以定义数字外，还可以定义为**auto**，表示让系统自动调整。



**error_log logs/error.log**

定义错误日志的路径，可以是相对路径（相对prefix路径的），也可以是绝对路径。
该配置可以在此处定义，也可以定义到http、server、location里



**error_log logs/error.log notice**

定义错误日志路径以及日志级别，级别越高记录的信息越少，如果不定义默认是**error**。
错误日志级别：常见的错误日志级别有[**debug**|**info**|**notice**|**warn**|**error**|**crit**|**alert**|**emerg**]。



**pid logs/nginx.pid**

 定义nginx进程pid文件所在路径，可以是相对路径，也可以是绝对路径。



**worker_rlimit_nofile 100000**

定义nginx最多打开文件数限制。如果没设置的话，这个值为操作系统（ulimit -n）的限制保持一致。
把这个值设高，nginx就不会有“too many open files”问题了。



##events模块

**use epoll**

使用epoll的I/O 模型(默认会使用最适合操作系统的模型)

- 标准事件模型

  Select、poll属于标准事件模型，如果当前系统不存在更有效的方法，nginx会选择select或poll

- 高效事件模型

  - Kqueue：使用于FreeBSD 4.1+, OpenBSD 2.9+, NetBSD 2.0 和 MacOS X。使用双处理器的MacOS X系统使用kqueue可能会造成内核崩溃。

  - Epoll:使用于Linux内核2.6版本及以后的系统。



**worker_connections 2000**

工作进程的最大连接数量 理论上每台nginx服务器的最大连接数为worker_processes*worker_connections worker_processes为我们再main中开启的进程数。



**keepalive_timeout 60**

keepalive超时时间。 这里指的是**http**层面的keep-alive。



**client_header_buffer_size 4k**

客户端请求头部的缓冲区大小，这个可以根据你的系统分页大小来设置，一般一个请求头的大小不会超过1k，不过由于一般系统分页都要大于1k，所以这里设置为系统分页大小。查看系统分页可以使用 getconf PAGESIZE命令。

**open_file_cache max=2000 inactive=60s**
为打开文件指定缓存，默认是没有启用的，max指定缓存最大数量，建议和打开文件数一致，inactive是指经过多长时间文件没被请求后删除缓存 打开文件最大数量为我们再main配置的worker_rlimit_nofile参数



**open_file_cache_valid 60s**

这个是指多长时间检查一次缓存的有效信息。如果有一个文件在inactive时间内一次没被使用，它将被移除



**open_file_cache_min_uses 1**

open_file_cache指令中的inactive参数时间内文件的最少使用次数，如果超过这个数字，文件描述符一直是在缓存中打开的，如果有一个文件在inactive时间内一次没被使用，它将被移除。



## Http模块

```
http {
    include mime.types;   #文件扩展名与文件类型映射表
    include /etc/nginx/myconf/*.conf;  #引入扩展配置表
    default_type  application/octet-stream;  #默认文件类型，默认为text/plain
    #access_log off; #取消服务日志    
    log_format myFormat '$remote_addr–$remote_user [$time_local] $request $status $body_bytes_sent $http_referer $http_user_agent $http_x_forwarded_for'; #自定义日志格式
    access_log log/access.log myFormat;  #combined为日志格式的默认值
    sendfile on;   #允许sendfile方式传输文件，默认为off，可以在http块，server块，location块。
    sendfile_max_chunk 100k;  #每个进程每次调用传输数量不能大于设定的值，默认为0，即不设上限。
    keepalive_timeout 65;  #http协议的超时连接时间。连接超时时间，默认为75s，可以在http，server，location块。
    # 定义常量
    upstream mysvr {   
      server 127.0.0.1:7878;
      server 192.168.10.121:3333 backup;  #热备
    }
    error_page 404 https://www.baidu.com; #错误页 

    #定义某个负载均衡服务器   
    server {
        keepalive_requests 120; #单连接请求上限次数。
        listen       4545;   #监听端口
        server_name  127.0.0.1;   #监听地址       
        location  ~*^.+$ {       #请求的url过滤，正则匹配，~为区分大小写，~*为不区分大小写。
           #root path;  #根目录
           #index vv.txt;  #设置默认页
           proxy_pass  http://mysvr;  #请求转向mysvr 定义的服务器列表
           deny 127.0.0.1;  #拒绝的ip
           allow 172.18.5.54; #允许的ip           
        } 
    }
} 
```

- **include**
  - **include mime.types**

  对于HTTP协议中，在**HTTP报文头部**插入解释自身数据类型的MIME头部信息（**`Content-Type`**）。客户端接收到这部分有关数据类型的信息，就能调用相应的程序处理数据。电子邮件的**SMTP协议**，通过MIME，可以在邮件中插入多媒体的数据。

  ```
  types {
      text/html                             html htm shtml;
      text/css                              css;
      text/xml                              xml;
      image/gif                             gif;
      image/jpeg                            jpeg jpg;
      application/javascript                js;
      application/atom+xml                  atom;
      application/rss+xml                   rss;
    	......
  }
  ```

  - **include [conf文件路径]**

  主配置文件nginx.conf中指定包含其他扩展配置文件，从而简化nginx主配置文件，实现多个站点功能。一般扩展配置文件中扩展其他server服务。

- **default_type [文件类型]**

  返回响应默认文件类型，默认为text/plain，可以在http模块，server模块，location模块。

- **access_log off**

- **log_format**

- **sendfile on/off**

  默认off。sendfile系统调用在两个文件描述符之间直接传递数据(完全在**内核中**操作)，从而避免了数据在**内核缓冲区**和**用户缓冲区**之间的拷贝

- **sendfile_max_chunk 100k**

  每个进程每次调用传输数量不能大于设定的值，默认为0，即不设上限。

- **upstream**

  默认使用轮询方式负载均衡。

  ```
  upstream myservers{
      ip_hash; # 每个请求按照访问ip的 hash结果分配，这样每个访客会固定访问一个后端服务器
      server 192.168.1.11:8888  weight=1; # 权重，指定轮询比率，weight 和访问几率成正比
      server 192.168.1.22:8888; 
      server 192.168.1.33:8888;
      fair;
      
      hash $request_uri; # 与ip_hash类似，但是按照访问url的hash结果来分配请求，使得每个url定向到同一个后端服务器，主要应用于后端服务器为缓存时的场景下
      hash_method crc32; # hash_method为使用的hash算法，需要注意的是：此时，server语句中不能加weight等参数。
  }
  ```

- **error_page** \[404|500|....] [https://www.baidu.com|页面]#错误页  

 ### server

- **listen**

  listen指令的格式很复杂

  ```
  listen *:80 | *:8000; # 监听所有的 80 和 8000 端口
  listen 192.168.1.10:8000;
  listen 192.168.1.10;
  listen 8000; # 等同于 listen *:8000;
  listen 192.168.1.10 default_server backlog=511; # 该 ip 的连接请求默认由此虚拟主机处理；最多允许 1024 个网络连接同时处于挂起状态
  ```

- **server_name**

  > 因为一个ip可能对应不同的域名，根据不同的域名来进行对应的处理

  **基于名称的虚拟主机配置**，nginx会取出header头中的host，与nginx.conf中每个server的server_name进行匹配，以此决定到底由哪一个server块来处理这个请求。

  1. 准确匹配到 server_name
  2. 通配符在开始时匹配到 server_name，*.abc.com ，通配符代表www/com/区域
  3. 通配符在结尾时匹配到 server_name，www.abc.\*
  4. 正则表达式匹配 server_name
  5. 优先选择**listen**配置项后有**default**|**default_server**的
  6. 找到匹配listen端口的第一个server块

- **location [ = | ~ | ~* | ^~ ] uri {...} **

  这里内容分 2 部分，**匹配方式**和** uri**， 其中** uri **又分为 `标准 uri` 和`正则 uri`

  先不考虑 那 4 种匹配方式		

  1. nginx 首先会再 server 块的多个 location 中搜索是否有`标准 uri`和请求字符串匹配， 如果有，记录匹配度最高的一个。`/abc/def`可以匹配`/abc/defghi`请求，也可以匹配`/abc/def/ghi`等
  2. 然后，再用 location 块中的`正则 uri`和请求字符串匹配， 当第一个`正则 uri`匹配成功，即停止搜索， 并使用该 location 块处理请求。
  3. 如果，所有的`正则 uri`都匹配失败，就使用刚记录下的匹配度最高的一个`标准 uri`处理请求。
  4. 如果都失败了，那就失败。

  再看 4 种匹配方式：

  - `=`:  用于`标准 uri`前，要求请求字符串与其严格匹配，成功则立即处理
  - `^~`: 用于`标准 uri`前，并要求一旦匹配到，立即处理，不再去匹配其他的那些个`正则 uri`
  - `~`:  用于`正则 uri`前，表示 uri 包含正则表达式， 并区分大小写
  - `~*`: 用于`正则 uri`前， 表示 uri 包含正则表达式， 不区分大小写

  `^~` 也是支持浏览器编码过的 URI 的匹配， 如 `/html/%20/data` 可以成功匹配 `/html/ /data`

#### location

- **alias**  路径

  用于访问文件系统，在匹配到location配置的URL路径后，指向**alias**配置的路径。

  ```
  location /test/ {
  		alias /first/second/img/; 
  }
  ```

  请求`/test/picture.png`，返回`/first/second/img/picture.png`

- **root** 路径

   用于访问文件系统，在匹配到location配置的URL路径后，指向**root**配置的路径，将请求的路径带上。

  ```
  location /test/ {
  		root /first/second/img/; 
  }
  ```

  请求`/test/picture.png`，返回`/first/second/img/test/picture.png`

- **proxy_pass** url路径|uri

  请求访问/test/proxy

  ```
  location /test/ {
  		proxy_pass http://127.0.0.1:81; # 请求转发到 http://127.0.0.1:81/test/proxy
  		proxy_pass http://127.0.0.1:81/; # 请求转发到 http://127.0.0.1:81/proxy
  		proxy_pass http://127.0.0.1:81/abc/; # 请求转发到 http://127.0.0.1:81/abc/proxy
  		proxy_pass http://127.0.0.1:81/abc; # 请求转发到 http://127.0.0.1:81/abcproxy
  }
  ```



-  **autoindex on**

  打开自动列表功能，默认off。用作文件服务器。配合fileon