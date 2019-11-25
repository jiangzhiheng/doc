一、PXE技术

1. PXE概述

   PXE(preboot execute environment 预启动执行环境)

   DHCP server：提供 IP PXE参数(去哪个TFTP server下载哪个启动文件)

   TFTP server：提供启动映像文件

   FTP server：安装树 install tree

   - 安装树可以使用Http，Ftp，Nfs

   PXE Client：（需要安装系统的物理主机）

2. 安装步骤

   Vmware环境

   - `yum install kernel-devel`

   第一阶段：实现网络手动安装

   - 部署环境：Centos7
   - 项目目标：安装服务器提供Centos6和Centos7系统的安装

   预备工作：

   `systemctl stop firewalld`

   `systemctl disable firewalld`

   `sed -ri '/^SELINUX/c\SELINUX=disabled' /etc/selinux/config`

   `setenforce 0`

   1. 软件包安装

      `yum -y install dhcp tftp-server vsftpd xinetd syslinux`

      `mkdir /var/ftp/centos7`

      `mkdir /var/ftp/centos6`

      `mount /dev/cdrom /var/ftp/centos7/`

      `mount -o loop /tmp/centos6.iso /var/ftp/centos6`

      `systemctl start vsftpd`

      `systemctl enable vsftpd`

   2. DHCP配置

      `vim /etc/dhcp/dhcpd.conf`

      ```shell
      subnet 192.168.1.0  netmask 255.255.255.0 {
        range 192.168.1.150 192.168.1.160;
        next-server 192.168.1.128;  #tftp-server IP
        filename "pxelinux.0";  # 指向的是tftp-server的根目录/var/lib/tftpboot
      }
      ```

      `dhcpd`命令检查语法错误

      `systemctl start dhcpd`

      `systemctl enable dhcpd`

   3. tftp-server配置

      - 初始启动文件

        `cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/`

        启动tftp-server

        `vim /etc/xinetd.d/tftp   修改disable   =   no`

        `systemctl restart xinetd`

        `systemctl enable xinetd`

        `ss -utnlp |grep 69`

      - 提供引导菜单所需的文件

        `cp -rf /var/ftp/centos7/isolinux/* /var/lib/tftpboot/`

        `cd /var/lib/tftpboot/`

        `mkdir pxelinux.cfg`

        `cp isolinux.cfg pxelinux.cfg/default`

        `vim  pxelinux.cfg/default`

        ```shell
        label linux
          menu label ^Install CentOS 7
          kernel vmlinuz
          append initrd=initrd.img inst.stage2=ftp://192.168.1.128/centos7 inst.repo=ftp://192.168.1.128/centos7
        ```

        `systemctl restart xinetd`

   4. 如果希望提供多系统安装

      - 为每个系统准备`/var/lib/tftp/centosX/{vmlinuz,initrd}`

      - 为每个系统准备引导菜单`/var/lib/tftp/pxelinux.cfg/default`

      - 为每个系统准备安装树

        ```shell
        [root@martin tftpboot]# mkdir centos7
        [root@martin tftpboot]# mkdir centos6
        [root@martin tftpboot]# ls centos7/
        initrd.img  vmlinuz
        [root@martin tftpboot]# ls centos6/
        initrd.img  vmlinuz
        [root@martin tftpboot]# vim pxelinux.cfg/default
        ```

        ```shell
        label centos6
          menu label ^Install CentOS 6
          menu default
          kernel centos6/vmlinuz
          append initrd=centos6/initrd.img inst.stage2=ftp://192.168.1.128/centos6 inst.repo=ftp://192.168.1.128/centos6
        label centos7
          menu label ^Install CentOS 7
          kernel centos7/vmlinuz
          append initrd=centos7/initrd.img inst.stage2=ftp://192.168.1.128/centos7 inst.repo=ftp://192.168.1.128/centos7
        ```

