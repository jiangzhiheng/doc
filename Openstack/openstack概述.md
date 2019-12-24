一、概述

1. `openstack`是什么

   目前最流行的开源云操作系统内核

2. 云计算和虚拟化的区别

   - `openstack`只是系统的控制面（IT能力服务化，按需使用，按量计费，多租户隔离）
   - `openstack`不包括系统的数据面组件，如`hypervisor`，存储和网络
   - 虚拟化主要负责环境隔离，资源复用，降低隔离损耗，提升运行效率等

3. `openstack`的设计与开发基本思想

   - 开放
   - 灵活
   - 可扩展

二、开源虚拟化技术

1. `XEN`
2. `KVM`

三、`OpenStack Architecture`

1. `Horizon`

   - `OpenStack Dashboard`
     - `Provides simple self service UI for end-users`
     - `Basic cloud administrator functions`
       - `Define users,tenants and quotas`
       - `No infrastructure management`

2. `Nova`

   - `OpenStack Compute`
     - `Core compute service compirsed of`
       - `Compute Nodes - hypervisor that run virtual machines`
         - `Supports KVM,Xen,LXC,Hyper-v and ESX`
       - `Distributed controllers that handle scheduling,API calls,etc`
         - `Natice Openstack API and Amazon EC2 compatiable APIs`

3. `Glance`

   - `OpenStack Image Service`
     - `Image service`
     - `Store and retrieves disk images(virtual machine templates)`
     - `Support Raw,QCOW,VMDK,VHD,ISO,OVF & AMI/AKI`
     - `Backend storage:Filsystem ,Swift,Amazons3`

4. `Swift`

   - `Openstack Object Storage`:可以理解为类似于网盘，只能上传下载查看，但是不能修改
     - `Object Storage service`
     - `Modeled after Amazon's S3 service`
     - `Native API and s3 compatible API`

5. `Cinder`

   - `Openstack Block Storage`

     - `Block Storage(Volume) Service`

     - `Provides block storage for vitrual machines(Persistent disks)`

     - `Similar to Amazon EBS service`

     - `Plugin architecture for vender extensions`

       `eg. NetApp driver for Cinder`

6. `Neutron`

   - 

7. 