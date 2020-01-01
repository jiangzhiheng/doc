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

   `wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz`

   ```shell
   groupadd mysql
   useradd -r -g mysql -s /bin/false mysql
   cd /usr/local
   tar xvf /root/mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz
   ln -s mysql-5.7.28-linux-glibc2.12-x86_64 mysql
   
   #mysql初始化
   cd /usr/local/mysql
   mkdir mysql-files
   chmod 750 mysql-files
   chown -R mysql.mysql /usr/local/mysql
   bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
   bin/mysql_ssl_rsa_setup --datadir=/usr/local/mysql/data
   chown -R root /usr/local/mysql
   chown -R mysql data mysql-files
   
   a+fq<1veEysa
   PeyQNs(Mj2>m
   #建立配置文件
   vim /etc/my.cnf
   [mysqld]
   basedir=/usr/local/mysql
   datadir=/usr/local/mysql/data
   
   #启动mysql
   #方法1
   bin/mysqld_safe --user=mysql &
   #方法2
   cp support-files/mysql.server /etc/init.d/mysqld
   chmod a+x /etc/init.d/mysqld
   chkconfig --add mysqld
   chkconfig mysqld on
   service mysqld restart
   
   echo "export PATH=$PATH:/usr/local/mysql/bin" >> /etc/profile
   source /etc/profile
   mysql -uroot -p
   
   mysql> alter user root@'localhost' identified by '123456';
   ```

   如果出错需要重新初始化

   ```shell
   killall mysqld
   rm -rf /usr/local/data
   chown -R mysql.mysql /usr/local/mysql
   bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
   bin/mysql_ssl_rsa_setup --datadir=/usr/local/mysql/data
   chown -R root /usr/local/mysql
   chown -R mysql data mysql-files
   ```

3. 源码编译安装

   1. 准备编译环境

      `yum -y install ncurses ncurses-devel openssl-devel bison gcc gcc-c++ make cmake`

   2. 获取源码包，boost包

      `https://dev.mysql.com/downloads/mysql/`

      `wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.28.tar.gz`   不含有boost，需要单独安装boost

      `wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.28.tar.gz`  使用自带boost的包

   3. 编译安装

      ```shell
      groupadd mysql
      useradd -r -g mysql -s /bin/false mysql
      tar -xf mysql-boost-5.7.28.tar.gz
      cd mysql-5.7.28
      [root@mysql01 mysql-5.7.28]# cmake . \
       -DWITH_BOOST=boost/boost_1_59_0/ \
       -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
       -DSYSCONFDIR=/etc \
       -DMYSQL_DATADIR=/usr/local/mysql/data \
       -DINSTALL_MANDIR=/usr/share/man \
       -DMYSQL_TCP_PORT=3306 \
       -DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
       -DDEFAULT_CHARSET=utf8 \
       -DEXTRA_CHARSETS=all \
       -DDEFAULT_COLLATION=utf8_general_ci \
       -DWITH_READLINE=1 \
       -DWITH_SSL=system \
       -DWITH_EMBEDDED_SERVER=1 \
       -DENABLED_LOCAL_INFILE=1 \
       -DWITH_INNOBASE_STORAGE_ENGINE=1
      
      make && make install
      
      #编译完成后参考二进制安装方法进行初始化配置即可
      ```


三、`Mysql`基本使用

1. `Mysql`忘记密码

   ```shell
   # Mysql 5.7.5 and earlier:
   vim /etc/my.cnf
   [mysqld]
   skip-grant-tables
   
   service mysqld restart
   mysql
   mysql> update mysql.user set password=password("123456") where user="root" and host="localhost";
   mysql> flush privileges;
   mysql> quit
   vim /etc/my.cnf
   [mysqld]
   #skip-grant-tables
   service mysqld restart
   
   #Mysql 5.7.6 and later
   vim /etc/my.cnf
   [mysqld]
   skip-grant-tables
   systemctl restart mysqld
   mysql> select user,host,authentication_string from mysql.user;
   mysql> update mysql.user set authentication_string=password('jjj123456') where user='root';
   mysql> flush privileges;
   
   vim /etc/my.cnf
   [mysqld]
   #skip-grant-tables
   service mysqld restart
   ```

   

