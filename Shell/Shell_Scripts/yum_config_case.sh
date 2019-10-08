#!/bin/bash
####################################
# Config Yum Repo by case          #
# v0.1 by jiangzhiheng 2019.10.7   #
#                                  #
####################################

os_version=`cat /etc/redhat-release |awk '{print $4}'|awk -F"." '{print $1"."$2}'`
yum_server=127.0.0.1

[ -d /etc/yum.repos.d ]|| mkdir /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak &>/dev/null

case "$os_version" in
7.6)
	#curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	cat >>/etc/yum.repos.d/centos7u6.repo <<-EOF
	[centos7u6]
	name=centos7u6
	baseurl=ftp://$yum_server/centos7u6
	gpgcheck=0
	EOF
	echo "$os_version YUM configure..."
	;;
6.8)
	#curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
	cat >>/etc/yum.repos.d/centos6u8.repo <<-EOF
	[centos6u8]
	name=centos6u8
	baseurl=ftp://$yum_server/centos6u8
	gpgcheck=0
	EOF
	echo "$os_version YUM configure..."
	;;
*)
	
	echo "Error"
esac