3. kickstart实现自动安装

   1. KickStart文件简介

      即把整个安装过程中要回答或做的事全部体现在应答文件中

      - Kickstart安装选项：包含语言，防火墙，密码，网络，分区的设置等
      - %Pre部分：安装前解析的脚本，通常用来生成特殊的ks配置，比如由一段程序决定分区配置等
      - %Package部分：安装包的选择，可以是@base这样的组合形式，也可是http-*包这样的形式
      - %Post部分：安装后执行的脚本，通常用来做系统的初始化配置，比如启动的服务，相关的设定等

   2. 创建ks文件，并共享

      `yum -y install system-config-kickstart`

      使用`system-config-kickstart`命令生成合适的ks文件

      ```shell
      # Kickstart Configurator for CentOS 7  #命令段
      install   #告知安装程序，这是一次全新安装，而不是升级
      url --url="ftp://192.168.1.128/centos7/"  #通过http下载安装镜像
      text     #以文本格式安装
      lang en_US.UTF-8   #设置字符集格式
      keyboard us  #设置键盘类型
      skipx
      zerombr   #清除mbr引导
      bootloader --location=mbr --driveorder=sda --append="net.ifnames=0 biosdevname=0 crashkernel=auto rhgb quiet"    #指定引导记录被写入的位置
      network  --bootproto=static --device=eth0 --gateway=10.0.0.254 --ip=10.0.0.202 --nameserver=223.5.5.5 --netmask=255.255.255.0 --activate  #配置eth0网卡
      #network  --bootproto=static --device=eth1 --ip=172.16.1.202 --netmask=255.255.255.0 --activate   #配置eth1网卡
      #network  --hostname=localhost  #设置主机名
      #network --bootproto=dhcp --device=eth1 --onboot=yes --noipv6 --hostname=CentOS7
      timezone --utc Asia/Shanghai  #可以使用dhcp方式设置网络
      authconfig --enableshadow --passalgo=sha512  #设置密码格式
      rootpw  --iscrypted $6$P0RRkp7l/Eob0EFj$8rbLxL.DRkIviA7g6be88llbY80LAXVd4w8rIm5eVU32CdLQVTAYL0jm1zrscxnrChdKUgi41qVXicuVAipTv0
      clearpart --all --initlabel  #清空分区
      part /boot --fstype xfs --size 1024   #/boot分区
      part swap --size 1024                    #swap分区
      part / --fstype xfs --size 1 --grow   #/分区
      firstboot --disable       #负责协助配置redhat一些重要的信息
      selinux --disabled        #关闭selinux
      firewall --disabled       #关闭防火墙
      logging --level=info      #设置日志级别
      reboot                       #安装完成重启
      
      %packages #包组段   @表示包组
      @^minimal
      @compat-libraries
      @debugging
      @development
      tree
      nmap
      sysstat
      lrzsz
      dos2unix
      telnet
      wget
      vim
      bash-completion
      %end
      
      %post #脚本段，可以放脚本或命令
      systemctl disable postfix.service   #关闭邮件服务开机自启动
      
      %end
      ```

   3. 配置ks文件到default文件中

      cp centos7.ks /var/ftp/

      Tisps：注意ks文件权限为644
      
      ```shell
      label linux
        menu label ^Install CentOS 7
        kernel vmlinuz
        append initrd=initrd.img inst.stage2=ftp://192.168.1.128/centos7 inst.repo=ftp://192.168.1.128/centos7 inst.ks=ftp://192.168.1.128/centos7.ks
      
      ```

二、Cobbler工具

1. cobbler简介

