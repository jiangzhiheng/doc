#### RMAN高级备份恢复

##### 一、配置备份集-备份片-压缩-加密

1. 配置备份集最大大小

   ```plsql
   RMAN> configure maxsetsize to 500m;
   RMAN> configure maxsetsize clear;
   ```

2. 配置备份片的最大大小

   ```plsql
   RMAN> configure channel device type disk maxpiecesize 500m;
   ```

3. 双工备份集

   ```plsql
   RMAN> configure datafile backup copies for device type disk to 2;
   RMAN>  configure datafile backup copies for device type disk clear;
   ```

4. 备份数据库时排除某表空间

   ```plsql
   RMAN> configure exclude for tablespace sysaux;
   RMAN> configure exclude for tablespace sysaux clear;
   RMAN> backup database noexclude;
   ```

5. 配置压缩选项

   RMAN支持的备份集的预压缩处理和二进制压缩

   预压缩块处理：

   - 通过合并每个数据块中的空闲空间，并将该空间设置为二进制0来实现更好的备份压缩

     optimize for load true

   支持的压缩级别：

   - 默认压缩算法
   - 高级压缩算法

   configure compress algorithm 'BASIC|HIGH|MEDIUM|LOW'

   ```
   RMAN> configure device type disk backup type to compressed backupset parallelism 1;
   ```


##### 二、配置备份加密

1. 如果备份集没有加密，只要得到备份集文件，就可以恢复数据。

2. 加密模式：

   - 口令加密模式
   - 透明加密模式（wallet钱包）
   - 混合

3. 口令加密模式

   ```plsql
   SQL> select * from v$rman_encryption_algorithms;  查看当前加密位数，默认AES128
   # 对称加密算法，RMAN加密是CPU密集型操作，可能会对性能有影响
   RMAN> set encryption on identified by "oracle" only; 	# 设置密码为oracle
   RMAN> backup datafile 4;
   
   #恢复：
   RMAN> startup mount
   RMAN> set decryption identified by "oracle";
   RMAN> restore datafile 4;
   RMAN> recover datafile 4;
   
   Tips
   可以把备份集拿到异机恢复
   ```

4.透明加密模式wallet

```plsql
SQL> select * from v$encryption_wallet;
# 创建wallet目录
[oracle@db01 ~]$ mkdir -p /u01/app/oracle/admin/orcdb/wallet
# 设置密钥
SQL> alter system set encryption key identified by "oracle";

Tips：
关闭wallet：
alter system set wallet close identified by "oracle";
打开钱包：
alter system set wallet open identified by "oracle";

RMAN配置：
RMAN> configure encryption for database on;
备份数据库

Tips：这种在本机还原时不用输入密码,wallet自动解密无法异机恢复
适用于本地本机还原

```

5. 混合模式

   ```plsql
   set encryption on identified by "oracle";
   
   set decryption identified by "oracle";
   或者
   把钱包打开
   alter system set wallet open identified by "oracle";
   既可以在本机恢复，也可以在异机恢复。
   ```

   

##### 三、执行数据库恢复

前提：

	1. 数据库必须是归档模式
 	2. 有RMAN备份

