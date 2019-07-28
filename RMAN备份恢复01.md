

##### 一、RMAN备份与恢复概述

1. RAMAN（Recovery Manager）恢复管理器，Oracle专用备份恢复工具，是一种用于备份，还原，恢复的工具。
   第三方备份软件，比如赛门铁克、NBU、TSM都是掉用RMAN的脚本来执行。

2. 为什么要备份？
   备份和恢复的主要目的就是避免数据库的数据丢失恢复数据。
   跨机房备份，跨地区备份，异机备份

3. 数据库的故障类型：
   介质故障（硬件损坏）
   用户错误（应用程序逻辑错误或者手动错误导致数据库的数据更改错误）
   应用程序错误（软件故障会损坏数据块）

4. 备份方式：
   物理备份：rman
   能够实现任意时间点的恢复
   逻辑备份：
   exp-imp
   expdp-impdp

##### 二、使用RMAN

1. Oracle的备份类型
   - 物理备份：
     RMAN实际上是物理备份，能够实现任意时间点的恢复
   - 逻辑备份：
     exp/imp
     expdp/impdp（数据泵工具）
     无法达到任意时间点
     archivelog模式，归档模式
     noarchivelog模式，非归档模式
     RMAN都可以执行脱机备份

​        如果数据库处于归档模式，RMAN既可以做脱机备份（冷备份），也可以做联机备份（热备份）
​        如果数据库处于非归档模式，RMAN是不能进行热备份

2. 使用RMAN
```plsql
   服务器端使用RMAN
   [oracle@db01 ~]$ rman target / 
   [oracle@db01 ~]$ rman target / nocatlog
   客户端使用RMAN
   rman target sys/password@IP:port/service_name
   Tips:RMAN连接的账户必须具有dba权限

查看以及修改日志模式
SQL> select log_mode from v$database;
SQL> archive log list;

参数：

- 归档的位置
  log_archive_dest
  新建归档日志存放目录：
  [root@db01 ~]# mkdir /archive
  [root@db01 ~]# chown -R oracle:oinstall /archive
  [root@db01 ~]# chmod -R 755 /archive
  设置归档位置
  SQL> alter system set log_archive_dest_1 = 'location=/archive' scope=spfile;
  Tips：重启数据库生效				

- 归档文件名的格式
  log_archive_format
  %t_%s_%r.arch
  %t:线程号
  %s:日志序列号
  %r:resetlog id
  %d:databases id

SQL> alter system set log_archive_format='%t_%s_%r.arch' scope=spfile;
SQL> shutdown immediate
SQL> startup mount
SQL> alter database archivelog;
SQL> alter database open;
SQL> alter system switch logfile;
```
3. 在归档模式和非归档模式下备份数据库
   1. 一致性备份
      当数据库 处于一致性状态的时候得备份就是一致性备份，
      当数据库关闭状态为一致性状态。
      shutdown immediate 
      shutdown normal
      shutdown transactional
      shutdown abort不是一致性状态
      脱机备份
   2. 非一致性备份
      当数据库处于非 一致状态的备份就是非一致性备份
      实例失败，shutdown abort
      数据库打开的时候进行的备份是非一致性备份
      归档模式
   
3. 非归档模式备份数据库
   
   ```plsql
   禁用归档模式
   shutdown immediate
   startup mount
   alter database noarchivelog；
   alter database open;
   RMAN备份：
   shutdown immediate
   startup mount 		打开spfile，控制文件
   [oracle@db01 ~]$ rman target /
   RMAN> backup database;
   
   指定备份路径备份：
   [root@db01 ~]# mkdir /dbbackup
   [root@db01 ~]# chown -R oracle:oinstall /dbbackup
   [root@db01 ~]# chmod 755 /dbbackup -R
   
   RMAN> backup tag 'full_db_bkp' format '/dbbackup/db_%U' database;
   %U：确定的唯一的文件名称。
   
   修改控制文件保存天数（默认为7天，改为30天）
   SQL> alter system set control_file_record_keep_time=30;
   ```
   
   ```
   
   ```
4. 归档模式备份数据库
```plsql
      启用归档模式：
      SQL> alter database archivelog;
      RMAN备份：open状态
      RMAN> backup database;
   
Tips：如果备份含有system表空间的文件，将会自动备份控制文件和spfile。

   RMAN> backup database plus archivelog;  同时备份归档文件。
```

   

