#!/bin/bash
#
disk_use=`df -Th | grep '/$'|awk '{print $(NF-1)}' |awk -F"%" '{print $1}'`
mail_user=root
if [ $disk_use -ge 7 ];then
	echo "`date +%F-%H` disk: ${disk_use}%" |mail -s "disk warning.." $mail_user
fi
