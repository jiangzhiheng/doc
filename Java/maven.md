### **一、概述**

1. Maven可以做的事：

   - jar包管理
   - 项目的构建与管理

2. Maven介绍

3. Maven有两种形式使用

   - 命令行形式(手动创建Maven项目)
   - 集成开发工具创建Maven项目

4. Maven官网

   `https://maven.apache.org/`

5. Maven下载与安装

   1. 下载

      `https://maven.apache.org/download.cgi`

   2. 安装并添加环境变量

      `JAVA_HOME=C:\Program Files\Java\jdk1.8.0_60`

      `MAVEN_HOME=C:\Program Files\apache-maven-3.6.2`

      将`%MAVEN_HOME%\bin`添加到PATH中

      `mvn -v`测试

6. Maven配置

   复制C:\Program Files\apache-maven-3.6.2\conf\setting.xml文件复制到以下目录，

   `C:\Users\JiangZhiheng\.m2`以当前用户配置文件优先

二、Maven配置及使用

1. Maven目录结构

   `bin` ：maven运行的一些命令脚本

   `boot`：类加载器的一些东西

   `conf`：配置文件及日志文件目录

   `lib`：保存jar包

2. Maven项目目录结构

   项目目录结构，实际上是指的是maven要求你的项目必须的一个目录层次

   约定优于配置`(Convention Over Configuration)`

   要去使用maven帮你进行jar包管理，以及项目的构建和管理等等，你就要遵循maven的规定/约定

   maven要求的工程规定

   

   工程名称：

   - src
     - main
       - java：java源文件 Person.java .....
       - resource：资源存放的文件  structs.xml  application-Content.xml文件等
     - test      ：测试所有到的源文件
       - java
       - resource
   - target：项目输出的目录
   - pom.xml：唯一表示该项目的文件

3. 手动创建maven项目

   E:.
   └─src
       ├─main
       │  ├─java
       │  └─resource
       └─test
        |   ├─java
        |   └─resource

   ​    └─pom.xml

   - 手动创建相关目录，不创建target目录
   - 命令行进入maven工程目录
     1. `mvn compile` 对maven项目进行编译
     2. 

4. 




