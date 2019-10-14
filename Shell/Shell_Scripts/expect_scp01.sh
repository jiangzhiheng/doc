#!/usr/bin/expect
set ip [lindex $argv 0]  
set user [lindex $argv 1]
set password PASSWORD 
set timeout 5
spawn scp -r /etc/hosts $user@$ip:/etc

expect {
	"yes/no" { send "yes\r"; exp_continue }
	"password:" { send "$password\r" };
}
expect eof 
