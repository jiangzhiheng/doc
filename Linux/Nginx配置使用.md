一、Nginx安装及配置

1. 概述：

   Nginx是一个高性能的HTTP和反向代理服务器，也是一个IMAP/POP3/SMTP服务器

   - 高性能的Http Server，解决C10K的问题
   - 高性能的反向代理服务器，给网站加速
   - 做为LB集群的前端一个负载均衡器

   Nginx的优势

   - IO多路复用 I/O multiplexing [多并发]
   - epoll模型
   - 异步，非阻塞

2. Nginx部署--YUM

   vim /etc/yum.repos.d/nginx.repo

   ```shell
   [nginx-stable]
   name=nginx stable repo
   baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
   gpgcheck=1
   enabled=1
   gpgkey=https://nginx.org/keys/nginx_signing.key
   module_hotfixes=true
   
   [nginx-mainline]
   name=nginx mainline repo
   baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
   gpgcheck=1
   enabled=0
   gpgkey=https://nginx.org/keys/nginx_signing.key
   module_hotfixes=true
   ```

   若想使用mainline版本

   `yum-config-manager --enable nginx-mainline`

   安装nginx

   `yum install nginx`

   `systemctl start nginx`

   `systemctl enable nginx`

   `[root@nginx01 ~]# nginx -v`
   `nginx version: nginx/1.16.1`

3. nginx配置文件

   ```shell
   /etc/logrotate.d/nginx    #定义日志轮转
   /etc/nginx
   /etc/nginx/conf.d   #子配置文件
   /etc/nginx/conf.d/default.conf
   /etc/nginx/fastcgi_params
   /etc/nginx/koi-utf
   /etc/nginx/koi-win
   /etc/nginx/mime.types
   /etc/nginx/modules
   /etc/nginx/nginx.conf   #主配置文件
   /etc/nginx/scgi_params
   /etc/nginx/uwsgi_params
   /etc/nginx/win-utf
   /etc/sysconfig/nginx
   /etc/sysconfig/nginx-debug
   /usr/lib/systemd/system/nginx-debug.service
   /usr/lib/systemd/system/nginx.service
   /usr/lib64/nginx
   /usr/lib64/nginx/modules
   /usr/libexec/initscripts/legacy-actions/nginx
   /usr/libexec/initscripts/legacy-actions/nginx/check-reload
   /usr/libexec/initscripts/legacy-actions/nginx/upgrade
   /usr/sbin/nginx   #程序文件
   /usr/sbin/nginx-debug
   /usr/share/doc/nginx-1.16.1
   /usr/share/doc/nginx-1.16.1/COPYRIGHT
   /usr/share/man/man8/nginx.8.gz
   /usr/share/nginx
   /usr/share/nginx/html
   /usr/share/nginx/html/50x.html
   /usr/share/nginx/html/index.html
   /var/cache/nginx
   /var/log/nginx   #nginx日志
   ```

4. nginx编译参数

   ```shell
   [root@nginx01 ~]# nginx -V
   nginx version: nginx/1.16.1
   built by gcc 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC) 
   built with OpenSSL 1.0.2k-fips  26 Jan 2017
   TLS SNI support enabled
   configure arguments:
   # 指定相关文件路径（配置文件，日志文件，二进制文件，缓存文件）
    --prefix=/etc/nginx  #安装路径
    --sbin-path=/usr/sbin/nginx  #进程文件路径
    --modules-path=/usr/lib64/nginx/modules   #模块路径
    --conf-path=/etc/nginx/nginx.conf 
    --error-log-path=/var/log/nginx/error.log 
    --http-log-path=/var/log/nginx/access.log 
    --pid-path=/var/run/nginx.pid 
    --lock-path=/var/run/nginx.lock  #锁路径
    --http-client-body-temp-path=/var/cache/nginx/client_temp 
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp 
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp 
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp 
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp 
    # 运行nginx进程的用户和组
    --user=nginx 
    --group=nginx 
    # 支持的模块
    --with-compat 
    --with-file-aio 
    --with-threads 
    --with-http_addition_module 
    --with-http_auth_request_module 
    --with-http_dav_module 
    --with-http_flv_module 
    --with-http_gunzip_module 
    --with-http_gzip_static_module 
    --with-http_mp4_module 
    --with-http_random_index_module 
    --with-http_realip_module 
    --with-http_secure_link_module 
    --with-http_slice_module 
    --with-http_ssl_module 
    --with-http_stub_status_module 
    --with-http_sub_module 
    --with-http_v2_module 
    --with-mail 
    --with-mail_ssl_module 
    --with-stream 
    --with-stream_realip_module 
    --with-stream_ssl_module 
    --with-stream_ssl_preread_module 
    # 编译优化参数
    --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong 
    --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' 
    --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
   ```

5. nginx基本配置

   CoreModule	核心模块

   EventsModule  事件驱动模块

   HttpCoreModule   http内核模块

   ```shell
   #/*CoreModule*/
   user  nginx;
   worker_processes  1;      #启动的worker进程数量(CPU数量一致或auto)
   
   error_log  /var/log/nginx/error.log warn;
   pid        /var/run/nginx.pid;
   
   #/*EventsModule*/
   events {
       use epoll;			//事件驱动模型epoll(默认)
       worker_connections  1024;    //每个worker进程允许的最大连接数，例如10240，65535
   }
   #/*HttpCoreModule*/
   http {
       include       /etc/nginx/mime.types;
       default_type  application/octet-stream;
   
       log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                         '$status $body_bytes_sent "$http_referer" '
                         '"$http_user_agent" "$http_x_forwarded_for"';
   
       access_log  /var/log/nginx/access.log  main;
   
       sendfile        on;
       #tcp_nopush     on;
   
       keepalive_timeout  65;
   
       #gzip  on;
   
       include /etc/nginx/conf.d/*.conf;
   }
   ```

   `vim /etc/nginx/conf.d/default.conf`

   ```shell
   server {
       listen       80;
       server_name  localhost;
   
       #charset koi8-r;
       #access_log  /var/log/nginx/host.access.log  main;
   
       location / {
           root   /usr/share/nginx/html;
           index  index.html index.htm;
       }
   
       #error_page  404              /404.html;
   
       # redirect server error pages to the static page /50x.html
       #
       error_page   500 502 503 504  /50x.html;
       location = /50x.html {
           root   /usr/share/nginx/html;
       }
   
       # proxy the PHP scripts to Apache listening on 127.0.0.1:80
       #
       #location ~ \.php$ {
       #    proxy_pass   http://127.0.0.1;
       #}
   
       # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
       #
       #location ~ \.php$ {
       #    root           html;
       #    fastcgi_pass   127.0.0.1:9000;
       #    fastcgi_index  index.php;
       #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
       #    include        fastcgi_params;
       #}
   
       # deny access to .htaccess files, if Apache's document root
       # concurs with nginx's one
       #
       #location ~ /\.ht {
       #    deny  all;
       #}
   }
   ```

6. 