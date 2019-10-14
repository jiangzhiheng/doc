#!/bin/bash
#create user 

read -p "Please enter prefix & password & num[test 123 5]" prefix pass num
printf "user information:
------------------------------
user prefix: 	$prefix
user password:	$pass
user num:	$num
------------------------------
"
read -p "Are you sure?[y/n]" action
if [ "$action" != "y" ];then
	exit 1
fi 

for i in `seq -w $num`
do
	user=$prefix$i
	id $user &>/dev/null
	if [ $? -eq 0 ];then
		echo "user $user already exists"
	else
		useradd $user
		echo $pass |passwd --stdin $user&>/dev/null
		if [ $? -eq 0 ];then
			echo "$user is created."
		fi 
	fi
done
