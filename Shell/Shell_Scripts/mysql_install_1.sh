#!/bin/bash
#mysql install

while read ip
do
	{
	#yum
	ssh root@$ip "rm -rf /etc/yum.repos.d/*"
	ssh root@$ip "wget ftp://172.16.100.10/yumrepo/centos7.repo -P /etc/yum.repos.d/"
	ssh root@$ip "wget ftp://172.16.100.10/yumrepo/mysql57.repo -P /etc/yum.repos.d/"
	ssh root@$ip "yum -y install lftp vim-enhanced bash-completion"
	#scp -r /etc/yum.repos.d/centos7.repo root@$ip:/etc/yum.repos.d/
	
	#firewalld & selinux
	ssh root@$ip "systemctl disable firewalld;systemctl enable firewalld"
	ssh root@$ip "setenforce 0;sed -ri '/^SELINUX/c\SELINUX=disabled' /etc/selinux/config"
	#ntp
	ssh root@$ip "yum -y install chrony"
	ssh root@$ip "sed -ri '/server 3.centos.pool.ntp.org iburst/a\server 172.16.100.2 iburst' /etc/chrony.conf"
	ssh root@$ip "systemctl start chronyd;systemctl enable chronyd"
	#安装MySQL5.7
	ssh root@$ip "yum -y install mysql-community-server"
	ssh root@$ip "systemctl start mysqld;systemctl enable mysqld"
	ssh root@$ip "grep 'temporary password'  /var/log/mysqld.log|awk '{print \$NF}' >/root/mysqloldpass.txt"
	ssh root@$ip 'mysqladm -uroot -p"`cat /root/mysqloldpass.txt`" password "NEW_PASSWORD"'
	}&
done <ip.txt
wait
echo "all finished"
