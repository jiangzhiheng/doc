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

