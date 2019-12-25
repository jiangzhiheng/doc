使用packstack工具快速部署openstack

环境：Centos7

1. 安装packstack工具

   `yum install -y http://rdo.fedorapeople.org/rdo-release.rpm`

   `yum install  openstack-packstack`

   生成应答文件

   `packstack --gen-answer-file=answer.conf`

2. 修改应答文件中的配置

   ```
   CONFIG_NTP_SERVERS=172.16.100.10
   CONFIG_KEYSTONE_ADMIN_PW=admin
   CONFIG_HORIZON_SSL=y
   CONFIG_PROVISION_DEMO=n
   CONFIG_COMPUTE_HOSTS=172.16.100.10,172.16.100.11
   CONFIG_MARIADB_PW=admin   #mysql密码
   ```

3. 依据应答文件部署openstack（控制节点）

   `packstack --answer-file=answer.conf`

4. 配置桥接网卡(所有节点都需要设置)

   - 修改ens33网卡配置

     ```
     DEVICE=ens33
     BOOTPROTO=static
     ONBOOT=yes
     DEVICETYPE=ovs
     TYPE=OVSPort
     OVS_BRIDGE=br-ex
     ```

   - 编辑br-ex桥接网卡配置文件

     `vim ifcfg-br-ex`

     ```
     DEVICE=br-ex
     BOOTPROTO=static
     ONBOOT=yes
     TYPE=OVSBridge
     DEVICETYPE=ovs
     IPV6INIT=no
     IPADDR=
     NETMASK=
     GATEWAY=
     DNS1=
     
     ```

5. 