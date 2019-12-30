使用packstack工具快速部署openstack

环境：Centos7

`https://www.rdoproject.org/install/packstack/`

1. 准备工作

   `systemctl stop NetworkManager`

   `systemctl disable NetworkManager`

   `systemctl enable network`

   `systemctl start network`

   `yum -y install chrony`

   `> /etc/chrony.conf`

   ```
   cat > /etc/chrony.conf << EOF
   server ntp.aliyun.com iburst
   stratumweight 0
   driftfile /var/lib/chrony/drift
   rtcsync
   makestep 10 3
   bindcmdaddress 127.0.0.1
   bindcmdaddress ::1
   keyfile /etc/chrony.keys
   commandkey 1
   generatecommandkey
   logchange 0.5
   logdir /var/log/chrony
   EOF
   ```

   

2. 安装packstack工具

   `yum install -y http://rdo.fedorapeople.org/rdo-release.rpm`

   `yum install  openstack-packstack`

   生成应答文件

   `packstack --gen-answer-file=answer.conf`

3. 修改应答文件中的配置

   ```
   CONFIG_NTP_SERVERS=172.16.100.10
   CONFIG_KEYSTONE_ADMIN_PW=admin
   CONFIG_HORIZON_SSL=y
   CONFIG_PROVISION_DEMO=n
   CONFIG_COMPUTE_HOSTS=172.16.100.10,172.16.100.11
   CONFIG_MARIADB_PW=admin   #mysql密码
   ```

4. 依据应答文件部署openstack（控制节点）

   `packstack --answer-file=answer.conf`

5. 配置桥接网卡(所有节点都需要设置)

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

6. 操作演示

   - 创建租户（Project），修改quota(配额)（admin用户）
   - 创建用户，绑定一个项目，设置该用户在项目中的角色
   - 上传镜像(image)（admin用户）
   - 创建网络
     - 创建private网络(普通用户)
     - 创建子网
     - 创建public网络为外部网络(extenal)(admin用户)
     - 创建private网络端口（提供给实例使用）
     - 创建路由（关联路由到public和private网络）
   - 创建安全组(默认拒绝所有)
     - 安全组
     - 密钥对
     - 分配浮动IP
     - 创建实例
     - 分配浮动IP（弹性IP）

7. 公有云中操作

   - 创建虚拟私有云  vpc（`Virtual Private Cloud`） (相当于openstack中创建网络和子网)

   
