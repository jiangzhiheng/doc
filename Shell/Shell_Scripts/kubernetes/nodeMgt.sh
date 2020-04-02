#!/bin/bash
# Usage: ./nodeMgt "COMMAND"
NODE_LIST=(192.168.1.103 192.168.1.104)
PASSWORD=
ACTION=$1
for i in ${NODE_LIST[@]};do
	/usr/bin/expect <<-EOF
	set timeout 15
	spawn ssh root@$i $ACTION
	expect {
		"password:" { send "$PASSWORD\r" };	
	}
	expect eof
	EOF
done
