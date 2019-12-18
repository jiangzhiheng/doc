### 一、HTTP协议

`URI：HTTP`请求的内容统称为资源，‘资源’这一概念非常宽泛，它可以是一份文档，一张图片，或所有其它你能想到的格式。每个资源都是由一个(URI)来进行标识，URL即统一资源定位符，它是URI的一种

1. URL与URN

   - URI 的最常见形式是统一资源定位符URL，它也被称为 *Web 地址*
   - URN 是另一种形式的 URI，它通过特定命名空间中的唯一名称来标识资源。

2. 统一资源标识符的语法

   `http://`告诉浏览器使用何种协议。对于大部分 Web 资源，通常使用 HTTP 协议或其安全版本，`HTTPS `协议。另外，浏览器也知道如何处理其他协议。例如， `mailto:` 协议指示浏览器打开邮件客户端；`ftp:`协议指示浏览器处理文件传输

   - 方案或协议

     `http://`

     `https`

     `ftp`

     ........

   - 主机

     `www.example.com`

   - 端口

     :80

     表示用于访问 Web 服务器上资源的技术“门”。如果访问的该 Web 服务器使用HTTP协议的标准端口（HTTP为80，HTTPS为443）授予对其资源的访问权限，则通常省略此部分。否则端口就是 URI 必须的部分。

   - 路径

     `path/to/myfile.html`

     `/path/to/myfile.html` 是 Web 服务器上资源的路径。在 Web 的早期，类似这样的路径表示 Web 服务器上的物理文件位置。现在，它主要是由没有任何物理实体的 Web 服务器抽象处理而成的。

   - 查询

     `?key1=value1&key2=value2`

     参数是用 & 符号分隔的键/值对列表。Web 服务器可以在将资源返回给用户之前使用这些参数来执行额外的操作。

   - 片段

     `#SomewhereInTheDocument`

     `#SomewhereInTheDocument` 是资源本身的某一部分的一个锚点。锚点代表资源内的一种“书签”，它给予浏览器显示位于该“加书签”点的内容的指示。 例如，在HTML文档上，浏览器将滚动到定义锚点的那个点上；在视频或音频文档上，浏览器将转到锚点代表的那个时间。值得注意的是 # 号后面的部分，也称为片段标识符，永远不会与请求一起发送到服务器。

3. HTTP概览

   `https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Overview`

   基于HTTP的组件系统

   - 客户端：user-agent
   - Web服务器
   - 代理(Proxies)
     - 缓存
     - 过滤(反病毒扫描，家长控制，，，)
     - 负载均衡
     - 认证
     - 日志记录

   HTTP的基本性质

   - HTTP是简单的

   - HTTP是可扩展的

   - HTTP是无状态，有会话的

     HTTP是无状态的：在同一个连接中，两个执行成功的请求之间是没有关系的。

   - HTTP和连接

   HTTP可以控制的常见特性

   - 缓存
   - 开放同源限制
   - 认证
   - 代理和隧道
   - 会话

   HTTP流

   - 打开一个TCP连接
   - 发送一个HTTP报文
   - 读取服务端返回的报文信息
   - 关闭连接或者为后续请求重用连接

   HTTP报文

   - 请求
   - 响应

4. HTTP Header

   场景一：下载一个源码包

   ```shell
   [root@nginx01 app]# wget -d http://nginx.org/download/nginx-1.12.1.tar.gz
   ---request begin---
   GET /download/nginx-1.12.1.tar.gz HTTP/1.1
   User-Agent: Wget/1.14 (linux-gnu)
   Accept: */*
   Host: nginx.org
   Connection: Keep-Alive
   
   ---request end---
   HTTP request sent, awaiting response... 
   ---response begin---
   HTTP/1.1 200 OK   #协议版本
   Server: nginx/1.17.3  #服务器软件版本
   Date: Wed, 04 Dec 2019 06:15:33 GMT   #从服务器获取该资源的时间
   Content-Type: application/octet-stream   #字节流，响应的数据类型，其它还有图片，视频，json，html，xml，css等；
   Content-Length: 981093  #请求的资源大小
   Last-Modified: Tue, 11 Jul 2017 15:45:25 GMT #下载的文件在服务器最后修改时间
   Connection: keep-alive  #支持长连接
   Keep-Alive: timeout=15
   ETag: "5964f295-ef865" #ETag HTTP响应头是资源的特定版本的标识符，这可以让缓存更高效
   Accept-Ranges: bytes
   
   ---response end---
   200 OK
   Registered socket 3 for persistent reuse.
   Length: 981093 (958K) [application/octet-stream]
   Saving to: ‘nginx-1.12.1.tar.gz’
   
   100%[==================================================>] 981,093      210KB/s   in 4.6s   
   
   2019-12-03 23:36:05 (210 KB/s) - ‘nginx-1.12.1.tar.gz’ saved [981093/981093]
   
   ```

   

