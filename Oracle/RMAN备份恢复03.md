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

   

##### 二、自动增量备份Shell脚本

1. 设置控制文件自动备份，控制文件备份位置

2. 控制文件的保留时间

   默认7天

   ```plsql
   control_file_record_keep_time
   SQL> alter system set control_file_record_keep_time=30;
   ```

3. 启用块跟踪

   ```plsql
   SQL> select * from v$block_change_tracking;   #默认为禁用状态
   SQL> alter database enable block change tracking using file '/dbbackup/ctf';
   ```

4. 设置0级备份

   ```bash
   [oracle@db01 ~]$ cd /u01/exec/
   [oracle@db01 exec]$ vim level0.rm
   
   -----------------------------------------------------------------------
   run{
   delete noprompt backupset completed before 'sysdate-14';
   sql 'alter system archive log current';
   backup incremental level 0 format '/dbbackup/%d_inc0_%U' database;
   backup archivelog all format '/dbbackup/%d_arch_%U' delete all input;
   }
   # 如果保留7天，sysdate-14
   -------------------------------------------------------------------------
   ```

5. 设置1级备份

   ```bash
   [oracle@db01 exec]$ vim level1.rmn
   -----------------------------------------------------------------------------
   run{
   delete noprompt backupset completed before 'sysdate-14';
   sql 'alter system archive log current';
   backup incremental level 1 format '/dbbackup/%d_inc1_%U' database;
   backup archivelog all format '/dbbackup/%d_arch_%U' delete all input;
   }
   ```

6. 编写Shell脚本

   ```bash
   Level0备份Shell脚本：
   
   [oracle@db01 exec]$ vim level0.sh
   --------------------------------------------------------------------------------
   #!/bin/bash
   
   echo "=========================================================" >> /dbbackup/level0-1.log
   echo "===============Level0 "`(date +%F)`"=====================" >> /dbbackup/level0-1.log
   echo "===============Level0 RMAN Backup Begin====================" >> /dbbackup/level0-1.log
   
   export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
   export ORACLE_SID=orcdb
   export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
   export NLS_DATE_FORMAT='YYYY-MON-DD HH24:MI:SS'
   
   /u01/app/oracle/product/11.2.0/dbhome_1/bin/rman target / cmdfile /u01/exec/level0.rmn log /dbbackup/level0-1.log append
   
   echo "===============Level0 "`(date +%F)`"======================" >> /dbbackup/level0-1.log
   echo "===============Level0 RMAN Backup End=======================" >> /dbbackup/level0-1.log
   -------------------------------------------------------------------------
   
   
   Level1备份Shell脚本：
   
   [oracle@db01 exec]$ vim level1.sh
   
   -------------------------------------------------------------------------
   #!/bin/bash
   
   echo "=========================================================" >> /dbbackup/level0-1.log
   echo "===============Level1 "`(date +%F)`"=====================" >> /dbbackup/level0-1.log
   echo "=============Level1 RMAN Backup Begin====================" >> /dbbackup/level0-1.log
   
   export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
   export ORACLE_SID=orcdb
   export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
   export NLS_DATE_FORMAT='YYYY-MON-DD HH24:MI:SS'
   
   /u01/app/oracle/product/11.2.0/dbhome_1/bin/rman target / cmdfile /u01/exec/level1.rmn log /dbbackup/level0-1.log append
   
   echo "===============Level1 "`(date +%F)`"======================" >> /dbbackup/level0-1.log
   echo "===============Level1 RMAN Backup End=======================" >> /dbbackup/level0-1.log
   -------------------------------------------------------------------------
   ```

7. 设置crontab任务计划

   ```bash
   crontab -e
   
   # 周日凌晨1点执行0级备份
   0	1	*	*	0 /u01/exec/level0.sh > /dev/null 2&>1
   # 周1-6凌晨1点执行1级备份
   0	1	*	*	1-6 /u01/exec/level1.sh > /dev/null 2&>1
   
   ```

   