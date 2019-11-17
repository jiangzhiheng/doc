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

   - yum install kernel-devel

   第一阶段：实现网络手动安装

   - 部署环境：Centos7
   - 项目目标：安装服务器提供Centos6和Centos7系统的安装

   预备工作：

   systemctl stop firewalld

   systemctl disable firewalld

   sed -ri '/^SELINUX/c\SELINUX=disabled' /etc/selinux/config

   setenforce 0

   1. 软件包安装

      yum -y install dhcp tftp-server vsftpd xinetd syslinux

      mkdir /var/ftp/centos7

      mkdir /var/ftp/centos6

      mount /dev/cdrom /var/ftp/centos7/

      mount -o loop /tmp/centos6.iso /var/ftp/centos6

      systemctl start vsftpd

      systemctl enable vsftpd

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

      systemctl start dhcpd

      systemctl enable dhcpd

   3. tftp-server配置

      - 初始启动文件

        `cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/`

        启动tftp-server

        vim /etc/xinetd.d/tftp   修改disable   =   no

        systemctl restart xinetd

        systemctl enable xinetd

        ss -utnlp |grep 69

      - 提供引导菜单所需的文件

        cp -rf /var/ftp/centos7/isolinux/* /var/lib/tftpboot/

        cd /var/lib/tftpboot/

        mkdir pxelinux.cfg

        cp isolinux.cfg pxelinux.cfg/default

        vim  pxelinux.cfg/default

        ```shell
        label linux
          menu label ^Install CentOS 7
          kernel vmlinuz
          append initrd=initrd.img inst.stage2=ftp://192.168.1.128/centos7 inst.repo=ftp://192.168.1.128/centos7
        ```

        systemctl restart xinetd

   4. 如果希望提供多系统安装

      - 为每个系统准备/var/lib/tftp/centosX/{vmlinuz,initrd}

      - 为每个系统准备引导菜单/var/lib/tftp/pxelinux.cfg/default

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

      yum -y install system-config-kickstart

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

      ```shell
      label linux
        menu label ^Install CentOS 7
        kernel vmlinuz
        append initrd=initrd.img inst.stage2=ftp://192.168.1.128/centos7 inst.repo=ftp://192.168.1.128/centos7 inst.ks=ftp://192.168.1.128/centos7.ks
      
      ```

二、Cobbler工具

