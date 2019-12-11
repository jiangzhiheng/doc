1. etcd简介

   etcd是一个开源的，分布式的键值对数据存储系统，用于存储key-value键值对，同时它不仅仅是存储，它主要用途是提供共享配置及服务发现(主要用于container中)，对于leader的选举非常优秀，它的leader选举更换对于前端是无感知的。

   应用容器读写数据在etcd上，除此还有支持快照及查看历史事件的功能。

   数据模型：一个持久的，多版本的并发控制数据模型，

   Tips：etcd适用于较小的元数据键值对的处理，最大支持1M数据的RPC请求。

2. etcd主要功能介绍

   - 键值写入与读取
   - 过期时间
   - 观察者
   - 租约
   - 集群管理相关操作
   - 维护操作
   - 用户及权限管理

3. etcd安装与配置

   - 系统要求

   - 硬件要求

   - 安装步骤

     1. 下载安装包

        ``wget https://github.com/coreos/etcd/releases/download/v3.2.18/etcd-v3.2.18-linux-amd64.tar.gz``

     2. 解压到安装目录

        `tar xf etcd-v3.3.10-linux-amd64.tar.gz`

   - 配置

     配置为v3版本，系统默认的是v2，通过以下命令修改配置

     `vim /etc/profile`

     在末尾追加

     `export ETCDCTL_API=3`

     `source  /etc/profile`

     1. 配置节点

     2. 创建节点配置文件(单节点安装，集群安装请参考k8s手动安装笔记)

        `mkdir /etc/etcd`

        `vim /etc/etcd/conf.yml`

        ```yaml
        name: etcd-1
        data-dir: /opt/etcd/data
        listen-client-urls: http://192.168.1.129:2379,http://127.0.0.1:2379
        advertise-client-urls: http://192.168.1.129:2379,http://127.0.0.1:2379
        listen-peer-urls: http://192.168.1.129:2380
        initial-advertise-peer-urls: http://192.168.1.129:2380
        initial-cluster: etcd-1=http://192.168.1.129:2380
        initial-cluster-token: etcd-cluster-token
        initial-cluster-state: new
        ```

        查看版本号

        `./etcdctl version`

        查看集群成员

        `./etcdctl member list`

        查看集群状态
   
        `./etcdctl --write-out=table endpoint status`
   
        查看leader状态
     
        `curl http://127.0.0.1:2379/v2/stats/leader`
     
        查看自己的状态
     
        `curl http://127.0.0.1:2379/v2/stats/self`
     
     3. 启动etcd
     
     `./etcd --config-file=/etc/etcd/conf.yml`
     
        添加至系统服务
     
        `vim /etc/systemd/system/etcd.service`
     
        ```shell
     [Unit]
        Description=Etcd Server
     After=network.target
        [Service]
        Type=simple
        WorkingDirectory=/root/app/etcd
        EnvironmentFile=-/etc/etcd/conf.yml
        #set GOMAXPROCS to number of processors
        ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /root/app/etcd/etcd"
        Type=notify
        [Install]
        WantedBy=multi-user.target
        ```
     
   

4. etcd主要命令介绍

   - 键值写入与读取

     ```shell
     etcdctl put /message hello
     etcdctl get /message
     etcdctl get /mess --prefix   #模糊匹配
     etcdctl del /message
     #获取key列表(v2版本使用，当前v3不适用)
     curl http://127.0.0.1:2379/v2/keys
     ```

   - 过期时间

   - 观察者

     ```shell
     curl http://127.0.0.1:2379/v2/keys/foo?wait=true
     #也可以指定等待的index，这个index是node属性中的modifiedIndex
     curl http://127.0.0.1:2379/v2/keys/foo?wait=true&waitIndex=14   #第14次修改时触发
     在另一个终端执行：
     curl http://127.0.0.1:2379/v2/keys/foo -XPUT -d value=bar
     ```

   - 原子操作

     ```shell
     #当条件成立时设置key值
     curl http://127.0.0.1:2379/v2/keys/foo?prevExist=false -XPUT -d value=three
     #支持的判断条件有：prevValue，prevIndex,prevExist
     
     #当条件成立时删除key值
     curl http://127.0.0.1:2379/v2/keys/foo?prevValue=two -XDELETE
     #支持的判断条件有：prevValue，prevIndex
     ```

5. etcd新特性之租约

   什么叫lease？其实就是etcd支持申请定时器，比如：可以申请一个TTL=10s的lease（租约），会返回给你一个lease ID标识定时器，你可以在put一个key 的同时携带lease ID，那么就实现了一个自动过期的key。在etcd中，一个lease可以关联给任意多的key，当lease过期后所有关联的key都将被自动删除。

   ```shell
   #生成
   [root@nginx01 ~]# etcdctl lease grant 300
   lease 694d6eefe8072f17 granted with TTL(300s)
   #关联租约到key
   [root@nginx01 ~]# etcdctl put test_lease 300 --lease=694d6eefe8072f17
   #维持租约
   [root@nginx01 ~]# etcdctl lease keep-alive 694d6eefe8072f17
   lease 694d6eefe8072f17 keepalived with TTL(300)
   #撤销租约
   etcdctl lease revoke 694d6eefe8072f17
   ```

6. 高级特性

   - 原子操作
   - 事务
   - 分布式锁
   - 选举