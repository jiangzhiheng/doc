#!/usr/bin/expect
set ip 192.168.1.129
set user root
set password PASSWORD 
set timeout 5
spawn ssh $user@$ip

expect {
	"yes/no" { send "yes\r"; exp_continue }
	"password:" { send "$password\r" };
}
interact
