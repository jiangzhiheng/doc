#!/bin/bash
#while create user
#v0.1 by Jiangzhiheng 2019.10.16
while read line
do
	if [ ${#line} -eq 0 ];then
	#判断是否为空行
		continue
	fi

	user=`echo $line|awk '{print $1}'`
	pass=`echo $line|awk '{print $2}'`
	id $user &>/dev/null
	if [ $? -eq 0 ];then
		echo "user $user already exists"
	
	else 
		useradd $user
		echo "$pass" |passwd --stdin $user &>/dev/null
		if [ $? -eq 0 ];then
			echo "$user is created"
		fi
	fi
done < $1
# $1 is userlist file
echo "all ok...."
