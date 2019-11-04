1. 分析系统资源性能瓶颈

   脚本功能：

   1. 查看CPU利用率与负载`(top, vmstat, sar)`
   2. 查看磁盘，`Inode`利用率与I/O负载`(df,iostat,iotop,sar,dstat)`
   3. 查看内存利用率`(free,vmstat)`
   4. 查看TCP链接状态`（netstat,ss）`
   5. 查看CPU与内存占用最高的10个进程`（top,ps）`
   6. 查看网络流量`（ifconfig,iftop,iptraf）`

   补充知识：select语句

   ```shell
   #!/bin/bash
   PS3="Your choice is:"
   select choice in disk_part filesystem  cpuload mem_util quit
   
   do
           case "$choice" in
           disk_part)
                   fdisk -l
                   ;;
           filesystem)
                   df -h
                   ;;
           cpuload)
                   uptime
                   ;;
           mem_util)
                   free -m
                   ;;
           quit)
                   break
                   ;;
           *)
                   echo "error"
                   exit
           esac
   done
   ```

   完整脚本

2. 