4. list-report命令
      	
   
   1. list命令：
   
      ```plsql
      list backup;
      list backupset;
      添加环境变量，设置时间显示格式：
      export NLS_DATE_FORMAT='YYYY-MON-DD HH24:MI:SS'	
      	
      list copy; 列出映像副本；
      	
      列出包含数据文件的备份集；
      list backup of datafile 1;
      
      列出指定序号的备份集；
      list backupset 6;
      
      列出所有的归档文件
      list archivelog all;
      
      列出包含users表空间的备份集；
      list backup of tablespace users;
      list backupset by file;
      list backup summary;	
      ```
   
      
   
      
   
      2. report命令
         查看哪些文件需要备份？
         	
         在那些文件上执行了不可恢复的操作
         RMAN> report unrecoverable;
         	
         查看备份过时的信息
         查看哪些文件最近没有备份
         	

	```plsql
1.查看构成数据库组成的文件
RMAN> report schema;
using target database control file instead of recovery catalog
Report of database schema for database with db_unique_name ORCDB
	
			List of Permanent Datafiles
			===========================
			File Size(MB) Tablespace           RB segs Datafile Name
			---- -------- -------------------- ------- ------------------------
			1    750      SYSTEM               ***     /u01/app/oracle/oradata/orcdb/system01.dbf
			2    600      SYSAUX               ***     /u01/app/oracle/oradata/orcdb/sysaux01.dbf
			3    845      UNDOTBS1             ***     /u01/app/oracle/oradata/orcdb/undotbs01.dbf
			4    5        USERS                ***     /u01/app/oracle/oradata/orcdb/users01.dbf
	
			List of Temporary Files
			=======================
			File Size(MB) Tablespace           Maxsize(MB) Tempfile Name
			---- -------- -------------------- ----------- --------------------
			1    59       TEMP                 32767       /u01/app/oracle/oradata/orcdb/temp01.dbf
	```


​	
```plsql
		2.查看需要备份的文件
			RMAN> report need backup;
		RMAN retention policy will be applied to the command
		RMAN retention policy is set to redundancy 1
		Report of files with less than 1 redundant backups
		File #bkps Name
		---- ----- -----------------------------------------------------
		1    0     /u01/app/oracle/oradata/orcdb/system01.dbf
		2    0     /u01/app/oracle/oradata/orcdb/sysaux01.dbf
		3    0     /u01/app/oracle/oradata/orcdb/undotbs01.dbf
		4    0     /u01/app/oracle/oradata/orcdb/users01.dbf

		3.列出三天未备份的对象

		RMAN> report need backup days 3;

		4.列出需要三个备份的所有文件
		RMAN> report need backup redundancy 3;

		5.列出哪个表空间需要备份
		RMAN> report need backup tablespace users;

		6.列出违反保留策略的备份集
		RMAN> report obsolete;
```

5. 备份概念

   1. 热备：数据库open状态下的备份（归档模式下）联机备份
   2. 冷备：数据库shutdown状态下的备份（归档，非归档）脱机备份

      1. cp
   
      ```plsql
      	数据文件（包括undo文件）3
      SQL> select * from v$dbfile;
      控制文件	
      SQL> show parameter control;
      SQL> select * from v$controlfile;
      spfile
      SQL> show parameter spfile;
      	redo联机重做日志文件
      SQL> select * from v$logfile;
      临时文件	
      	SQL> select * from v$tempfile;
      	拷贝的时候先关闭数据库
      ```
   
   2.rman
      启动数据库到mount状态
      RMAN> backup database;	
   
   3. 备份集
   逻辑概念
   4. 备份片	
   一个备份集包含多个备份片(默认情况下一个备份集由一个备份片组陈)
   设置默认备份片size：
   RMAN> configure channel device type disk maxpiecesize 200m;
   
5. crosscheck交叉检查
      
      ```plsql
      RMAN> crosscheck backupset;
      RMAN> delete expired backupset;
      delete expired:不删除任何文件，只更新RMAN的存储库
      delete obsolete：将文件删除并更新RMAN存储库
      RMAN> delete noprompt backupset;无提示信息直接删除，用于脚本中
      ```
      
      ​	

6.手工注册备份集和归档日志

```plsql
[oracle@db01 2019_07_03]$ mv o1_mf_nnndf_TAG20190703T235813_gkv8w5yk_.bkp /dbbackup/user01.bkp
RMAN> crosscheck backupset;
RMAN> delete backupset;
  注册单个备份片
  catalog backuppiece '/dbbackup/user01.bkp'
  注册整个目录
  RMAN> catalog start with '/dbbackup/';
  	
  注册归档文件
  注册单个归档文件
  SQL> alter database register physical logfile '/archive/arc/1_75_1011938106.arch'
  	
  注册整个目录
  RMAN> catalog start with '/archive/arc/'
```

