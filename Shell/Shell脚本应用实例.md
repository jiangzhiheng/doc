1. ### **分析系统资源性能瓶颈**

   脚本功能：

   1. 查看CPU利用率与负载`(top, vmstat, sar)`
   2. 查看磁盘，`Inode`利用率与I/O负载`(df,iostat,iotop,sar,dstat)`
   3. 查看内存利用率`(free,vmstat)`
   4. 查看TCP链接状态`（netstat,ss）`
   5. 查看CPU与内存占用最高的10个进程`（top,ps）`
   6. 查看网络流量`（ifconfig,iftop,iptraf）`

   完整脚本

   ```shell
   #!/bin/bash
   #show system information
   PS3="Your choice is: "
   os_check(){
   	if [ -e /etc/redhat-release ];then
   		REDHAT=`cat /etc/redhat-release|cut -d' ' -f1`
   	else
   		DEBIAN=`cat /etc/issue |cut -d' ' f1`
   	fi
   
   	if [ "$REDHAT"=="Centos" -o "$REDHAT"=="RED" ];then
   		P_M=yum
   	elif [ "$DEBIAN"=="Ubuntu" -o "DEBIAN"=="ubuntu" ];then
   		P_M=apt-get
   	else
   		echo "Operating system does not support."
   		exit 1
   	fi
   }
   
   if [ "$LOGNAME" != root ];then
   	echo "Please use root account operation"
   	exit 1
   fi
   
   
   if ! which vmstat &>/dev/null;then
   	echo "vmstat command not found,now the install."
   	sleep 1
   	os_check
   	$P_M install procps -y
   	echo "-------------install complete----------------------"
   fi
   
   if ! which iostat &>/dev/null;then
           echo "vmstat command not found,now the install."
           sleep 1
           os_check
           $P_M install sysstat -y
           echo "-------------install complete----------------------"
   fi
   
   while true; do
   #	clear
   	select input in cpu_load disk_load disk_use disk_inode mem_use tcp_status cpu_top10 mem_top10 traffic quit; do
   		case $input in
   			#CPU利用率与负载
   			cpu_load)
   				echo "-----------------------------------------"
   				i=1
   				while [[ $i -le 3 ]];do
   					echo -e "\033[32m 参考值${i}\033[0m"
   					UTIL=`vmstat|awk '{ if(NR==3)print 100-$15"%" }'`
   					USER=`vmstat|awk '{ if(NR==3)print $13"%" }'`
   					#处理第三行
   					SYS=`vmstat|awk '{ if(NR==3)print $14"%" }'`
   					IOWAIT=`vmstat|awk '{ if(NR==3)print $16"%" }'`
   					echo -e "Util: $UTIL"
   					echo -e "User use: $USER"
   					echo -e "System use: $SYS"
   					echo -e "I/O wait: $IOWAIT"
   					let i++
   					sleep 1
   				done
   				echo "-----------------------------------------"
   				break
   				;;
   			disk_load)
   			#硬盘I/O负载
   				echo "-----------------------------------------"
                                   i=1
                                   while [[ $i -le 3 ]];do
                                           echo -e "\033[32m 参考值${i}\033[0m"
                                           UTIL=`iostat -x -k |awk '/^[v|s]/{OFS=": ";print $1,$NF"%"}'`
                                           READ=`iostat -x -k |awk '/^[v|s]/{OFS=": ";print $1,$6"KB"}'`
                                           WRITE=`iostat -x -k |awk '/^[v|s]/{OFS=": ";print $1,$7"KB"}'`
                                           IOWAIT=`vmstat |awk '{if(NR==4)print $16"%"}'`
                                           echo -e "Util"
   					echo -e "\t${UTIL}"
                                           echo -e "I/O wait: $IOWAIT"
                                           echo -e "Read/s:\n$READ"
                                           echo -e "Write/s:\n$WRITE"
                                           let i++
                                           sleep 1
                                   done
                                   echo "-----------------------------------------"
                                   break
                                   ;;
   			disk_use)
   			#硬盘利用率
   				DISK_LOG=/tmp/disk_use.tmp
   				DISK_TOTAL=`fdisk -l|awk '/^Disk.*bytes/ && /\/dev/{ print $2" ";printf "%d",$3;print "GB" }'`
   				USE_RATE=`df -h|awk '/^\/dev/{print int($5)}'`
   				for i in $USE_RATE;do
   					if [ $i -gt 90 ];then
   						PART=`df -h |awk '{if(int($5)=='''$i''')print $6}'`
   						echo "$PART = ${i}" >> $DISK_LOG	
   					fi
   				done
   				echo "------------------------------------------"
   				echo -e "Disk Total:\n${DISK_TOTAL}"
   				if [ -f $DISK_LOG ];then
   					echo "----------------------------------"
   					cat $DISK_LOG
   					echo "----------------------------------"
   					rm -f $DISK_LOG
   				else
   					echo "----------------------------------"
   					echo "Disk use rate no than 90% of the partition"
   					echo "----------------------------------"
   				fi
   				break
   				;;
   			disk_inode)
   			#Inode利用率
   				INODE_LOG=/tmp/inode_use.log
   				INODE_USE=`df -i|awk '/^\/dev/{print int($5)}'`
   				for i in $INODE_USE;do
   					if [ $i -gt 90 ];then
   						PART=`df -h | awk '{if(int($5)=='''$i''') print $6}'`
   						echo "$PART = ${i}%" >> $INODE_LOG
   					fi
   				done
                                   if [ -f $INODE_LOG ];then
                                           echo "----------------------------------"
                                           cat INODE_LOG
   					rm -f $INODE_LOG
                                           echo "----------------------------------"
                                   else
                                           echo "----------------------------------"
                                           echo "Inode use rate no than 90% of the partition"
                                           echo "----------------------------------"
                                   fi
                                   break
                                   ;;
   			mem_use)
   			#内存使用率
   				echo "-----------------------------------------------"
   				MEM_TOTAL=`free -m|awk '{if(NR==2)printf "%.1f",$2/1024}END{print "G"}'`
   				USE=`free -m|awk '{if(NR==2)printf "%.1f",$3/1024}END{print "G"}'`
   				FREE=`free -m|awk '{if(NR==2)printf "%.1f",$4/1024}END{print "G"}'`
   				CACHE=`free -m|awk '{if(NR==2)printf "%.1f",$6/1024}END{print "G"}'`
   				echo -e "Total: $MEM_TOTAL"
   				echo -e "Use: $USE"
   				echo -e "Free: $FREE"
   				echo -e "Cache: $CACHE"
   				echo "-----------------------------------------------"
   				break
   				;;
   			tcp_status)
   			#网络链接状态
   				echo "-----------------------------------------------"
   				COUNT=`ss -ant|awk '!/State/{status[$1]++}END{for(i in status) print i,status[i]}'`
   				echo -e "TCP connection status:\n$COUNT"
   				echo "-----------------------------------------------"
   				break
   				;;
   			cpu_top10)
   			#占用CPU高的前10个进程
   				echo "-----------------------------------------------"
   				CPU_LOG=/tmp/cpu_top.log
   				i=1
   				while [[ $i -le 3 ]];do
   					ps aux|awk '{ if($3>0.1){{printf "PID: "$2" CPU:"$3"% --->" }for(i=11;i<=NF;i++)if(i==NF)printf $i"\n";else printf $i}}'|sort -k4 -nr|head -10 > $CPU_LOG
   					#循环从11列开始打印，如果i等于最后一行，就打印i的列并换行，否则就打印i的列（有的进程有大于11列的行，进程的参数）
   					if [[ -n `cat $CPU_LOG` ]];then
   						echo -e "\033[32m 参考值${i}\033[0m"
   						cat $CPU_LOG
   						> $CPU_LOG
   					else
   						echo "No process using the CPU."
   						break
   					fi
   					let i++
   					sleep 1
   				done
   				echo "----------------------------------------------"
   				break
   				;;
   			mem_top10)
                           #占用内存高的前10个进程
                                   echo "-----------------------------------------------"
                                   MEM_LOG=/tmp/mem_top.log
                                   i=1
                                   while [[ $i -le 3 ]];do
                                           ps aux|awk '{ if($4>0.1){{printf "PID: "$2" Memory:"$4"% --->" }for(i=11;i<=NF;i++)if(i==NF)printf $i"\n";else printf $i}}'|sort -k4 -nr|head -10 > $MEM_LOG
                                           #循环从11列开始打印，如果i等于最后一行，就打印i的列并换行，否则>就打印i的列（有的进程有大于11列的行，进程的参数）
                                           if [[ -n `cat $MEM_LOG` ]];then
                                                   echo -e "\033[32m 参考值${i}\033[0m"
                                                   cat $MEM_LOG
                                                   > $MEM_LOG
                                           else
                                                   echo "No process using the Memory."
                                                   break
                                           fi
                                           let i++
                                           sleep 1
                                   done
                                   echo "----------------------------------------------"
                                   break
                                   ;;
   			traffic)
   			#查看网卡流量
   				while true; do
   					read -p "Please enter the network card name(ethXX or ensXX or teamXX): " eth
   					if [ `ifconfig|grep -c "\<$eth\>"` -eq 1 ];then
   						break
   					else
   						echo "Input format error or Don't have the card name,pleace input again."
   					fi
   				done
   				echo "----------------------------------------------"
   				i=1
   				while [[ $i -le 3 ]];do
   					#Centos7与Centos6 ifconfig输出流入位置不同
   					#Centos6中RX与TX行号等于8
   					#Centos7中RX行号是5，TX行号是7
   					OLD_IN=`ifconfig $eth |awk -F"[: ]+" '/bytes/{if(NR==8)print $4;else if(NR==4)print $6}'`
   					#NR具体看ifconfig输出
   					OLD_OUT=`ifconfig $eth |awk -F"[: ]+" '/bytes/{if(NR==8)print $9;else if(NR==4)print $6}'`
   					sleep 1
   					NEW_IN=`ifconfig $eth |awk -F"[: ]+" '/bytes/{if(NR==8)print $4;else if(NR==4)print $6}'`
   					NEW_OUT=`ifconfig $eth |awk -F"[: ]+" '/bytes/{if(NR==8)print $9;else if(NR==4)print $6}'`
   					IN=`awk 'BEGIN{ printf "%.1f\n",'$((${NEW_IN}-${OLD_IN}))'/1024/128 }'`
   					OUT=`awk 'BEGIN{ printf "%.1f\n",'$((${NEW_OUT}-${OLD_OUT}))'/1024/128 }'`				
   					echo "${IN}MB/s  ${OUT}MB/s"
   					let i++
   					sleep 1
   				done	
   				echo "---------------------------------------------"
   				break
   				;;
   			quit)
   				exit 0;
   				;;
   			*)
   				echo "---------------------------------------------"
   				echo "Please enter the number."
   				echo "---------------------------------------------"
   				break
   		esac
   	done
   done			
   ```

   

2. ### **判断主机存活状态**

   示例01

   ```shell
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
   ```

   示例02

   ```shell
   #!/bin/bash
   #
   ping_success(){
           ping -c1 -W1 $ip &>/dev/null
           if [ $? -eq 0 ];then
                   echo "$ip is ok"
                   continue
           fi
   }
   
   while read ip
   do
           ping_success
           ping_success
           ping_success
           echo "$ip ping is failure!"
   done < $1
   
   ```

   

3. ### **`Nginx`日志分析**

   1. `Nginx`日志分析
   
      日志格式：
   
      ```nginx
      log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                            '$status $body_bytes_sent "$http_referer" '
                            '"$http_user_agent" "$http_x_forwarded_for"';
      # $remote_addr  $1
      # $time_local   $4
      # $request	    $7
      # $status       $9
      # $body_bytes_sent  $10
      ```
   
      - 统计2019年9月5日`PV`量
   
        `grep '06/Nov/2019' /var/log/nginx/access.log |wc -l`
   
        `awk '$4>="[06/Nov/2019:22:30:20 && $4<=[06/Nov/2019:22:40:00"{print $0}' /var/log/nginx/access.log |wc -l`   统计具体某一时段的PV量
   
      - 统计2019年9月5日访问最多的10个`IP(Top10)`
   
        `awk '/06\/Nov\/2019/{ips[$1]++}END{for(i in ips){print i,ips[i]}}' /var/log/nginx/access.log |sort -k2 -rn |head -n10`
   
      - 统计2019年9月5日访问大于100次的`IP ` 
   
        `awk '/06\/Nov\/2019/{ips[$1]++}END{for(i in ips){if(ips[i]>100){print i,ips[i]}}}' /var/log/nginx/access.log`
   
      - 统计2019年9月5日访问最多的10个页面` $request top10`
   
        `awk '/06\/Nov\/2019/{urls[$1]++}END{for(i in urls){if(urls[i]>100){print i,urls[i]}}}' /var/log/nginx/access.log |sort -k2 -rn |head -n10` 
   
      - 统计2019年9月5日 每个URL访问内容总大小`($body_bytes_sent)`
   
        `awk '/06\/Nov\/2019/{size[$7]+=$10}END{for(i in size){print i,size[i]}}' /var/log/nginx/access.log |sort -k2 -rn |head -10`
   
      - 统计2019年9月5日每个`IP`访问状态码数量`($status)`
   
        `awk '/06\/Nov\/2019/{ip_code[$1" "$9]++}END{for (i in ip_code){print i,ip_code[i]}}' /var/log/nginx/access.log |sort -k1 -rn |head -n10`
   
      - 统计2019年9月5日`IP`访问状态码为404及出现次数
   
        `awk '/06\/Nov\/2019/{if($9=="404"){ip_code[$1" "$9]++}}END{for(i in ip_code){print i,ip_code[i]}}' /var/log/nginx/access.log |sort -k2 -rn|head`
   
      - 统计前一分钟的`PV`量
   
        `date=$(date -d '1 minute' +%d/%b/%Y:%H:%M);awk -v date=$date '$0 ~ date{i++}END{print i}' /var/log/nginx/access.log`
   
      - 统计2019年9月5日`8：30---9：00`之间访问状态码404
   
        `awk '$4>="[06/Nov/2019:22:30:00 && $4<=[06/Nov/2019:23:00:00"{if($9=="404"){ip_code[$1" "$9]++}}END{for(i in  ip_code){print i,ip_code[i]}}' /var/log/nginx/access.log`
   
      - 统计2019年9月5日各种状态码数量
   
        `awk '/06\/Nov\/2019/{code[$9]++}END{for (i in code){print i,code[i]}}' /var/log/nginx/access.log`
   
4. ### **备份保存**

   需求：
   
   - 定期删除/data目录下修改时间大于7天的文件
   
     `find /data -mtime +7 -exec -rf {} \;`
   
     `find /data -mtime +7 |xargs rm -rf`
   
   - 定期清理`/data/YY-DD-MM.tar.gz`
   
     该目录仅工作日周一至周五自动生成文件`/data/YY-DD-MM.tar.gz`
   
     希望只保留最近两天的文件
   
     无论过几个节假日/data仍会有前两个工作日的备份文件
   
     `ls -t /data/*.tar.gz |awk 'NR>2'|xargs rm -rf`   #原理是利用ls命令按照时间排序功能，并且利用`awk`筛选出行号大于2的其它文件进行删除
   
     `ls -t /data/*.tar.gz |awk 'NR>2{print "rm -f "$0}' |bash`
   
     
   
5. ### **多机部署`Mysql`**

   方式一：
   
   ```shell
   #!/bin/bash
   #mysql install
   
   while read ip
   do
           {
           #yum
           ssh root@$ip "rm -rf /etc/yum.repos.d/*"
           ssh root@$ip "wget ftp://172.16.100.10/yumrepo/centos7.repo -P /etc/yum.repos.d/"
           ssh root@$ip "wget ftp://172.16.100.10/yumrepo/mysql57.repo -P /etc/yum.repos.d/"
           ssh root@$ip "yum -y install lftp vim-enhanced bash-completion"
           #scp -r /etc/yum.repos.d/centos7.repo root@$ip:/etc/yum.repos.d/
   
           #firewalld & selinux
           ssh root@$ip "systemctl disable firewalld;systemctl enable firewalld"
           ssh root@$ip "setenforce 0;sed -ri '/^SELINUX/c\SELINUX=disabled' /etc/selinux/config"
           #ntp
           ssh root@$ip "yum -y install chrony"
           ssh root@$ip "sed -ri '/server 3.centos.pool.ntp.org iburst/a\server 172.16.100.2 iburst' /etc/chrony.conf"
           ssh root@$ip "systemctl start chronyd;systemctl enable chronyd"
           #安装MySQL5.7
           ssh root@$ip "yum -y install mysql-community-server"
           ssh root@$ip "systemctl start mysqld;systemctl enable mysqld"
           ssh root@$ip "grep 'temporary password'  /var/log/mysqld.log|awk '{print \$NF}' >/root/mysqloldpass.txt"
           ssh root@$ip 'mysqladm -uroot -p"`cat /root/mysqloldpass.txt`" password "NEW_PASSWORD"'
           }&
   done <ip.txt
   wait
   echo "all finished"
   
   ```
   
   方式二：
   
   ```shell
   #!/bin/bash
   #
   while read ip 
   do
           {
           scp -r mysql_install_2.sh root@$ip:/tmp/   #将本地安装脚本推送过去
           ssh root@$ip "tmp/mysql_install_2.sh"
           }&
   done < ip.txt
   wait
   echo "all finished"
   ```
   
   
   
6. 

   