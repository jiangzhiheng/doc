#!/bin/bash
#ping01
thread=5
tmp_fifofile=/tmp/$$.fifo

mkfifo $tmp_fifofile  #创建一个命名管道
exec 8<> $tmp_fifofile
rm $tmp_fifofile

for i in `seq $thread`
#for循环创建5个线程
do
	echo >&8
done

for i in {100..254}
do
	read -u 8
	{
	ip=192.168.1.$i
	ping -c1 -W1 $ip &>/dev/null
	if [ $? -eq 0 ];then
		echo "$ip is up"
	fi
	echo >&8
	}&
done
wait
echo "all finished..."
