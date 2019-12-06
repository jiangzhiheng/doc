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

6. 