6.使用validate验证数据库
      rman命令，验证的目的主要是为了检查损坏的块和丢失的文件。
      验证备份集是否可以用来做恢复
      验证数据文件是否损坏，坏块
      	

```plsql
rman验证有三种方式：
1.validate
2.backup ... validate
3.restore ... validate
  1.validate
  RMAN> validate database;
  RMAN> validate tablespace users;
  RMAN> validate tablespace system;
  RMAN> validate datafile 1;
  	
  RMAN> validate archivelog all;
  	
  验证数据文件单个数据块block是否损坏
  RMAN> validate datafile 1 block 10;
  	
  RMAN> validate backupset 13;
  	
  验证数据文件是否损坏
  SQL> select * from v$dbfile;
  [oracle@db01 ~]$ cd /u01/app/oracle/oradata/orcdb/
  [oracle@db01 orcdb]$ dbv file=system01.dbf
  	
  关于校验和损坏块
  db_block_checksum=typical
  用于数据库中数据文件和redo文件中块的校验和写入
  数据库在正常操作期间为每一个块计算校验和，将其写入块的头部
  当数据库从磁盘中读取块的时候，会重新计算校验和，与之前存储的进行比对，如果不匹配，则视为损坏
  	
  物理和逻辑块损坏
  物理损坏，数据库根本无法识别该块：
  校验和无效，块中全部是0，块的header和footer不匹配
  逻辑损坏，块的内容在逻辑上不一致，例如行片损坏，索引条目损坏
  默认情况下，rman不检查逻辑坏块。
  RMAN> validate check logical database;
  
  2.backup ... validate
  不做任何实际备份
  RMAN> backup validate database;	
  RMAN> backup validate check logical database;
  RMAN> backup validate archivelog;
  RMAN> backup validate database archivelog all;
	
  3.restore ... validate	
  RMAN> restore database validate; #验证数据库能否用来恢复
  RMAN> restore datafile 1 validate;
	
```

7.delete-obsolete

```plsql
delete:删除备份
备份集 
RMAN> delete backupset; delete backup;
RMAN> delete noprompt backupset;	
RMAN> delete backupset 16; #删除指定备份集
	
RMAN> report obsolete; # 报告过期的备份，违反保留策略的备份
RMAN> delete obsolete;
RMAN> delete archivelog all;
```

8.备份spfile-控制文件，归档文件，映像副本
	

```plsql
1.备份spfile
RMAN> backup spfile;
2.备份控制文件
RMAN> backup current controlfile;
spfile和控制文件自动备份
CONFIGURE CONTROLFILE AUTOBACKUP OFF;
CONFIGURE CONTROLFILE AUTOBACKUP ON;
设置自动备份的存放位置：
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '/dbbackup/ctl-%F';
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK clear;	#清楚配置
	
3.备份归档日志
backup database plus arcivelog all;
backup archivelog all delete all input;
	
4.使用映像副本
backup as copy database;
backup as copy datafile 4 format '/dbbackup/users01.bak'
	
```



9. configure配置RMAN

```plsql
配置备份保留策略
备份到磁盘|磁带
配置默认存储类型
RMAN> show all; 查看当前配置
SQL> select * from v$rman_configuration; 查看已修改的配置（记录到该视图中）
RMAN> configure default device type to sbt; 设置默认存储介质为磁带
RMAN> configure default device type clear; 清除配置，恢复默认

配置冗余策略
CONFIGURE RETENTION POLICY TO REDUNDANCY 2;
	
配置备份的默认类型：备份集或映像副本
RMAN> configure device type disk backup type to copy;	
RMAN> configure device type disk backup type ["backupset, compressed, copy"]
	
配置channel
默认情况下，rman为所有操作分配一个磁盘通道
RMAN> configure channel device type disk format '/dbbackup/db_%U';
RMAN> configure channel device type disk format '+DATA1/db_%U'; #ASM磁盘设置

配置并行备份
RMAN> configure device type disk backup type to compressed backupset parallelism 2;
	
配置优化：
CONFIGURE BACKUP OPTIMIZATION ON;
	
run块
{  
ALLOCATE CHANNEL c1 DEVICE TYPE disk;  
backup tablespace users;
}
```