#!/bin/bash
#
>ip.txt
password=PASSWORD

rpm -ql expect &>/dev/null
if [ $? -eq 0 ];then
	yum -y install expect &>/dev/null
fi
if [ ! -f ~/.ssh/id_rsa ];then
	ssh-keygen -P "" -f ~/.ssh/id_rsa
fi

for i in {3..254}
do
	{
	ip=192.168.1.$i
	ping -c1 -w1 $ip &>/dev/null
	if [ $? -eq 0 ];then
		echo "$ip" >> ip.txt
		/usr/bin/expect <<-EOF
		set timeout 15
		spawn ssh-copy-id  $ip
		expect {
			"yes/no" { send "yes\r"; exp_continue }
			"password:" { send "$password\r" }
		}
		expect eof
		EOF
	fi	
	}&
done
wait
echo "finished"

