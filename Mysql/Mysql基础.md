一、数据库概述

1. 数据库系统`DBS`
   - 数据库管理系统
     - `SQL(RDS)`：
     - `NoSQL`：`Redis,MongoDB,Memcache`
   - `DBA`
2. `SQL`语言
   - `DDL`：数据库定义语言：数据库，表，试图，索引，存储过程，函数，`create drop alter`
   - `DML`：数据库操纵语言：插入数据、删除数据、更新数据
   - `DQL`：数据库查询语言：查询数据
   - `DCL`：数据库控制语言：例如控制用户的访问权限grant，revoke
3. 数据库访问技术
   - `ODBC`
   - `JDBC`

二、安装`Mysql`

1. 二进制rpm----`YUM`安装

   `wget wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm`

   `rpm -ivh mysql57-community-release-el7-10.noarch.rpm`

   `yum list |grep '^mysql' |grep server`

   `yum install -y mysql-community-server.x86_64`

   获取初始密码

   `grep 'pass' /var/log/mysqld.log`

   `mysql -uroot -p`

2. 二进制预编译包

3. 源码编译安装