### 二、Nginx Web服务器

1. 静态资源

   非Web服务器端运行处理而生成的文件

   - 浏览器渲染：`HTML，CSS，JS`
   - 图片文件：`GIF，JPEG`
   - 视频文件：`MP4，FLV，MPEG`
   - 其它文件：`ISO，PDF，TXT，EXE`

2. 文件读取

   ```nginx
   Syntax:	sendfile on | off;
   Default:	
   sendfile off;
   Context:	http, server, location, if in location
   ```

   ```nginx
   Syntax:	tcp_nodelay on | off;   #不缓存数据，及时发送，及时性要求较高的场景
   Default:	
   tcp_nodelay on;
   Context:	http, server, location
   ```

   ```nginx
   Syntax:	tcp_nopush on | off;    #在一个数据包中发送所有的头文件
   Default:	
   tcp_nopush off;
   Context:	http, server, location
   ```

   使用`sendfile()`来进行网络传输的过程

   硬盘 >> `kernel buffer(快速拷贝到kernel sorcket buffer)` >> 协议栈

   `sendfile()`不但能减少切换次数而且还能减少拷贝次数

3. 文件压缩

   - 文件压缩 `ngx_http_gzip_module`

     - 示例

       ```nginx
       gzip            on;
       gzip_min_length 1000;
       gzip_proxied    expired no-cache no-store private auth;
       gzip_types      text/plain application/xml;
       ```

     - 语法

       ```nginx
       Syntax:	gzip on | off;
       Default:	
       gzip off;
       Context:	http, server, location, if in location
       ```

       ```nginx
       Syntax:	gzip_types mime-type ...;
       Default:	
       gzip_types text/html;
       Context:	http, server, location
       ```

       ```nginx
       Syntax:	gzip_comp_level level;
       Default:	
       gzip_comp_level 1;
       Context:	http, server, location
       ```

     - 配置示例

       ```nginx
       location ~ .*\.(jpg|gif|png)$ {
       	gzip on;
       	gzip_http_version 1.1;
       	gzip_comp_level 2;
       	gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
       	root /app/martin.show/images;
       }
       ```

   - 预读`ngx_http_gzip_static_module`

     ``` nginx
     location ~ ^/download {
     	gzip_static on;
     	tcp_nopush on;
     	root /app/martin.show;
     }
     ```

4. HTTP协议定义的缓存机制 `ngx_http_headers_module`

   指令：

   - `Expires     http1.0`
   - `Cache-Control(max-age)   http1.1`

   浏览器第一次请求   无缓存

   浏览器第二次请求    有缓存，校验是否过期

5. 防盗链 `ngx_http_referer_module`

   - 语法

     ```nginx
     Syntax:	valid_referers none | blocked | server_names | string ...;
     Default:	—
     Context:	server, location
     ```

   - 示例：

     ```nginx
     valid_referers none blocked *.martin.show;
     if($invalid_referer){
     	return 403;
     }
     ```

     如果希望某些网站能够使用资源

     ```nginx
     valid_referers none blocked *.martin.show server_names ~google ~baidu;
     if($invalid_referer){
     	return 403;
         #rewrite ^$ http://martin.show/403.jpg break;
     }
     ```


### 三、Nginx反向代理

