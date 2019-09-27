#!/bin/bash
#
read -p "Please input number: " num

while true
do
	if [[ "$num" =~ ^[0-9]+$ ]];then
		break
	else	
		echo "Error number"	
		read -p "Please input number: " num
	fi
done

read -p "Please input prefix: " prefix
if [ -z "$prefix" ];then
	echo "Error prefix"
	exit
fi

for i in `seq $num`
do
	user=$prefix$i
	/usr/sbin/useradd $user
	echo "123456" |passwd --stdin $user &> /dev/null
	if [ $? -eq 0 ];then
		echo "$user is created"
	fi 
done

