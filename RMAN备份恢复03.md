##### 一、自动全量备份Shell脚本

1. 设置控制文件自动备份，设置备份存放位置

   ```plsql
   CONFIGURE CONTROLFILE AUTOBACKUP ON; 
   CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '/dbbackup/%d-ctrl-%F'; 
   ```

2. 设置备份脚本

   ```bash
   mkdir /u01/exec
   chown -R oracle:oinstall /u01/exec
   chmod -R 755 /u01/exec
   su - oracle
   touch /u01/exec/full.rmn
   
   vim /u01/exec/full.rmn
   ------------------------------------------------------------------
   run{
   delete noprompt backupset completed before 'sysdate-7';
   sql 'alter system archive log current';
   backup format '/dbbackup/%d_full_%U' database;
   backup archivelog all format '/dbbackup/%d_arch_%U' delete all input;
   }
   ------------------------------------------------------------------
   ```

3. 编写Shell脚本

   ```bash
   touch /u01/exec/fulldb.sh
   
   vim /u01/exec/fulldb.sh
   --------------------------------------------------------------------------
   #!/bin/bash
   
   echo "=========================================================" >> /dbbackup/fulldb.log
   echo "===============fulldb "`(date +%F)`"=====================" >> /dbbackup/fulldb.log
   echo "===============Full RMAN Backup Begin====================" >> /dbbackup/fulldb.log
   
   export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
   export ORACLE_SID=orcdb
   export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
   export NLS_DATE_FORMAT='YYYY-MON-DD HH24:MI:SS'
   
   /u01/app/oracle/product/11.2.0/dbhome_1/bin/rman target / cmdfile /u01/exec/full.rmn log /dbbackup/fulldb.log append
   
   echo "===============fulldb "`(date +%F)`"======================" >> /dbbackup/fulldb.log
   echo "===============Full RMAN Backup End=======================" >> /dbbackup/fulldb.log
   --------------------------------------------------------------------------
   ```

4. 创建crontab定时任务

   ```
   [oracle@db01 ~]$ crontab -e
   0	1	*	*	* /u01/exec/fulldb.sh > /dev/null 2&>1
   # 每天凌晨一点执行脚本
   # 2 &> 1 标准错误重定向到标准输出
   
   ```

   