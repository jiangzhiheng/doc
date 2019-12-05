一、概述

1. 概述

   ElasticSearch是一个基于Lucene的搜索服务器，它提供了一个分布式多用户能力的全文搜索引擎，基于RESTful web接口。ES是用Java开发的，并作为Apache许可条款下的开放源码发布。

2. ES的基本概念

   - index  -----(可以理解为mysql中的database)
   - type  ------(可以理解为table)
   - Document
   - Mapping
   - indexed
   - Query DSL  -------(类似于sql查询语言)
   - GET/PUT/DELETE/POST

3. Restful API

   一种软件架构风格，设计风格，而不是标准，知识提供了一组设计原则和约束条件，它主要用于客户端和服务器交互类的软件，基于这个风格设计的软件可以更简洁，更有层次，更易于实现缓存等机制

   `(Representational State Transfer)` 表述性状态转移

   它使用典型的HTTP方法，诸如GET，POST，DELETE，PUT来实现资源的获取，添加，修改，删除等操作，即通过HTTP动词来实现资源的状态扭转，复制代码

   - GET 用来获取资源
   - POST 用来新建资源(也可用来更新资源)
   - PUT 用来更新资源
   - DELETE  用来删除资源

4. CURL命令

   以命令的方式执行HTTP协议的请求GET/PUT/DELETE/POST

   显示响应的头信息

   `curl -i www.baidu.com`

   显示一次HTTP请求的通信过程

   `curl -v www.baidu.com`

   执行GET/PUT/DELETE/POST操作

   `curl -X GET/PUT/DELETE/POST url`

二、安装`ES6.2.4`

1. 创建用户和组(ES默认不允许root启动)

   ```shell
   groupadd esadmin
   useradd -g esadmin esadmin
   echo "123456" |passwd --stdin esadmin
   ```

2. 配置`jdk8`

   ```shell
   su - esadmin
   mkdir /home/esadmin/app
   cd /home/esadmin/app
   tar xf jdk-8u60-linux-x64.tar.gz
   mv jdk1.8.0_60 jdk8
   vim /home/esadmin/.bash_profile
   #添加以下三行
   export JAVA_HOME=/home/esadmin/app/jdk8
   export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
   export CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar
   #生效环境变量
   source /home/esadmin/.bash_profile
   
   ```

3. 修改系统参数

   ```shell
   > /etc/security/limits.conf
   cat >> /etc/security/limits.conf <<EOF
   esadmin soft nproc 65536
   esadmin hard nporc 65536
   esadmin soft nofile 65536
   esadmin hard nofile 65536
   EOF
   sed -ri '/^\*/c\esadmin soft nproc  4096' /etc/security/limits.d/20-nproc.conf
   echo "vm.max_map_count=655350" >> /etc/sysctl.conf
   sysctl -p
   ```

4. 下载`elasticsearch`安装包

   `https://www.elastic.co/guide/en/elasticsearch/reference/index.html`

   `curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.4.tar.gz`

   `chown -R esadmin:esadmin elasticsearch`

5. 解压并配置远程访问

   ```
   cd /home/esadmin/app/elasticsearch
   config/elasticsearch.yml配置：network.host:192.168.1.130
   ```

6. 启动`elasticsearch`

   `nohup ./bin/elasticsearch >>startup_server.log &`

   ```shell
   #!/bin/bash
   #
   if [ "$USER" != "esadmin"  ];then
           echo "nohup /home/esadmin/app/elasticsearch/bin/elasticsearch >>startup_server.log &"|su - esadmin &>/dev/null
   fi
   echo "Startup ES Services....."
   while true
   do
           lsof -i:9200 &> /dev/null
           if [ $? -eq 0 ];then
                   echo "ElasticSearch is Running"
                   break
           fi
           sleep 1
   done
   ```

   浏览器访问测试：`http://192.168.1.130:9200/`

   出现以下则为安装成功

   ```json
   {
     "name" : "p7B5re0",
     "cluster_name" : "elasticsearch",
     "cluster_uuid" : "PojpOfBrR_qhub3yFak0lg",
     "version" : {
       "number" : "6.2.4",
       "build_hash" : "ccec39f",
       "build_date" : "2018-04-12T20:37:28.497551Z",
       "build_snapshot" : false,
       "lucene_version" : "7.2.1",
       "minimum_wire_compatibility_version" : "5.6.0",
       "minimum_index_compatibility_version" : "5.0.0"
     },
     "tagline" : "You Know, for Search"
   }
   ```

   

7. 安装Head插件

   Head是ES的集群管理工具，可以用于数据的浏览和查询

   - `elasticsearch-head`是一款开源软件，托管在github上面
   - 运行`elasticsearch-head`会用到grunt，而grunt需要npm包管理器，所以需要安装nodejs
   - es5之后，`elasticsearch-head`不作为插件放在其plugin目录了，使用git拷贝到本地

   安装步骤：

   1. 准备工作

      ```shell
      yum -y install git
      yum -y install wget
      mkdir /root/app
      cd /root/app
      wget https://nodejs.org/dist/v9.3.0/node-v9.3.0-linux-x64.tar.xz
      tar -xf node-v9.3.0-linux-x64.tar.xz
      # 以下两条root执行
      ln -s /home/esadmin/app/node-v9.3.0-linux-x64/bin/npm /usr/local/bin/
      ln -s /home/esadmin/app/node-v9.3.0-linux-x64/bin/node /usr/local/bin/
      ```

   2. 获取安装包

      ```shell
      cd /root/app
      git clone git://github.com/mobz/elasticsearch-head.git
      ```

   3. 获取`elasticsearch-head`依赖包

      `npm install -g grunt-cli`

      `npm install cnpm -g --registry=https://registry.npm.taobao.org`

      `cd /home/esadmin/app/elasticsearch-head`

      `cnpm install`

   4. 修改Gruntfile.js

      `connect--server-options下面添加`：`hostname:'*',` 允许所有IP访问

   5. 修改ES默认链接地址`/root/app/elasticsearch-head/_site/app.js`

      `this.base_uri = this.config.base_uri || this.prefs.get("app-base_uri") || "http://192.168.1.130:9200";`

   6. 配置`elasticsearch`允许跨域访问

      `vim /home/esadmin/app/elasticsearch/config/elasticsearch.yml`

      ```
      http.cors.enabled: true
      http.cors.allow-origin: '*'
      ```

   7. 打开9100端口

      防火墙配置

   8. 启动ES

   9. 启动elasticsearch-head

      ```shell
      #!/bin/bash
      #
      if [ "$USER" != "esadmin"  ];then
              echo "nohup /home/esadmin/app/elasticsearch/bin/elasticsearch >>startup_server.log &"|su - esadmin &>/dev/null
      fi
      echo "Startup ES Services....."
      while true
      do
              lsof -i:9200 &> /dev/null
              if [ $? -eq 0 ];then
                      echo "ElasticSearch is Running"
                      break
              fi
              sleep 1
      done
      
      echo "Startup elasticsearch-head Services....."
      cd /root/app/elasticsearch-head/node_modules/grunt/bin
      ./grunt server  & &>/dev/null
      while true
      do
              lsof -i:9100 &> /dev/null
              if [ $? -eq 0 ];then
                      echo "ElasticSearch-Head is Running"
                      echo "Started connect web server on http://192.168.1.130:9100"
                      break
              fi
              sleep 1
      done
      ```

8. 

