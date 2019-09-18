1. 概述

   - 自动化批量系统初始化（update，软件安装，时区设置，安全策略）

   - 自动化批量软件部署程序（LAMP/LNMP/Tomcat/LVS/Nginx）

   - 管理应用程序（KVM，集群管理扩容，Mysql）

   - 日志分析处理程序（PV，UV，grep/awk）

   - 自定话备份恢复程序（MySQL完全备份，增量备份）

   - 自动化管理程序（批量远程修改密码，软件升级，配置更新）

   - 自动化信息采集及监控程序（收集系统/应用状态信息，CPU，Memory，DIsk，network，TCPstatus）

   - 自动化扩容（增加云主机---->部署应用）

     zabbix监控CPU 80%+   Python API AWS(增加/删除云主机)+ Shell Scripts（业务上线）

2. 程序语言执行

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

   

3. Shell特性