- 恢复情形一

  如何在丢失一个或多个数据文件后使用RMAN使数据库恢复正常运行
  
  数据文件：undo,system, users
  
  控制文件：不考虑
  
  redo文件：不考虑
  
  参数文件：spfile，pfile，不考虑
  
  临时文件：不考虑，RMAN不备份临时文件
  
  监听：有或没有都行
  
  ```plsql
  实验：
  RMAN> set encryption on identified by "oracle" only;  #设置备份加密
  RMAN> backup format '/dbbackup/full_%U' database;
  删除数据文件（数据文件位置可通过v$dbfile，dba_data_files等视图查看）
  [oracle@db01 orcdb]$ rm sysaux01.dbf 
  [oracle@db01 orcdb]$ rm users01.dbf 
  [oracle@db01 orcdb]$ rm system01.dbf 
  [oracle@db01 orcdb]$ rm undotbs01.dbf
  shutdown数据库
  SQL> shutdown abort;
  -------------------------------------------------------------------------------
  启动：
  spfile-->mount(寻找控制文件，control_file，成功)--->open状态（失败）
  SQL> select status from v$instance;
  
  STATUS
  ------------------------
  MOUNTED
  ----------------------------------------------------------------------------
  恢复：
  置于mount状态，
  恢复文件restore
  介质恢复recover，应用归档日志，redo日志
  recover database;
  
  restore database (删除了所有文件)
  restore datafile '/xxxx/xxx/xx.dbf'
  restore datafile 1; 删除了部分文件的时候
  
  RMAN> set decryption identified by "oracle";
  RMAN> restore database;
  RMAN> recover database;
  SQL> alter database open;
  ```
  
  ```plsql
  RMAN> run{
  restore database;
  recover database;
  }
  SQL> alter database open;
  ```
  
  数据文件的原始位置空间满，恢复的时候不想恢复到这个位置
  
  /u01/app/oracle/oradata/orcdb/
  
  /u01/app/oracle/oradata/orcdb2/
  
  ```plsql
  RMAN> run{
  set newname for datafile 1 to '/u01/app/oracle/oradata/orcdb2/system01.dbf';
  set newname for datafile 2 to '/u01/app/oracle/oradata/orcdb2/sysaux01.dbf';
  set newname for datafile 3 to '/u01/app/oracle/oradata/orcdb2/undotbs.dbf';
  set newname for datafile 4 to '/u01/app/oracle/oradata/orcdb2/users.dbf';
  restore database;
  switch datafile all;
  recover database;
  }
  
  SQL> alter database open;
  ```
  
  
  
- 恢复情形二

  恢复到某个时间点

  ```plsql
  1. RMAN备份
  2019-JUL-18 18:56:19    #rman完整备份时间
  2.创建用户，表，插入数据
  SQL> create user test identified by test;
  SQL> grant connect,resource to test;
  SQL> alter user test quota unlimited on users;
  SQL> conn test/test
  SQL> create table test_tbs(id int);
  ****************************************************
  SQL> select sysdate from dual;
  SYSDATE
  -----------------------
  2019-JUL-21 18:54:22      #创建表时间
  ****************************************************
  SQL> insert into test_tbs select level from dual connect by level<=5000;  插入5000行数据
  SQL> commit;
  SQL> select sysdate from dual;
  
  SYSDATE
  -----------------------
  2019-JUL-21 18:59:16         #提交数据时间
  ****************************************************
  SQL> delete from test_tbs;    #删除所有数据
  SQL> commit;
  
  
  #############################恢复过程#####################################
  恢复至提交数据时间
  SQL> conn / as sysdba
  SQL> shutdown immediate;
  SQL> startup mount;
  
  run{
  set until time "to_date('2019-JUL-21 18:59:16','YYYY-MON-DD HH24:MI:SS')";
  restore database;
  recover database;
  }
  
  SQL> alter database open resetlogs;
  至此，数据恢复完成，使用resetlogs打开数据库后需要重新进行rman备份。
  
  
  ```
  
  

##### 四、使用DataRecoveryAdvisor恢复数据

恢复指导，是一款oracle数据库工具，自动故障诊断，提供适当的恢复建议，修复

- 恢复情形

  如何在丢失一个或多个数据文件后使用RMAN使数据库恢复正常运行

  ```plsql
  1.备份数据库
  backup database；
  2.删除数据文件
  rm 数据文件
  [oracle@db01 orcdb]$ rm system01.dbf 
  [oracle@db01 orcdb]$ rm users01.dbf  
  [oracle@db01 orcdb]$ rm sysaux01.dbf 
  SQL> shutdown abort
  3.startup mount
  RMAN> list failure; 查看failure项，需要触发才会有输出
  RMAN> list failure;
  
  List of Database Failures
  =========================
  
  Failure ID Priority Status    Time Detected        Summary
  ---------- -------- --------- -------------------- -------
  202        CRITICAL OPEN      2019-JUL-22 18:47:27 System datafile 1: '/u01/app/oracle/oradata/orcdb/system01.dbf' is missing
  45         HIGH     OPEN      2019-JUL-22 18:47:27 One or more non-system datafiles are missing
  
  RMAN> list failure;    查看failure建议
  RMAN> repair failure preview;   查看修复过程
  RMAN> repair failure;   执行恢复
  
  
  Tips：
  	1.数据库mount状态
  	2.尽量使用恢复知道工具进行恢复
  ```