- Proxy配置`ngx_http_proxy_module`
- 代理对象的不同
  - 正向代理  是为客户端作代理
  - 反向代理  是为服务器作代理

1. `Proxy_pass`

   - 语法：

     ```nginx
     Syntax:	proxy_pass URL;
     Default:	—
     Context:	location, if in location, limit_except
     ```

   - 示例

     ```nginx
     location / {
         proxy_pass http://localhost:8000;
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
     }
     ```

2. 缓冲区

   - 语法

     ```nginx
     Syntax:	proxy_buffering on | off;
     Default:	
     proxy_buffering on;
     Context:	http, server, location
     ```

     `proxy_buffering`开启的情况下，nginx会把后端返回的内容先放到缓冲区中，然后再退回给客户端，（边收边传，不是全部接受完再传给客户端）

     ```nginx
     Syntax:	proxy_buffer_size size;
     Default:	
     proxy_buffer_size 4k|8k;
     Context:	http, server, location
     ```

   - 示例

     ```nginx
     location / {
         proxy_pass http://localhost:8000;
         proxy_redirect default;
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         
         proxy_connect_timeout 30;
         proxy_send_timeout 60;
         proxy_read_timeout 60;
         
         proxy_buffering on;
         proxy_buffer_size 32k;
         proxy_buffers 4 128k;
         proxy_busy_buffers_size 256k;
         proxy_max_temp_file_size 256k;
     }
     ```

3. 缓存

   - 缓存类型
     - 服务器缓存  memcache redis
     - proxy缓存
     - 客户端缓存 浏览器缓存

   - 语法

     ```nginx
     Syntax:	proxy_cache_path path [levels=levels] [use_temp_path=on|off] keys_zone=name:size [inactive=time] [max_size=size] [manager_files=number] [manager_sleep=time] [manager_threshold=time] [loader_files=number] [loader_sleep=time] [loader_threshold=time] [purger=on|off] [purger_files=number] [purger_sleep=time] [purger_threshold=time];
     Default:	—
     Context:	http
     ```

     示例：`proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=one:10m;`

     ```nginx
     # 缓存过期
     Syntax:	proxy_cache_valid [code ...] time;
     Default:	—
     Context:	http, server, location
     # 示例
     proxy_cache_valid 200 302 10m;
     proxy_cache_valid 404      1m;
     ```

     ```nginx
     Syntax:	proxy_cache_key string;
     Default:	
     proxy_cache_key $scheme$proxy_host$request_uri;
     Context:	http, server, location
     ```

   - 示例

     ```nginx
     proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=proxy_cacha:10m max_size=10g inactive=60m use_temp_path=off;
     
     location / {
         proxy_cache proxy_cache;
         proxy_pass http://192.168.1.129:8080;
         proxy_cache_valid 200 304 12h; #当返回200/304的时候缓存10h
         proxy_cache_valid any 10m;
         proxy_cache_key $host$uri$is_args$args;
         add_header Nginx-Cache "$upstream_cache_status";
         
         proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
         proxy_redirect default;
         proxy_set_header Host $host;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         
         proxy_connect_timeout 30;
         proxy_send_timeout 60;
         proxy_read_timeout 60;
         
         proxy_buffering on;
         proxy_buffer_size 32k;
         proxy_buffers 4 128k;
         proxy_busy_buffers_size 256k;
         proxy_max_temp_file_size 256k;
     }
     
     ```



### 四、`Nginx PHP`部署 `LNMP`

1. 安装`php-fpm`

   `yum -y install php-fpm php-mysql php-gd`

   `systemctl start php-fpm`

   `systemctl enable php-fpm`

   - `php-fpm`配置文件：影响php处理php程序的性能，例如php进程数，最大连接数配置等(运维人员关注)
   - `php.ini`：影响php代码，例如允许客户端最大上传的文件的大小，设置的timezone，php所支持的扩展功能，例如是否可以连接Mysql，memcache，(程序员关注)

