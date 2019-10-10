#!/bin/bash
#
####################################
# System Manage                    #
# v0.1 by jiangzhiheng 2019.10.10  #
####################################
menu(){
	cat <<-EOF
	+---------------------------------+
	|     System Manager v0.1         |	
	|	h. help			  |
	|	f. disk partition	  |
	|	g. filesystem mount	  |
	|	m. memory		  |
	|	u. system load		  |
	|	q. exit			  |
	+---------------------------------+
	EOF
}
menu

while true
do
	echo -en "\e[1;31mPlease input[h for help]: \e[0m"
	read  action
	case "$action" in
	h)
		clear
		menu
		;;
	f)
		fdisk -l
		;;
	g)
		df -Th
		;;
	m)
		free -m
		;;
	u)
		uptime
		;;
	q)
		break
		;;
	"")
		;;
	*)
		echo "Error"
	esac
done
echo "finished...."
