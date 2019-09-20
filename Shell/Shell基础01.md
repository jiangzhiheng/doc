1. ### **概述**

   - 自动化批量系统初始化（update，软件安装，时区设置，安全策略）

   - 自动化批量软件部署程序（LAMP/LNMP/Tomcat/LVS/Nginx）

   - 管理应用程序（KVM，集群管理扩容，Mysql）

   - 日志分析处理程序（PV，UV，grep/awk）

   - 自定话备份恢复程序（MySQL完全备份，增量备份）

   - 自动化管理程序（批量远程修改密码，软件升级，配置更新）

   - 自动化信息采集及监控程序（收集系统/应用状态信息，CPU，Memory，DIsk，network，TCPstatus）

   - 自动化扩容（增加云主机---->部署应用）

     zabbix监控CPU 80%+   Python API AWS(增加/删除云主机)+ Shell Scripts（业务上线）

2. ### **程序语言执行**

   程序的组成：逻辑 + 数据

   - C
   - Java
   - Shell
   - Python

   Shell中调用Python程序

   ```shell
   #!/bin/bash
   #
   ping -c1 www.baidu.com &>/dev/null && echo "www.baidu.com is ok" || echo "www.baidu.com is down!"
   
   /usr/bin/python <<-EOF
   print "hello world"
   print "hello world"
   print "hello world"
   EOF
   
   ```

   

3. ### **Shell特性**

   1. login Shell  和nologin Shell

      - login

        su - USERNAME 时执行以下文件

        `/etc/profile    /etc/bashrc   ~/.bash_profile    ~/.bashrc`

      - nologin

        su   USERNAME 时执行以下文件

        `/etc/bashrc     ~/.bashrc`

      - 退出Shell时执行

        `~/.bash_history     ~/.bash_logout`

   2. 命令历史记忆功能

      `!$`  上一条命令的最后一个参数

   3. 前后台作业控制`&   nohup screen  ^C  ^Z  bg   fg `

   4. 输入输出重定向

   5. 管道  |   tee

   6. 命令排序       eject命令（弹出光驱）

      ;    无逻辑判断，顺序执行命令

      &&     ||    具备逻辑判断

      Tips：

      - command   &    后台执行
      - command   &>   混合重定向（标准输出1，错误输出2）
      - command1   &&  command2     命令排序，逻辑判断

   7. Shell通配符（元字符）

      \* 匹配任意多个字符

      ？匹配任意单个字符

      []  匹配括号中任意一个字符  [a-zA-Z0-9]  [abc]  \[^a-z]

      {}  集合  touch file{1..9}

      ()  在子shell中执行  (umask 077;touch file01)

   8. echo 带颜色输出

      -e   执行转义等特殊字符

      echo -e "\e[1;31mThis is red text\e[0m"    前景色31-37  背景色41-47

4. ### **Shell变量**

   1. 变量的赋值
   
      ```shell
      #!/bin/bash
      # 直接赋值
      ip=www.baidu.com
      
      ping -c1 $ip &>/dev/null
      
      if [ $? -eq 0 ]
      then
              echo "$ip is ok"
      else
              echo "$ip is down!"
      fi
      
      ```
   
      ```shell
      #!/bin/bash
      # 通过read命令读入变量值
      read -p "Please input a ip: " ip
      
      ping -c1 $ip &>/dev/null
      
      if [ $? -eq 0 ]
      then
              echo "$ip is ok"
      else
              echo "$ip is down!"
      fi
      ```
   
      
   
   2. 
   
5. 

   

