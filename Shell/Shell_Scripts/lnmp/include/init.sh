#!/bin/bash
#init

init_os(){

#YUM
#rm -rf /etc/yum.repos.d/*
#wget ftp://172.16.100.10/yumrepo/centos7.repo -P /etc/yum.repos.d/
#yum -y install lftp vim-enhanced bash-completion


#firewalld && selinux
#systemctl disable firewalld
#systemctl enable firewalld
firewalld-cmd --permanent --add-service=http
firewalld-cmd --permanent --add-service=https
firewalld-cmd --reload
setenforce 0
sed -ri '/^SELINUX/c\SELINUX=disabled' /etc/selinux/config

#ntp
yum -y install chrony
sed -ri '/server 3.centos.pool.ntp.org iburst/a\server 172.16.100.2 iburst' /etc/chrony.conf
systemctl start chronyd;systemctl enable chronyd

}

