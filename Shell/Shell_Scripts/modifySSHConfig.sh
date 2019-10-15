#!/bin/bash
#v0.1 by Jiangzhiheng 2019.10.15

for ip in `cat ip.txt`
do
	{
	ping -c1 -W1 $ip &>/dev/null
	if [ $? -eq 0 ];then
		ssh $ip "sed -ri '/^#UseDNS/cUseDNS no' /etc/ssh/sshd_config"
		ssh $ip "sed -ri '/^GSSAPIAuthentication/cGSSAPIAuthentication no' /etc/ssh/sshd_config"
		ssh $ip "systemctl stop firewalld;systemctl disable firewalld"
		ssh $ip "sed -ri '/^SELINUX=/cSELINUX=disable' /etc/selinux/config"
		ssh $ip "setenforce 0"
	fi	
	}&
done
wait
echo "finished.."
