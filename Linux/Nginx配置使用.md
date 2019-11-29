### 一、Nginx安装及配置

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

### 二、Nginx日志管理

`https://nginx.org/en/docs/http/ngx_http_log_module.html`

`ngx_http_log_module`

- Nginx日志配置相关指令
  - log_format
  - access_log
  - error_log
  - open_log_file_cache

1. log_format指令

   ```shell
   Syntax:	access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];
   access_log off;
   Default:	
   access_log logs/access.log combined;
   Context:	http, server, location, if in location, limit_except
   ```

   - name   	表示格式名称
   - string       表示定义的儿是

   注意： 如果nginx位于负载均衡器，squid，nginx反向代理之后，web服务器无法直接获取到客户端真实Ip地址，$remote_addr获取的是反向代理的IP地址，反向代理服务器在转发请求的http头信息中，可以增加$http_x_forwarded_for信息。

   日志格式允许包含的变量：

   - $remote_addr    $http_x_forwarded_for   记录客户端IP地址
   - $remote_user    记录客户端名称
   - $request  记录请求的URL和HTTP协议
   - $status    记录请求状态
   - $body_bytes_sent     发送给客户端的字节数，不包括相应头的大小
   - $http_referer   
   - $bytes_sent    发送给客户端的总字节数
   - $http_user_agent     记录客户端浏览器相关信息
   - connection   连接的序列号
   - $msec   日志写入时间，单位为秒
   - $connection_requests  当前通过一个链接获得的请求数量
   - $http_referer  记录从哪个页面链接访问来的
   - $time_local   通用日志格式下的本地时间
   - $time_iso8601   ISO8601标准下的本地时间
   - $request_length   请求处理时间

2. access_log指令

   ```shell
   Syntax:	access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];
   access_log off;
   Default:	
   access_log logs/access.log combined;
   Context:	http, server, location, if in location, limit_except
   ```

   - gzip   压缩等级
   - buffer   设置内存缓存区大小
   - flush    保存在缓存区中的最长时间

3. open_log_file_cache指令

   ```shell
   Syntax:	open_log_file_cache max=N [inactive=time] [min_uses=N] [valid=time];
   open_log_file_cache off;
   Default:	
   open_log_file_cache off;
   Context:	http, server, location
   ```

   对于每一条日志记录，都将先打开文件，再写入日志，然后关闭。可以使用open_log_file_cache设置日志文件缓存(默认是off)，格式如下

   - max   设置缓存中最大文件描述符数量，如果缓存被占满，采用LCR算法将描述符关闭
   - inactive  设置存活时间 默认10s
   - min_uses   设置在inactive时间段内，日志文件最少使用多少次后，该日志文件描述符记入缓存，默认1次
   - valid：设置检查频率，默认60s
   - off   禁用缓存

   示例：

   `open_log_file_cache  max=1000 inactive=20s valid=1m  min_uses=2`

4. error_log

### 三、Nginx日志轮转

`/etc/logrotate.d/nginx`

```shell
/var/log/nginx/*.log {
        daily     #每天切割
        missingok
        rotate 52    #保留52份
        compress
        delaycompress
        notifempty
        create 640 nginx adm
        sharedscripts
        postrotate
                if [ -f /var/run/nginx.pid ]; then
                        kill -USR1 `cat /var/run/nginx.pid`   #重新加载程序reload信号
                fi
        endscript
}
```

### 四、Nginx日志分析

### 五、Nginx模块管理

- 模块一

1. `ngx_http_stub_status_module`

   ```nginx
   Syntax:	stub_status;
   Default:	—
   Context:	server, location
   ```

2. 编译参数

   `--with-http_stub_status_module`

3. 配置Nginx status

   vim /etc/nginx/conf.d/default.conf

   ```nginx
       location /status {
           stub_status;
       }
   ```

   访问`http://192.168.1.129/status`

   ```nginx
   Active connections: 2 
   server accepts handled requests
    6 6 32 
   Reading: 0 Writing: 1 Waiting: 1
   # 6 总连接数connection
   # 6 成功的连接数connection   失败连接=(总连接数 - 成功连接数)
   # 32 总共处理的请求数
   # connection  tcp连接   请求：http请求
   
   # Reading 读取客户端Header的信息数   请求头
   # Writing  返回给客户端的header的信息数  响应头
   # Waiting   等待的请求数，开启了keepalive
   ```

- 模块二

1. `ngx_http_random_index_module`

   ```nginx
   Syntax:	random_index on | off;
   Default:	
   random_index off;
   Context:	location
   ```

2. 设置网站主目录下的文件随机作为默认主页，不包含隐藏文件

- 模块三

