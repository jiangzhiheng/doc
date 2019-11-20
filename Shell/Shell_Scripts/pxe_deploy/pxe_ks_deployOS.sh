#!/bin/bash 
# PXE + KickStart Deploy CentOS/RedHat System
# This Scripts Exec in CentOS7
# v0.1 2019.11.19 by JiangZhiheng
#
DHCP_SERVER=192.168.1.130
DHCP_RANGE="192.168.1.150 192.168.1.160"
DHCP_SUBNET=192.168.1.0
TFTP_SERVER=192.168.1.130
FTP_SERVER=192.168.1.130
#
# Close firewall & Selinux
systemctl stop firewalld
systemctl disable firewalld
sed -ri '/^SELINUX/c\SELINUX=disabled' /etc/selinux/config
setenforce 0
#
# Configure YUM source
cd /etc/yum.repos.d/
mkdir /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak
curl http://mirrors.163.com/.help/CentOS7-Base-163.repo > base.repo
yum clean all
yum check-update

# Pre
yum -y install kernel-devel

# Install Package
yum -y install dhcp tftp-server vsftpd xinetd syslinux

# Congigure vsftpd
mkdir /var/ftp/centos6
mkdir /var/ftp/centos7
systemctl start vsftpd
systemctl enable vsftpd

# mount ios image 
mount /dev/cdrom /var/ftp/centos7
#mount /dev/cdrom /var/ftp/centos6

# Configure DHCP Server
>  /etc/dhcp/dhcpd.conf
cat >> /etc/dhcp/dhcpd.conf <<EOF
subnet $DHCP_SUBNET  netmask 255.255.255.0 {
  range $DHCP_RANGE;
  next-server $TFTP_SERVER;  #tftp-server IP
  filename "pxelinux.0";  # 指向的是tftp-server的根目录/var/lib/tftpboot
}
EOF
systemctl start dhcpd
systemctl enable dhcpd

# Configure Tftp-Server
cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
cp -rf /var/ftp/centos7/isolinux/* /var/lib/tftpboot/
sed -ri '/disable/c\disable = no' /etc/xinetd.d/tftp
mkdir /var/lib/tftpboot/{centos6,centos7,pxelinux.cfg}
cp -rf /var/ftp/centos6/isolinux/* /var/lib/tftpboot/centos6/
cp -rf /var/ftp/centos7/isolinux/* /var/lib/tftpboot/centos7/
cp /var/ftp/centos7/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default
> /var/lib/tftpboot/pxelinux.cfg/default
cat >> /var/lib/tftpboot/pxelinux.cfg/default <<EOF
default vesamenu.c32
timeout 600
display boot.msg
menu clear
menu background splash.png
menu title CentOS 7
menu vshift 8
menu rows 18
menu margin 8
#menu hidden
menu helpmsgrow 15
menu tabmsgrow 13
menu color border * #00000000 #00000000 none
menu color sel 0 #ffffffff #00000000 none
menu color title 0 #ff7ba3d0 #00000000 none
menu color tabmsg 0 #ff3a6496 #00000000 none
menu color unsel 0 #84b8ffff #00000000 none
label centos6
  menu label ^Install CentOS 6
  menu default
  kernel centos6/vmlinuz
  append initrd=centos6/initrd.img inst.stage2=ftp://$FTP_SERVER/centos6 inst.repo=ftp://$FTP_SERVER/centos6 
label centos7
  menu label ^Install CentOS 7
  kernel centos7/vmlinuz
  append initrd=centos7/initrd.img inst.stage2=ftp://$FTP_SERVER/centos7 inst.repo=ftp://$FTP_SERVER/centos7 inst.ks=ftp://$FTP_SERVER/centos7.ks
EOF

systemctl restart vsftpd
systemctl restart xinetd
systemctl enable xinetd

# 

#
