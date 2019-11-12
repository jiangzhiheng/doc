#!/bin/bash
#
LISTEN(){
	ss -an|grep '^tcp' |grep 'LISTEN'|wc -l
}

SYN_RECV(){
	 ss -an|grep '^tcp' |grep 'SYN[_-]RECV'|wc -l
}

ESTABLISHED(){
	ss -an|grep '^tcp' |grep 'ESTAB'|wc -l
}

TIME_WAIT(){
	ss -an|grep '^tcp' |grep 'TIME[_-]WAIT'|wc -l
}

$1   #执行$1传入的参数所代表的函数
