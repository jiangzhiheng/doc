#!/bin/bash
# LVM backup mysql

back_dir=/backup/`date +%F`

[ -d $back_dir ] || mkdir -p $back_dir

echo "FLUSH TABLES WITH READ LOCK;SYSTEM lvcreate -L 500M -s -n mysql-snap /dev/datavg/mysql;" | mysql -uroot -p'12345'

mount -o ro,nouuid /dev/datavg/mysql-snap /mnt/ 

rsync -a /mnt/ $back_dir

if [ $? -eq 0 ];then
	umount /dev/datavg/mysql-snap
	lvremove -f /dev/datavg/mysql-snap
fi

