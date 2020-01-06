一、`Mysql`基本操作

1. `SQL`语言

   `SQL(Struct Query Language)`

   `SQL`语言主要用于存取数据，查询数据，更i性能数据和管理关系数据库系统，`SQL`语言由IBM开发，分为3种类型

   - `DDL`：数据库定义语言，数据库，表，视图，索引，存储过程，例如`create,drop,alter`
   - `DML`：数据库操纵语言，对数据的增删查改等
   - `DCL`：数据库控制语言，例如控制用户的访问权限`grant,revoke`
   - `DQL`：数据库查询语言，查询数据`Select`

2. 系统数据库

   - `information_schema`：虚拟库，主要存储了系统中的一些数据库对象的信息，例如用户表信息，列信息，权限信息，字符信息等
   - `performance_schema`：主要存储数据库服务器的性能参数
   - `mysql`：授权库，主要存储系统用户的权限信息
   - `sys`：主要存储数据库服务器的性能参数

3. 创建业务数据库

   - 创建数据库：`creata database DB_NAME;`
   - 删除数据库：`drop database DB_NAME;`
   - 选择数据库：`use DN_NAME;`
   - 查看当前库：`select database();`

二、`Mysql`数据类型

1. `Mysql`中常见的数据类型

   在`Mysql`数据库管理系统中，可以通过存储引擎来决定表的类型，同时，`Mysql`数据库管理系统也提供了数据类型决定表存储数据的类型，`Mysql`数据库管理系统提供的数据类型：

   - 数值类型
     - 整数类型：`tinyint smallint mediumint int bigint`
     - 浮点数类型：`float double`
     - 定点数类型：`dec`
     - 位类型：`bit`
   - 字符类型
     - char类型：`char varchar`
     - text类型：`tinytext text mediumtext longtext`
     - blob系列：`tinyblob blob mediumblob longblob `
     - binary系列：`binary varbinary`
     - 枚举类型：`enum`
     - 集合类型：`set`
   - 时间和日期类型
     - `date time datatime timestamp year`

2. 数据类型测试

   - 整数类型测试：`tinyint,int`

     作用：用于存储用户的年龄，游戏的Level，经验值等。

     ```sql
     #lab1:
     mysql> create table test1(tint_test tinyint,int_test,int);
     mysql> desc test1;
     +-----------+------------+------+-----+---------+-------+
     | Field     | Type       | Null | Key | Default | Extra |
     +-----------+------------+------+-----+---------+-------+
     | tint_test | tinyint(4) | YES  |     | NULL    |       |
     | int_test  | int(11)    | YES  |     | NULL    |       |
     +-----------+------------+------+-----+---------+-------+
     mysql> insert into test1 values(111,111);
     
     mysql> insert into test1(tint_test) values(128);
     ERROR 1264 (22003): Out of range value for column 'tint_test' at row 1
     # 有符号tinyint类型数据不能超过127  有符号int类型不能超过2147483647
     # 默认有符号，超过存储范围出错
     
     #lab2：无符号整形测试
     mysql> create table test2(
         -> tint_test tinyint unsigned,  //约束条件unsigned限定只能存正值（无符号）
         -> int_test int unsigned
         -> );
     mysql> create table t3(id1 int zerofill,id2 int(8) zerofill);
     # 整形的宽度仅为显示宽度，不是限制，因此建议整型无需指定宽度
     ```

   - 浮点数类型测试：

     作用：用于存储用户的身高，体重，薪水等

     - 浮点数和定点数都可以用类型名称后加`(M,D)`的方式来表示，`(M,D)`表示一共显示M位数字（整数位+小数位），其中D位于小数点后面，M和D又称为精度和标度。

     - `float`和`double`在不指定精度时，默认会按照实际的精度来显示
     - `decimal`在不指定精度时，默认的整数位为10 ，默认的小数位为0
     - 定点数在`mysql`内部以字符串形式存储，比浮点数更精确，适合表示货币等精度高的数据。

     ```sql
     mysql> create table t4(
         -> float_test float(5,2)
         -> );
     mysql> desc t4;
     +------------+------------+------+-----+---------+-------+
     | Field      | Type       | Null | Key | Default | Extra |
     +------------+------------+------+-----+---------+-------+
     | float_test | float(5,2) | YES  |     | NULL    |       |
     +------------+------------+------+-----+---------+-------+
     mysql> insert into t4 values(10.2);
     mysql> insert into t4 values(10.2345);
     mysql> select * from t4;
     +------------+
     | float_test |
     +------------+
     |      10.20 |
     |      10.23 |
     +------------+
     mysql> create table t4(
         -> decimal_test decimal(5.2)
         -> );
     ```

   - 时间和日期类型测试：`year,data,time,datatime,timestamp`

     ```sql
     mysql> create table test_time( d date, t time, dt datetime );
     mysql> desc test_time;
     +-------+----------+------+-----+---------+-------+
     | Field | Type     | Null | Key | Default | Extra |
     +-------+----------+------+-----+---------+-------+
     | d     | date     | YES  |     | NULL    |       |
     | t     | time     | YES  |     | NULL    |       |
     | dt    | datetime | YES  |     | NULL    |       |
     +-------+----------+------+-----+---------+-------+
     mysql> insert into test_time values(now(),now(),now());
     mysql> select * from test_time;
     +------------+----------+---------------------+
     | d          | t        | dt                  |
     +------------+----------+---------------------+
     | 2020-01-02 | 15:14:12 | 2020-01-02 15:14:12 |
     +------------+----------+---------------------+
     
     
     
     mysql> create table timestamp_test( id timestamp );
     mysql> desc timestamp_test;
     +-------+-----------+------+-----+-------------------+-----------------------------+
     | Field | Type      | Null | Key | Default           | Extra                       |
     +-------+-----------+------+-----+-------------------+-----------------------------+
     | id    | timestamp | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
     +-------+-----------+------+-----+-------------------+-----------------------------+
     mysql> insert into timestamp_test values(null);
     
     ```

   - 测试字符串类型：`char varchar`

     - `char`：列的长度固定为创建表时声明的长度：0-255
     - `varchar`：列中的值为可变长度字符串，长度：0-65535

     注：在检索的时候，`char`列删除了尾部的空格，而`varchar`则保留这些空格

     ```sql
     mysql> create table t_char(
         -> c char(5),
         -> v varchar(5)
         -> );
     Query OK, 0 rows affected (0.29 sec)
     
     mysql> insert into t_char values('abc','abc');
     ```

   - 字符串类型

   - `enum`枚举类型，集合类型`set`测试

     - `enum`：单选，只能在给定的范围内选择一个值
     - `set`：多选，在给定的范围内选择一个或一个以上的值

     ```sql
     mysql> create table student(                                                                          
         -> name varchar(50),
         -> sex enum('m','f'),
         -> hobby set('music','book','game','disic')
         -> );
     Query OK, 0 rows affected (0.29 sec)
     
     mysql> desc student;
     +-------+------------------------------------+------+-----+---------+-------+
     | Field | Type                               | Null | Key | Default | Extra |
     +-------+------------------------------------+------+-----+---------+-------+
     | name  | varchar(50)                        | YES  |     | NULL    |       |
     | sex   | enum('m','f')                      | YES  |     | NULL    |       |
     | hobby | set('music','book','game','disic') | YES  |     | NULL    |       |
     +-------+------------------------------------+------+-----+---------+-------+
     3 rows in set (0.00 sec)
     
     mysql> insert into student values('martin','m','book,game');
     ```

