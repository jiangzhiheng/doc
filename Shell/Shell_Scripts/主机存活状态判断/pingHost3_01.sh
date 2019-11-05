#!/bin/bash
#
ip_list="192.168.1.158 192.168.1.129 192.168.1.130"

#while read ip
for ip in $ip_list
do
	for count in {1..3}
	do
		ping -c1 -W1 $ip &>/dev/null
		if [ $? -eq 0 ];then
			echo "$ip is ok"
			break
		else
			echo "$ip ping is failure: $count"
			fail_count[$count]=$ip
		fi
	done
	if [ ${#fail_count[*]} -eq 3 ];then
		echo "${fail_count[1]} ping is failure!"
		unset fail_count[*]
	fi
done
#done <$1
