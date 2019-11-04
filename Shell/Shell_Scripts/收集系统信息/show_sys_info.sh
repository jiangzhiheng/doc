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