##### 五、增量备份

1. 使用快跟踪加速备份

​    Block Change Tracking块跟踪，主要用于RMAN的增量备份，记录自上一次备份以来数据库的变化，标识更改的块进行            增量备份，CTWR（change tracking writer）进程，只读取改变的内容，不需要对整个数据库进行扫描，从而提高RMAN的备份性能

```plsql
SQL> select * from v$block_change_tracking;   #默认为禁用状态
SQL> alter database enable block change tracking using file '/dbbackup/ctf';  启用该功能并指定记录文件

[oracle@db01 ~]$ ps -ef |grep ctwr
oracle     4077      1  0 19:09 ?        00:00:00 ora_ctwr_orcdb
oracle     4148   3465  0 19:11 pts/0    00:00:00 grep --color=auto ctwr
[oracle@db01 ~]$ 
```



2. 增量备份-差异增量备份

    增量备份：

   - 缩短备份时间

   类型：

   - 差异增量备份

     自上一次同级别的差异备份或者是上一次更高级别的备份完成之后的数据库发生改变的数据块。

   - 累计增量备份

   - 增量更新备份（oracle特有）

   backup database：整库备份，不能作为增量策略的一部分。

   backup incremental level 0 database；整库备份，可以作为增量备份的基础。

   归档打开

   非归档，mount下增量备份

   ```plsql
   差异增量备份
   打开块跟踪:
   SQL> alter database enable block change tracking using file '/dbbackup/ctf';
   RMAN> backup incremental level 0 database format '/dbbackup/l0_%U';
   增量备份:
   RMAN> backup incremental level 1 database format '/dbbackup/l1_%U';
   ```

   ```plsql
   累计增量备份
   自上一次上一级备份完成以来数据库改变的数据块
   RMAN> backup incremental level 1 cumulative database format '/dbbackup/lc1_%U';
   
   Tips
   	不要混用
   ```

   ```plsql
   增量更新备份
   run{
   recover copy of database with tag 'incr_update';
   backup incremental level 1 for recover of copy with tag 'incr_update' database;
   }
   执行三次
   1.没有相应的备份集来应用到文件映像上。产生映像文件
   2.产生增量备份集
   3.应用上一次的备份集来恢复文件
   ```

##### 六、基于增量备份的数据恢复

1. 差异增量备份
2. 累计增量备份
3. 增量更新备份

- 周六：0级备份

- 周日-周五：1级备份差异增量备份

  ```plsql
  RMAN> backup incremental level 0 format '/dbbackup/full_%U' database;   #0级备份
  RMAN> backup incremental level 1 format '/dbbackup/level1_%U' database;  #差异增量备份
  RMAN> backup incremental level 1 format '/dbbackup/level1_%U' database;  #差异增量备份
  
  破坏数据库
  [oracle@db01 ~]$ cd /u01/app/oracle/oradata/orcdb/
  [oracle@db01 orcdb]$ rm system01.dbf 
  [oracle@db01 orcdb]$ rm undotbs01.dbf 
  [oracle@db01 orcdb]$ rm users01.dbf 
  [oracle@db01 orcdb]$ rm sysaux01.dbf
  
  恢复数据库
  SQL> shut abort;
  SQL> startup mount
  1.恢复文件
  RMAN> restore database;
  SCN：834126
  SQL> select CHECKPOINT_CHANGE# from v$datafile_header; #查询SCN
  2.recover database；
  应用增量备份集--->归档文件---->日志文件
  
  
  恢复到过去某个时间点
  run{
  set until time "to_date('2019-JUL-21 18:59:16','YYYY-MON-DD HH24:MI:SS')";
  restore database;
  recover database;
  }
  
  SQL> alter database open resetlogs;
  ```