2. cobbler部署

   1. 基础环境

      `systemctl stop firewalld`

      `systemctl disable firewalld`

      `sed -ri '/^SELINUX/c\SELINUX=disabled' /etc/selinux/config`

      `setenforce 0`

   2. cobbler安装

      `yum -y install epel-release`

      `yum -y install cobbler cobbler-web tftp-server dhcp httpd xinetd`

      `systemctl start httpd cobblerd`

      `systemctl enable httpd cobblerd`

   3. 配置cobbler

      `cobbler check`

      `sed -ri '/allow_dynamic_settings:/c\allow_dynamic_settings: 1' /etc/cobbler/settings`    #打开动态修改参数功能

      `cobbler setting edit --name=server --value=192.168.1.129`

      `cobbler setting edit --name=next_server --value=192.168.1.129`

      `sed -ri '/disable/c\disable = no' /etc/xinetd.d/tftp`

      `systemctl restart xinetd;systemctl enable xinetd`

      `cobbler get-loaders`

      `systemctl start rsyncd;systemctl enable rsyncd`

      [default password:]

      - `openssl passwd -1 -salt 'sdfasdsdce' '123456'`
      - `cobbler setting edit --name=default_password_crypted --value=$1$sdfasdsd$l7XLsXCxOTi.knw/cF11z1`

      `yum -y install fence-agents`

      [manage_dhcp:]

      - `cobbler setting edit --name=manage_dhcp --value=1`

      ` vim /etc/cobbler/dhcp.template`  #修改DHCP配置

      ```shell
      subnet 192.168.1.0 netmask 255.255.255.0 {
          # option routers             192.168.1.5;
          # option domain-name-servers 192.168.1.1;
           option subnet-mask         255.255.255.0;
           range dynamic-bootp        192.168.1.200 192.168.1.254;
           default-lease-time         21600;
           max-lease-time             43200;
           next-server                $next_server;
           class "pxeclients" {
                match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
                if option pxe-system-type = 00:02 {
                        filename "ia64/elilo.efi";
                } else if option pxe-system-type = 00:06 {
                        filename "grub/grub-x86.efi";
                } else if option pxe-system-type = 00:07 {
                        filename "grub/grub-x86_64.efi";
                } else if option pxe-system-type = 00:09 {
                        filename "grub/grub-x86_64.efi";
                } else {
                        filename "pxelinux.0";
                }
           }
      
      }
      ```

      `systemctl restart cobblerd`

      `cobbler sync`

   4. 部署centos7

      `mount /dev/cdrom /media/`

      `cobbler import --path=/media --name=centos7 --arch=x86_64`   #导入一个发行版

      `cobbler distro list`   #列出所有发行版

      `ls /var/lib/cobbler/kickstarts/`  #查看ks文件

      `vim centos7.ks`

      ```shell
      auth  --useshadow  --enablemd5
      bootloader --location=mbr
      clearpart --all --initlabel
      text
      firewall --disable
      firstboot --disable
      keyboard us
      lang en_US
      url --url=$tree
      # If any cobbler repo definitions were referenced in the kickstart profile, include them here.
      $yum_repo_stanza
      # Network information
      $SNIPPET('network_config')
      # Reboot after installation
      reboot
      
      rootpw --iscrypted $default_password_crypted
      selinux --disabled
      skipx
      timezone  Asia/ShangHai
      install
      zerombr
      autopart
      
      %pre
      $SNIPPET('log_ks_pre')
      $SNIPPET('kickstart_start')
      $SNIPPET('pre_install_network_config')
      # Enable installation monitoring
      $SNIPPET('pre_anamon')
      %end
      
      %packages
      $SNIPPET('func_install_if_enabled')
      @^minimal
      @core
      httpd
      wget
      lftp
      vim-enhanced
      bash-completion
      %end
      
      %post --nochroot
      $SNIPPET('log_ks_post_nochroot')
      %end
      
      %post
      $SNIPPET('log_ks_post')
      # Start yum configuration
      $yum_config_stanza
      # End yum configuration
      $SNIPPET('post_install_kernel_options')
      $SNIPPET('post_install_network_config')
      $SNIPPET('func_register_if_enabled')
      $SNIPPET('download_config_files')
      $SNIPPET('koan_environment')
      $SNIPPET('redhat_register')
      $SNIPPET('cobbler_register')
      # Enable post-install boot notification
      $SNIPPET('post_anamon')
      # Start final steps
      $SNIPPET('kickstart_done')
      # End final steps
      %end
      
      ```

      `cobbler profile list`  列出想要编辑的profile文件

      `cobbler profile edit --name=centos7-x86_64 --kickstart=/var/lib/cobbler/kickstarts/centos7.ks`

      `cobbler profile edit --name=centos7-x86_64 --kopts='net.ifnames=0 biosdevname=0'`

   5. 添加一个新的profile

      创建好对应的ks文件

      `cobbler profile add --name="centos7-webserver" --distro="centos7-x86_64" --kickstart="/var/lib/cobbler/kickstarts/centos7-webserver.ks" --kopts='net.ifnames=0 biosdevname=0'`

   6. 配置system段

      ```shell
      [root@cobbler cobbler]# cobbler list
      distros:
         centos7-x86_64
         redhat6u8-i386
         redhat6u8-x86_64
      
      profiles:
         centos7-webserver
         centos7-x86_64
         redhat6u8-i386
         redhat6u8-x86_64
      
      systems:
      
      repos:
      
      images:
      
      mgmtclasses:
      
      packages:
      
      files:
      
      ```

      如果希望指定的主机(预安装主机MAC)能自动的选择profile，而且设置静态IP，主机名

      示例1：

      `cobbler system add --name="web1.test.com" --profile="centos7-webserver" --interface="eth0" --mac="00:50:56:3A:FE:22"`

      示例2：(MAC匹配)

      `cobbler system add --name="web2.test.com" --profile="centos7-webserver" --interface="eth0" --mac="00:50:56:3F:8A:EF" --hostname="web02.test.com" --ip-address="10.0.0.10" --subnet="255.255.255.0" --gateway="10.0.0.1" --name-servers="8.8.8.8" --static="1" --netboot="Y"`

3. 配置web使用cobbler

   `useradd jiang`

   `echo "123456" |passwd --stdin jiang`

   `vim /etc/cobbler/modules.conf`

   `[module = authn_pam]`

   `vim /etc/cobbler/users.conf`

   `[admins]`
   `[admin = "jiang"]`

   `systemctl restart cobblerd`

   `cobbler sync`

   `https://192.168.1.129/cobbler_web`

