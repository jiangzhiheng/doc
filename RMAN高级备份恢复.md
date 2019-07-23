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
  
  