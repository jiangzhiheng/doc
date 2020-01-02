一、Nova的系统架构

1. 架构图
2. Nova计算虚拟化
   - 基于`Rest API`
   - 支持大容量水平扩展
   - 硬件无关，支持多种标准硬件
   - 虚拟化平台无关，支持多种`hypervisor:KVM,LXC,QEMU,UML,ESX,XEN,PowerVM,Hypre-v`

二、虚拟机的典型操作和概念

1. Nova典型的操作

   - 虚拟机生命周期管理
   - 卷和快照操作管理
   - 虚拟机卷操作
   - 虚拟机网络操作
   - 虚拟机虚拟网卡操作
   - 虚拟机镜像的操作
   - 虚拟机HA
   - 其它资源其它操作

2. Nova中的一些概念

   | 名称              | 简介                    | 说明                                                         |
   | ----------------- | ----------------------- | ------------------------------------------------------------ |
   | `Server/Instance` | 虚拟机                  | Nova管理提供的云服务资源。Nova中最重要的数据对象             |
   | `Server metadata` | 虚拟机元数据            | 通常用于为虚拟机附加必要描述信息                             |
   | `Flavor`          | 虚拟机规格模板          |                                                              |
   | `Quota`           | 资源配额                |                                                              |
   | `Hypervisor/node` | 节点                    | 对于`kvm，xen`等虚拟化技术，一个node即对应于一个物理主机，对于`vcenter`，一个node对应于一个cluster |
   | `Host`            | 主机                    | 对于`vCenter`,一个host对应于一套`vCenter`部署                |
   | `Host aggregate`  | 主机聚合                | 一个HA内包含若干个host，一个HA内得物理主机通常具有相同的CPU型号等物理资源特性 |
   | `Server group`    | 虚拟机亲和性/反亲和性组 | 同一个亲和性组的虚拟机，在创建时会被调度到相同的物理主机上，类比反亲和性组 |
   | `service`         | Nova各个服务            | 管理nova相关服务的状态                                       |
   | `bdm`             | `Block device mapping`  | 块存储设备，用于描述虚拟机拥有的存储设备信息                 |

三、Nova各模块功能简介

1. Nova的系统架构

   |        模块        |             功能             | 部署位置 |
   | :----------------: | :--------------------------: | :------: |
   |     `nova-api`     |        接收`rest`消息        | 控制节点 |
   |  `nova-scheduler`  |         选择合适主机         | 控制节点 |
   |  `nova-conductor`  |   数据库操作和复杂流程控制   | 控制节点 |
   |   `nova-compute`   | 虚拟机生命周期管理和资源管理 | 计算节点 |
   | `nova-novncproxy`  |    `novnc`访问虚拟机代理     | 控制节点 |
   | `nova-consoleauth` |    `novnc`访问虚拟机鉴权     | 控制节点 |

2. `Nova-API`层功能

   - 对外提供rest接口的处理
   - 对传入的参数进行合法性校验和约束限制
   - 对请求的资源进行配额(quota)的检验和预留
   - 资源的创建，更新，删除查询等
   - 虚拟机生命周期 的入口
   - 可水平扩展部署

3. `Nova-api`处理流程

   - `WSGI server + Paste + WebOb`
   - `nova`所有的rest请求的入口

4. `nova-conductor`

   - 数据库操作，解耦其它组件(`nova-compute`)数据库访问
   - Nova复杂流程控制，如创建，冷迁移，热迁移，虚拟机规格调整，虚拟机重建
   - 其它组件的依赖，如`nova-compute`需要依赖`nova-conductor`启动成功后才能启动成功
   - 其它组件心跳定时写入

5. `nova-compute`

   - 虚拟机各生命周期操作的真正执行者（会调用对应的`hypervisor的driver`）
   - 底层对接不同虚拟化平台
   - 内置周期性任务，完成资源刷新，虚拟机状态同步等功能
   - 资源管理模块配合插件机制，完成资源的统计
   - `Claim`模块完成资源的分配和释放

6. `nova-novncproxy`   真实的`vnc Server`部署在计算节点上

7. `nova-consoleauth`

