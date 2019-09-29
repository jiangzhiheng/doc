#!/bin/bash
####################################
# Install Apache	           #
# v0.1 by jiangzhiheng 2019.9.29   #
#				   #
####################################
#
gateway=192.168.1.2

ping -c1 www.baidu.com &> /dev/null
if [ $? -eq 0 ] &> /dev/null;then
	yum -y install httpd
	systemctl start httpd
	systemctl enable httpd
	#firewall-cmd --permanent --add-service=http
	#firewall-cmd --permanent --add-service=https
	#firewall-cmd --reload
	sed -ri '/^SELINUX/cSELINUX=disabled' /etc/selinux/config
	setenforce 0
	curl http://127.0.0.1 &> /dev/null
	if [ $? -eq 0 ];then
		echo "Apache is ok"
	fi
elif ping -c1 $gateway &>/dev/null;then
	echo "check dns..."
else
	echo "echo ip address!"
fi

