#!/usr/bin/expect
set ip [lindex $argv 0]  #位置参数1
set user [lindex $argv 1]  #位置参数2
set password PASSWORD 
set timeout 5
spawn ssh $user@$ip

expect {
	"yes/no" { send "yes\r"; exp_continue }
	"password:" { send "$password\r" };
}
#interact #进入交互模式
expect "#"
send "useradd test\r"
send "exit\r"
expect eof #结束expect