##### 七、Catalog恢复目录管理备份信息

catalog恢复目录就是一个Oracle数据库，用来存储Oracle数据库的备份信息，一个或多个。

- 默认使用控制文件存储备份信息
- control_file_record_keep_time   默认七天
- rman target / 默认使用控制文件存储备份信息

前提：

- dbid必须不一样
- SQL> select dbid from v$database;

修改dbid：

```
mount状态下
[oracle@db03 ~]$ nid target=sys/PASSWORD
SQL> startup mount
SQL> alter database open resetlogs;
```

恢复目录步骤：
```plsql
1.在catalog数据库中创建用户
[oracle@db03 ~]$ sqlplus / as sysdba
SQL> create user rco identified by rco quota unlimited on users;
SQL> grant connect,resource,recovery_catalog_owner to rco;

2.创建恢复目录
在源库rman连接恢复目录
[oracle@db01 ~]$ rman target / catalog rco/rco@172.16.100.12:1521/orcdb
RMAN> create catalog;

3.在恢复目录中注册数据库
RMAN> register database;
手工同步备份信息
resync database；

使用情形：
恢复spfile--->启动到nomount
---->恢复控制文件
```

##### 八、手工制造坏块

创建一个用户，创建表，插入数据

```plsql
创建用户，授权，创建表
SQL> create user jzh identified by jzh;
SQL> grant connect,resource to jzh;
SQL> alter user jzh quota unlimited on users;
SQL> conn jzh/jzh
SQL> create table jzhtbs(name varchar2(50));
插入数据
SQL> begin
  2  for i in 1 .. 5000 loop
  3  insert into jzhtbs values('jzh_test');
  4  end loop;
  5  commit;
  6  end;
  7  /
SQL>select distinct --dbms_rowid.rowid_object(rowid),
dbms_rowid.rowid_relative_fno(rowid),
dbms_rowid.rowid_block_number(rowid)
--dbms_rowid.rowid_row_number(rowid)
from jzh.jzhtbs;    #查询该表对应的块以及文件号。

SQL> conn / as sysdba
SQL> alter system flush buffer_Cache;

提取块：
[oracle@db01 orcdb]$ dd if=users01.dbf of=test.dbf bs=8192 count=1 skip=150 conv=notrunc
破坏快：
[oracle@db01 orcdb]$ dd if=/dev/zero of=users01.dbf bs=8192 count=1 seek=150 conv=notrunc
查询报错：
ERROR:
ORA-01578: ORACLE data block corrupted (file # 4, block # 150)
ORA-01110: data file 4: '/u01/app/oracle/oradata/orcdb/users01.dbf'

检查坏块
1.RMAN> validate datafile 4;
2.[oracle@db01 orcdb]$ dbv file=users01.dbf
3.SQL> select * from v$database_block_corruption;
```

##### 九、快屏幕与块恢复

块恢复：
可以使用块恢复来恢复一个或多个损坏文件块
优点：

1. 降低MTTR平均故障恢复时间，只需恢复损坏的块。
2. 恢复期间，数据文件处于联机状态。
3. 如果没有块恢复，单个块，整个数据文件离线，恢复，online。

前提条件：

1. 必须得有RMAN备份

```plsql
recover datafile 4 block 132;
恢复指导recovery advisor
list failure
advise failure
repair failure preview
repair failure
```

块屏蔽:
没有备份的话，可以屏蔽坏块,其他块不影响。

```plsql
SQL> exec dbms_repair.skip_corrupt_blocks('JZH','JZHTBS');
SQL> select skip_corrupt from dba_tables where table_name='JZHTBS' 
```