1. `ngx_http_sub_module` 替换网站响应内容

   Dirtctives

   - sub_filter
   - sub_filter_last_modified
   - sub_filter_once
   - sub_filter_types

   假如站点出现什么敏感字，想修改但很耗费时间，可以试试该模块

   或者想临时在站点中加上一个通用js或者css之类的文件，也可以使用该模块

2. 语法

   ```nginx
   Syntax:	sub_filter string replacement;
   Default:	—
   Context:	http, server, location
   ##############################################
   Syntax:	sub_filter_once on | off;
   Default:	
   sub_filter_once on;
   Context:	http, server, location
   ```

3. 示例：

   ```nginx
   location / {
           root   /usr/share/nginx/html;
           index  index.html index.htm;
           sub_filter nginx 'Jiangzhiheng';   #可以用来替换网站中的敏感字
           sub_filter_once on;
       }
   
   ```

4. 如果我们使用模板生成网站的时候，因为疏漏或者别的原因造成代码不如意，但是此时因为文件数量巨大，不方便全部重新生成，那么这个时候我们就可以用此模块实现暂时纠错，另一方面，我们也可以用这个实现服务端文字过滤的效果。

六、Nginx访问控制

模块一：`ngx_http_limit_conn_module`  连接频率限制

1. `ngx_http_limit_conn_module`

   Directives

   - `limit_conn`
   - `limit_conn_log_level`
   - `limit_conn_status`
   - `limit_conn_zone`
   - `limit_zone`

2. 语法

   ```nginx
   Syntax:	limit_conn_zone key zone=name:size;   # size共享内存空间
   Default:	—
   Context:	http
   ```

   注释：

   客户端的IP地址做为键

   - `$remote_addr`   变量的长度为7字节到15字节
   - `$binary_remote_addr`  变量的长度是固定的4字节

   如果共享内存空间被耗尽，服务器将会对后续所有的请求返回503错误

   ```nginx
   Syntax:	limit_conn zone number;
   Default:	—
   Context:	http, server, location
   ```

3. 示例

   ```nginx
   http {
   	limit_conn_zone $binary_remote_addr zone=conn_zone:10m;
   }
   server {
   	location / {
   	...
   	limit_conn conn_zone 2;
   	}
   }
   ```

模块二：`ngx_http_limit_req_module` 请求频率限制

1. `ngx_http_limit_req_module` 

   Directives

   - `limit_req`
   - `limit_req_log_level`
   - `limit_req_status`
   - `limit_req_zone`

2. 语法

   ```nginx
   Syntax:	limit_req_zone key zone=name:size rate=rate [sync];
   Default:	—
   Context:	http
   ```

   ```nginxg
   Syntax:	limit_req zone=name [burst=number] [nodelay | delay=number];
   Default:	—
   Context:	http, server, location
   ```

模块四：访问控制

1. `ngx_http_access_module`

   Directives

   - allow
   - deny

   语法

   ```nginx
   Syntax:	allow address | CIDR | unix: | all;
   Default:	—
   Context:	http, server, location, limit_except
   ```

   ```nginx
   Syntax:	deny address | CIDR | unix: | all;
   Default:	—
   Context:	http, server, location, limit_except
   
   ```

   基于主机的访问控制

   示例

   ```nginx
   location / {
       deny  192.168.1.1;
       allow 192.168.1.0/24;
       allow 10.1.1.0/16;
       allow 2001:0db8::/32;
       deny  all;
   }
   ```

   基于用户的访问控制`ngx_http_auth_basic_module`

   Directives：

   - auth_basic
   - anth_basic_user_file

   语法

   ```nginx
   Syntax:	auth_basic string | off;
   Default:	
   auth_basic off;
   Context:	http, server, location, limit_except
   ```

   ```nginx
   Syntax:	auth_basic_user_file file;
   Default:	—
   Context:	http, server, location, limit_except
   ```

   1. 建立口令文件

      ```shell
      root@martin:~# htpasswd -c /etc/nginx/martin.pass wang
      root@martin:~# htpasswd  /etc/nginx/martin.pass jiang
      root@martin:~# cat /etc/nginx/martin.pass 
      wang:$apr1$35ISJhcQ$RgGOZUu1wqJaLFgzOWb7z.
      jiang:$apr1$ptD1anV8$uYEpN5BUsPn3sub1LF/6Z/
      ```

   2. 实现认证

      ```nginx
      location / {
              root   /usr/share/nginx/html;
              index  index.html index.htm;
              auth_basic "auth test~~~";   #提示信息，可自定义
              auth_basic_user_file /etc/nginx/martin.pass;   #指定生成的口令文件
          }
      
      ```