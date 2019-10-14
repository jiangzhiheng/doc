#!/bin/bash
#create user by read userlist file
#
#userlist format
#	user1   passwd1
#	user2	passwd2
#	user3	passwd3
#	.....



if [ $# -eq 0 ];then
	echo "usage:`basename $0` file"
	exit 1
fi

if [ ! -f $1 ];then
	echo "error file"
	exit 2
fi

#希望for处理文件按照回车分隔，而不是空格或者tab空格
#重新定义分隔符为回车 \n
#IFS内部字段分隔符
IFS=$'\n'

for line in `cat $1`
do
	if [ ${#line} -eq 0 ];then
		continue
	fi
	user=`echo $line|awk '{print $1}'`
	pass=`echo $line|awk '{print $2}'`
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

