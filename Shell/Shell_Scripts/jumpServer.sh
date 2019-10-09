#!/bin/bash
#
####################################
# Jump Server                      #
# v0.1 by jiangzhiheng 2019.10.9   #
####################################

#trap "" HUP INT OUIT TSTP

node1=192.168.1.129
node2=192.168.1.130

clear

while :
do
	cat <<-EOF
	+------------------------------------+
	|      Jump Server v0.1		     |
	|	1. node1		     |	
	|	2. node2		     |
	|	3. quit			     |	
	+------------------------------------+
	EOF
	echo -en "\e[1;31mPlease input number: \e[0m"
	read  num
	case "$num" in
	1)
		ssh alice@${node1}
		;;
	2)
		ssh alice@${node2}
		;;
	3)
		exit
		;;
	*)
		echo "Error"
	esac
done



