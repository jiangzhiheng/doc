一、`Openstack`中的`MQ`

1. 概念

   服务内组件之间的消息全部通过`MQ`来进行转发，包括控制，查询，监控指标等

2. `Rabbit`中的基本概念

   - `Exchange`：消息交换机，它指定消息按照什么规则，路由到哪个队列

   - `Queue`：消息队列载体，每个消息都会被投入到一个或多个队列

   - `Binding`：绑定，它的作用就是把`exchange`和`queue`按照路由规则绑定起来

   - `Routing Key`：路由关键字，`exchange`根据这个关键字进行消息投递

   - `Producer`
   - `Consumer`
   - `Vhost`

二、`Glance`组件

1. `Glance`在`Openstack`中主要为实例创建提供公共镜像/虚拟机快照管理功能

2. `Glance`用来作为独立的大规模镜像查找服务，与`Nova`和`Swift`配合使用时，为`Openstack`提供虚拟机镜像的查找服务

3. `Glance`镜像管理

   - 基于`Restful API`的访问
   - 虚拟机镜像存储与取回服务
   - 兼容所有常见镜像格式
   - 支持多种底层存储`Swift,S3,Http,本地存储`

4. `Glance`结构

   - `Web Portal/Command Line Interface`

   - `Glance api`
   - `Glance-registry`
   - `Glance Database------>Storage`
   - `Glance-replication` ：多服务，多数据中心复制

5. 修改`glance`后端存储

   `vim /etc/glance/glance-api.conf`

6. `Glance`缓存机制

7. `Glance`镜像存储位置分析

   - 镜像存储在`Glance`上
     - 具体位置在`Glance`节点的`/var/lib/glance/images`下
     - 可通过`select  * from glance.image_locations where image_id='image-id'`
   - 镜像存储在后端存储上
     - 对接块存储，可以对接`Cinder`使用其提供的块存储服务
     - 对接`swift`或者`ceph`使用其提供的对象存储服务
   - 对接后端存储
     - 需要安装对应存储的客户端程序
     - 在`glance-api.conf`文件中进行对接的存储配置

8. 镜像格式介绍

   - `raw`-非结构化的镜像格式，裸设备
   - `vhd`-一种通用的虚拟机磁盘格式，可用于`vmware,xen,MS Hyper-v,Virtual-Box`
   - `vmdk`-`VMWare`的虚拟机磁盘格式
   - `vdi`-`VirtualBox,QEMU`等支持的虚拟机磁盘格式
   - `iso`-光盘存档格式
   - `qcow2`-一种支持`QEMU`并且可动态扩展的磁盘格式
   - `aki`- `Amazon Kernal`镜像
   - `ari`- `Amazon Ramdisk`镜像
   - `ami`- `Amazon`虚拟机镜像
   - `ovf`- 开放式虚拟机磁盘格式

三、`Swift`组件

1. `swift`是什么
   - 高可用，分布式对象存储服务
   - 最终一致性模型
   - 适合解决互联网应用常见下非结构化数据存储问题
   - 构筑在比较便宜的标准硬件存储基础设施之上
   
2. 分布式存储
   - `ceph`
   - `glusterFS`
   
3. 基础概念

   - `DHT`:`Dirstributed Hash Table`, `FushionStorage`中指数据路由算法
   - `Partition`:代表了一块数据分区，`DHT`环上的固定hash段代表的数据区
   - `Key-Value`:底层磁盘上的数据组织成`key-value`的形式，每个`value`代表一个块存储空间

4. `Swift`存储虚拟化-对象存储

   - 基于`Rest API`，友好的服务访问方式
   - 数据在整个系统中均匀分布，高可靠性，资源高效利用
   - 硬件无关，支持多种标准硬件，无需定制专门的硬件设备
   - 易于扩展
   - 没有中央数据库，没有单点性能瓶颈或单点失败的隐患
   - `Account/Container/Object`三级存储结构均无需文件系统，且均有N>=3份拷贝，数据高可靠性

5. 数据一致性模型

   - N：数据的副本总数，W：写操作被确认接受的副本数量，R：读操作的副本数量
   - 强一致性：R+W>N，以保证对副本的读写操作会产生交集，从而可以读取到最新版本
   - 若一致性：R+W<=N，如果读写操作的副本集合不产生交集，就可能会读到脏数据，适合对一致性要求较低的场景。

6. 数据模型

   - 层次数据模型，共设三层逻辑结构，`Account/Container/Object`（即账户，容器，对象）
   - 每层节点数均没有限制，可以任意扩展

7. `Swift`组件

   - `Replicator`：检测本地分区副本和远程副本是否一致，发现不一致会Push更新远程副本
   - `Updater`：当对象由于高负载的原因而无法立即更新时，任务将会被序列化到本地文件系统中进行排队，以便服务恢复后进行异步更新。
   - `Auditor`：检查对象，容器和账户的完整性，如果发现比特级的错误，文件将被隔离，并赋值其它的副本以覆盖本地损坏的副本，其他类型的错误会被记录到日志中
   - `Account Reaper`：移除被标记为删除的账户，删除其所包含的所有容器和对象

8. `Swift`命令

   - `swift upload <container> <file>`
   - `swift download <container> <file>`
   - `swift stat`
   - `swift-get-nodes` 获取对象的`partiton`信息
   - `swift-object-info`  从.data文件获取账户/容器/对象信息
   - `swift list`

9. 实验：

   将glance镜像服务的后端存储修改为swift

   `[root@openstack01 ~(keystone_admin)]# cp /etc/glance/glance-api.conf /etc//glance/glance-api.conf.bak`

   `[root@openstack01 ~(keystone_admin)]# vim /etc/glance/glance-api.conf`

   ```shell
   stores=glance.store.swift.Store,glance.store.http.Store
   #新版是default_store=file=swift
   swift_store_auth_address=http://172.16.100.10:5000/v3
   swift_store_user=services:swift #?
   swift_store_key=XXXXXXXX  #参考answer.txt安装应答文件中的设置
   swift_store_container=IT
   ```

   重启glance服务

   ```shell
   service openstack-glance-api restart
   service openstack-glance-registry restart
   ```

10. 