2. 修改nginx配置文件

   `vim /etc/nginx/conf.d/default.conf`

   ```nginx
       location ~ \.php$ {
           root           /usr/share/nginx/html;
           fastcgi_pass   127.0.0.1:9000;
           fastcgi_index  index.php;
           fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
           include        fastcgi_params;
       }
   
   ```

   重启`nginx`

3. `php`连接`nginx`方式二：使用socket

   `vim /etc/php-fpm.conf`

   ```php
   listen = /run/php-fpm.sock
   listen.owner = nginx
   listen.group = nginx
   listen.mode = 0660
       
   修改localtion文件
   fastcgi_pass unix:/run/php-fpm.sock
   ```

4. `php-fpm`配置

   1. `fpm`配置

      `/etc/php-fpm.conf`

      `/etc/php-fpm.d/www.conf`

      ```ini
      pm = dynamic
      pm.start_servers = 32 #初始启动进程数
      pm.max_children = 512  #最大子进程数
      pm.min_spare_servers = 32
      pm.max_spare_servers = 64
      pm.max_requests = 1500
      ```

   2. 全局配置

   3. 进程池配置

   4. `php`状态功能

      `vim /etc/php-fpm.conf`

      添加`pm.status_path=/php_status`

      添加location配置

      ```nginx
      location  = /php_status {
          fastcgi_pass 127.0.0.1:9000;
          fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
          include fastcgi_params;
      }
      ```

      ```shell
      [root@nginx01 ~]# curl http://192.168.1.129/php_status
      pool:                 www
      process manager:      dynamic
      start time:           11/Dec/2019:16:48:21 +0800
      start since:          31
      accepted conn:        5
      listen queue:         0
      max listen queue:     0
      listen queue len:     128
      idle processes:       4
      active processes:     1
      total processes:      5
      max active processes: 2
      max children reached: 0
      slow requests:        0
      ```

   
### 五、`Nginx Location`

1. 语法规则：

   `localtion [=|~|~*|!~|!~*|^~] /uri/{ ... }`

   - =  表示精确匹配，优先级也是最高的
   - ^~  表示uri以某个常规字符串开头，理解为匹配uri路径即可
   - ~  表示区分大小写的正则匹配
   - ~* 表示不区分大小写的正则匹配
   - !~  表示区分大小写不匹配的正则
   - !~* 表示不区分大小写不匹配的正则
   - /   通用匹配，任何请求都会匹配到 

2. `Location`优先级

   `= > ^~ > ~|~*|!~|!~* > /"`

### 六、`URL Rewrite`

1. 什么是`Rewrite`

   `URL Rewirte`，就是把传入的Web请求重定向到其它URL的过程

   - `URL Rewrite`最常见的应用就是URL伪静态化
   - 从安全角度，URL中不能暴露太多的参数，防止信息泄露
   - 实现网址跳转

2. `Rewrite`相关指令

   `Nginx Rewrite`相关指令有`if,rewrite,set,return`

   if语句

   - 应用环境：`server,location`

   语法：

   - `if (condition){...}`

   if可支持如下条件判断的匹配符号

   - ~     正则匹配  区分大小写
   - ~*    正则匹配   不区分大小写
   - !~    正则不匹配
   - !~*   正则不匹配
   - -f 和 !-f    判断是否存在文件
   - -d 和  !-d   判断是否存在目录
   - -e 和 !-e    判断是否存在文件或目录
   - -x 和 !-x    判断文件四会否可执行

   在匹配过程中可以引用一些Nginx的全局变量

   - `$args`
   - `$document_root`
   - `host`
   - `remote_addr`
   - `request_filename`
   - `request_uri`
   - `server_name`

3. `Rewrite flag`

   `rewrite`指令根据表达式来重定向URI，或者修改字符串，可以应用与`server,location,if`环境下，每行`rewrite`指令最后跟一个flag标记，支持的`flag`标记有

   - `last`    相当于Apache中的[L]标记，表示完成rewrite
   - `break`   本条规则匹配完成后，终止匹配，不再匹配后边的规则
   - `redirect`  返回302临时重定向，浏览器地址会显示跳转后的URL地址
   - `permanent`   返回301永久重定向，浏览器地址会显示跳转后的URL地址（推荐使用）

4. 