一、`Mysql`表操作 `DDL`

1. 概述

   表式数据库存储数据的基本单位，由若干个字段组成，主要用来存储数据记录，表的操作包括创建表，查看表，修改表和删除表。

   - 创建表：`create table`
   - 查看表结构：`desc table,show create table`
   - 表完整性约束：
   - 修改表：`alter table`
   - 复制表：`create table`
   - 删除表：`drop table`

2. 创建表（表的基本操作）

   语法：

   `create table table_name(` 

   `字段1  类型[(宽度) 约束条件],`

   `字段2  类型[(宽度) 约束条件],`

   `字段3  类型[(宽度) 约束条件],`

   `)[存储引擎 字符集];`

   - 在同一张表中，字段名是不能相同
   - 宽度和约束条件可选
   - 字段名和类型是必须的

   ```sql
   mysql> create database school;
   Query OK, 1 row affected (0.00 sec)
   
   mysql> use school;
   Database changed
   mysql> create table student1(
       -> id int,
       -> name varchar(50),
       -> sex enum('m','f'),
       -> age int
       -> );
   Query OK, 0 rows affected (0.06 sec)
   
   mysql> desc student1;
   +-------+---------------+------+-----+---------+-------+
   | Field | Type          | Null | Key | Default | Extra |
   +-------+---------------+------+-----+---------+-------+
   | id    | int(11)       | YES  |     | NULL    |       |
   | name  | varchar(50)   | YES  |     | NULL    |       |
   | sex   | enum('m','f') | YES  |     | NULL    |       |
   | age   | int(11)       | YES  |     | NULL    |       |
   +-------+---------------+------+-----+---------+-------+
   
   ```

3. 向表中插入数据

   `insert into 表名(字段1，字段2，...) values(字段值列表....);`

   ```sql
   # 默认所有字段插入
   mysql> insert into student1 values
       -> (1,'tom','m','19'),
       -> (2,'martin','m','23'),
       -> (3,'lucy','f','18');
   
   # 向指定字段插入
   mysql> insert into student1(name,age) values
       -> ('zhuzhu',19),
       -> ('gougou',23);
   
   ```

4. 表完整性约束

   作用：用于保证数据的完整性和一致性

   |     约束条件      |                             说明                             |
   | :---------------: | :----------------------------------------------------------: |
   | `PRIMARY KEY(PK)` | 表示该字段为该表的主键，可以唯一表示记录，不可以为空`unique+not null` |
   | `FOREIGN KEY(FK)` |         表示该字段为该表的外键，实现表与表之间的关联         |
   |    `NOT NULL`     |                      标识该字段不能为空                      |
   | `UNIQUE KEY(UK)`  | 标识该字段的值是唯一的，可以为空，一个表中可以有多个`unique key` |
   | `AUTO INCREMENT`  |        标识该字段的值自动增长（整数类型，而且为主键）        |
   |     `DEFAULT`     |                      为该字段设置默认值                      |
   |    `UNSIGNED`     |                         无符号，整数                         |
   |    `ZEROFILL`     |                     使用0填充，例如00001                     |

   说明：

   - 是否允许为空，默认NULL，可设置NOT NULL，字段不允许为空，必须赋值

   - 字段是否有默认值，缺省的是NULL，如果插入记录不给字段赋值，此字段使用默认值

     `sex enum('male','famale') not null defaule 'male'`

     `age int unsigned not null default 20`：必须为正值，不允许为空，默认值20

   - 是否是key

     - 主键`primary key`
     - 外键`foreign key`
     - 索引`index unique`

   1. 测试`defaule ,not null`

   ```sql
   mysql> create table student2(
       -> id int not null,
       -> name varchar(50) not null,
       -> sex enum('f','m') default 'm' not null,
       -> age int(10) unsigned default 18 not null,
       -> hobby set('disc','book','music') default 'disc,book' not null
       -> );   
   ```

   2. 测试`unique`

   ```
   
   ```

5. 