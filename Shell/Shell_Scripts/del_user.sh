#!/bin/bash
####################################
# delete user 		           #
# v0.1 by jiangzhiheng 2019.10.8   #
####################################

read -p "Please input a username: " user

id $user &>/dev/null

if [ $? -ne 0 ];then
	echo "nu such user $user"
	exit 1
fi

read -p "Are you sure?[y/n]: " action

case "$action" in
Y|YES|y|yes)	
	userdel -r $user
	echo "$user is deleted!"
	;;
*)
	echo "Error"
esac

#if [  "$action" != "y" ];then
#	echo "good!"
#	exit
#
#userdel -r $user
#echo "$user is deleted!"
