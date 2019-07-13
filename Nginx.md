
docker run --name mynginx -d -p 82:80  -v /data/nginx/conf:/etc/nginx  -v /data/nginx/logs:/var/log/nginx -v /data/nginx/data:/data/nginx/data -u 0 nginx

```conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
 
include /usr/share/nginx/modules/*.conf;
 
events {
    worker_connections 1024;
}
 
http {
    log_format main  '$remote_addr - $remote_user[$time_local] "$request" '
                      '$status $body_bytes_sent"$http_referer" '
                     '"$http_user_agent" "$http_x_forwarded_for"';
 
    access_log /var/log/nginx/access.log  main;
 
    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;
 
    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;
 
    # Load modular configuration files from the/etc/nginx/conf.d directory.
    # Seehttp://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;
 
    server {
        listen       80 default_server;
        root         /usr/share/nginx/html;
 
        # Loadconfiguration files for the default server block.
        include/etc/nginx/default.d/*.conf;
 
        location /{
        index  index.html index.htm;
        autoindex on;       #开启nginx目录浏览功能
        autoindex_exact_size off;   #文件大小从KB开始显示
                        #默认为on，显示出文件的确切大小，单位是bytes。
                         #改为off后，显示出文件的大概大小，单位是kB或者MB或者GB
        autoindex_localtime on;     #显示文件修改时间为服务器本地时间
        charset utf-8,gbk;          #显示中文
     #  limit_conn one 8;        #并发数
        limit_rate 100k;         #单个线程最大下载速度，单位KB/s        }
 
        error_page 404 /404.html;
            location = /40x.html {
        }
 
        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
    }
}
```
# 源码编译安装
## 环境安装
```s
yum install -y pcre pcre-devel gcc-c++ zlib zlib-devel openssl openssl-devel
wget http://nginx.org/download/nginx-1.14.0.tar.gz
tar -zxf nginx-1.14.0.tar.gz
rm -rf nginx-1.14.0.tar.gz
cd nginx-1.14.0
./configure&&make&&make install
echo "PATH=$PATH:/usr/local/nginx/sbin" >> /etc/profile
echo "export PATH" >> /etc/profile
source /etc/profile
nginx -v
```
## 命令 
- nginx -s stop  给一个 nginx 主进程发送信号 快速关闭
- nginx -s quit  是一个**优雅**的关闭方式，Nginx在退出前**完成已经接受的连接请求**。
- nginx -s reload 重启
## 配置文件
/usr/local/nginx/conf/nginx.conf



