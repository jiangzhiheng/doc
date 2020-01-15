一、`Keystone`相关概念

1. `Keystone`对象模型
   - `Domain`：域，`Keystone`中资源（`project,user,group`）的持有者
   - `Project`：租户，其它组件中资源（虚拟机，镜像）的持有者
   - `User`：用户，云系统的使用者
   - `Group`：用户组，可以把多个用户做为一个整体进行角色管理
   - `Role`：角色，基于角色进行访问控制
   - `Trust`：委托，把自己拥有的角色临时授权给别人
   - `Service`：服务，一组相关功能的集合，比如计算服务，网络服务，存储服务等
   - `Endpoint`：必须和一个服务关联，代表这个服务的访问地址，一般一个服务需要提供三种类型的访问地址：`public,internal,admin`
2. 