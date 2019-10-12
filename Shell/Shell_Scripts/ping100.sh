#!/bin/bash
#ping check

>ip.txt

for i in {2..254}
do 
	{
	ip=192.168.1.$i
	ping -c1 -w1 $ip &>/dev/null
	if [ $? -eq 0 ];then
		echo "$ip is up"|tee -a ip.txt
	fi
	}&  #放到后台执行
done
wait   #等待之前所有的后台进程结束
echo "finished.."

