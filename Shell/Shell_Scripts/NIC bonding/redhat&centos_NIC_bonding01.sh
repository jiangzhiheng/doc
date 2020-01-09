#!/bin/bash
# This scripts used by Redhat/Centos NIC bonding
# v0.1 by JiangZhiheng

function bondConfig(){
	# mode=0 :load balance(round-robin)
	# mode=1 :fault-tolerance (active-backup)
	(
	cat <<-EOF
	DEVICE=$1
	IPADDR=$2
	NETMASK=$3
	ONBOOT=yes
	BOOTPROTO=none
	USERCTL=no
	BONDING_OPTS='mode=1 miimon=100'
	GATEWAY=$4
	EOF
	) > /etc/sysconfig/network-scripts/ifcfg-$1 

}

function memberConfig(){
	# $1 member name
	# $2 bondname
	(
	cat <<-EOF
	DEVICE=$1
	BOOTPROTO=none
	ONBOOT=yes
	MASTER=$2
	SLAVE=yes
	USERCTL=no
	EOF
	) > /etc/sysconfig/network-scripts/ifcfg-"$1" 
}

# 输入bond name
clear
echo -e "\033[31mEnter Config Information: \033[0m"
read -p "Please Enter BondName[eg.<bond0>]: " BondName
read -p "Please Enter IPAddress: " IPAddress
read -p "Please Enter NetMask:" NetMask
read -p "Please Enter GateWay: " GateWay

echo -e "\033[31mCurrent NIC List：\033[0m"
array=($(cat /proc/net/dev |awk '{if(NR>2){print $1}}' | awk -F":" '{print $1}'))
echo ${array[@]}

#输入需要绑定的网卡 eth0，eth1
echo -e "\033[31mPlease Enter Member Name[eg.<Member1 Member2>]:\033[0m"
read  Member1 Member2
echo -e "\n"

echo -e "\033[31mBond Config Information: \033[0m"
printf "\033[32m
+-------------------------------------------+
|
| BondName:		$BondName                                           
| IPAddress:		$IPAddress          
| NetMask:		$NetMask            
| GateWay:		$GateWay            
| NIC Members:		$Member1,$Member2    
|                                               
+-------------------------------------------+
\033[0m"
echo "Please Confirm Your Input!"
read -p "Are you sure?[y/n]: " action
case "$action" in 
	Y|YES|y|yes)
		# 检查bond是否已经存在,不存在则创建新的配置文件
		grep -i '$BondName' /etc/modprobe.d/dist.conf
		if [ $? -eq 0 ];then
			echo "The bonding is exists"
			exit 1
		else 
			echo  "alias $BondName bonding"  >> /etc/modprobe.d/dist.conf
			bondConfig $BondName $IPAddress $NetMask $GateWay
		fi

		# 配置成员网卡信息
		if test -e /etc/sysconfig/network-scripts/ifcfg-"$Member1" ;then
			echo "ifcfg-$Member1 is exists backup to ifcfg-$Member1.bak"
			mv /etc/sysconfig/network-scripts/ifcfg-"$Member1" /etc/sysconfig/network-scripts/ifcfg-"$Member1".bak
			echo "writing config to new ifcfg-$Member1 ....."
			memberConfig $Member1 $BondName
			echo "create ifcfg-$Member1 success....."
		else
			echo "ifcfg-$Member1 is not exists,check it please!"
			exit 2
		fi

		if test -e /etc/sysconfig/network-scripts/ifcfg-"$Member2" ;then
			echo "ifcfg-$Member2 is exists backup to ifcfg-$Member1.bak"
			mv /etc/sysconfig/network-scripts/ifcfg-"$Member2" /etc/sysconfig/network-scripts/ifcfg-"$Member2".bak
			echo "writing config to new ifcfg-$Member2 ....."
			memberConfig $Member2 $BondName
			echo "create ifcfg-$Member2 success..."
		else
			echo "ifcfg-$Member2 is not exists,check it please!"
			exit 2
		fi

		# 添加开机自启动
		echo "ifenslave BondName Member1 Member2" >>/etc/rc.d/rc.local

		service NetworkManager stop
		chkconfig NetworkManager off
		service network restart
		;;
	*)
		exit 1
esac
# ping网关测试
echo "Ping GateWay Test:"
ping -c4 -w1 $GateWay
if [ $? -eq 0 ];then
	echo "Ping GateWay Test Successful"
else
	echo "Ping Test Failed,Please check cable connection!"
fi
echo "All finished..."
