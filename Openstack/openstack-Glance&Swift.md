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
3. 