8. `Nova-scheduler`模块

   - `Nova-scheduler`

     - `chance(Random)`
     - `Filter_scheduler(currentused)`

   - 选择策略

     - 基于内存权重的选择

     - 散列：在候选的一个大小范围的主机中， 随机选择一个主机

   - `Filter`：对主机进行过滤的实体，支持自研扩展
- `scheduler_default_filters`配置新写的filter
     - `scheduler_available_filters`指定扩展的filter目录的收集函数。

四、Nova中的网络

五、Numa亲和性相关概念

- `numa`亲和性指的是虚拟机分享同一个`numa`上的内存，CPU资源
- `Evs`和`ionuma`亲和性指的是虚拟机在分享同一个`numa`上内存，cpu和pci资源

六、虚拟机类型和创建流程

- 相关准备：
  - Flavor：虚拟机规格
  - 网络信息：Port或者net
  - 镜像信息：glance中注册的镜像（qcow2，iso等）
  - 卷信息：需要挂载的数据卷或者启动卷
  - 其他信息（可选）
    - `schduler_hint`
    - `meta data`
    - `user data ,az,max-count,config driver,key-name等`

七、`Openstack`使用命令行操作

1. 创建`openstack`客户端环境脚本

   `vim keystonerc_admin`

   ```shell
   unset OS_SERVICE_TOKEN
       export OS_USERNAME=admin
       export OS_PASSWORD='admin'
       export OS_REGION_NAME=RegionOne
       export OS_AUTH_URL=http://172.16.100.10:5000/v3
       export PS1='[\u@\h \W(keystone_admin)]\$ '
   
   export OS_PROJECT_NAME=admin
   export OS_USER_DOMAIN_NAME=Default
   export OS_PROJECT_DOMAIN_NAME=Default
   export OS_IDENTITY_API_VERSION=3
   ```

   `vim keystonerc_user01`

   ```shell
   unset OS_SERVICE_TOKEN
       export OS_USERNAME=user01
       export OS_PASSWORD='admin'
       export OS_REGION_NAME=RegionOne
       export OS_AUTH_URL=http://172.16.100.10:5000/v3
       export PS1='[\u@\h \W(keystone_user01)]\$ '
   
   export OS_PROJECT_NAME=trustfar
   export OS_USER_DOMAIN_NAME=Default
   export OS_PROJECT_DOMAIN_NAME=Default
   export OS_IDENTITY_API_VERSION=3
   ```

2. 生效认证脚本

   `source keystonerc_admin`

   `source keystonerc_user01`

3. 常用命令

   - 创建/删除一个cinder卷(创建一块磁盘)

     `cinder list`

     `cinder snapshat-list`

     `cinder snapshot-delete`

     `[root@openstack01 ~(keystone_user01)]# cinder create --display-name vol00001 2`

     `[root@openstack01 ~(keystone_user01)]# cinder delete vol00001`

   - 虚拟机删除操作

     `[root@openstack01 ~(keystone_user01)]# nova delete VM_NAME`

   - 网络删除操作

     `neutron floatingip-list`   获取ID

     `neutron floatingip-delete ID`

     `neutron router-list`    获取router ID

     `neutron router-gateway-clear  ROUTER_ID`  #清除gateway

     `openstack subnet list`  列出所有子网

     `neutron router-interface-delete router01 c89aea82-ef34-4635-8634-5868e832eeb3` 删除接口

     删除路由：

     `openstack router list`

     `openstack router delete router01`

     删除网络(删除网络前需要删除该网络所有的子网以及interface，否则会删除失败)

     `openstack network list`

     `openstack network delete public`

     `openstack network delete private`

   - 安全组删除操作

     `openstack security group list`

     `openstack security group delete trustfar_secGroup`

   - 删除密钥对

     `openstack keypair list`

     `openstack keypair delete test01`

   - 删除镜像image

     `openstack image list`

     `openstack image delete centos7_mini`

   - 租户删除

     `openstack project list`

     `openstack project delete Myweb`

   - 用户删除

     `openstack user delete user01`

八、使用命令行创建openstack实例流程







