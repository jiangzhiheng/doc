#!/bin/bash
#v1.0 by Jiangzhiheng 2019.1.15
read -p "please enter a New Password:" pass

for ip in `cat ip.txt`
do
	{
	ping -c1 -W1 $ip &>/dev/null
	if [ $? -eq 0 ];then
		ssh $ip "echo $pass| passwd --stdin root"
		if [ $? -eq 0 ];then
			echo "$ip" >> ok_`date +%F`.txt
		else
			echo "$ip" >> fail_`date +%F`.txt
		fi
	else
		echo "$ip" >> fail_`date +%F`.txt
	fi
	}&
done
wait
echo "finished..."
