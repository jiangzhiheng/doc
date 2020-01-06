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

### **二、Maven配置及使用**

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
     
     `mvn compile` 对maven项目进行编译
     
     ```powershell
     PS E:\java_project01> mvn compile
     [INFO] Scanning for projects...
     [INFO]
     [INFO] -----------------------< java_project01:test01 >------------------------
     [INFO] Building test01 1.0-SNAPSHOT
     [INFO] --------------------------------[ jar ]---------------------------------
     [INFO]
     [INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ test01 ---
     [WARNING] Using platform encoding (GBK actually) to copy filtered resources, i.e. build is platform dependent!
     [INFO] skip non existing resourceDirectory E:\java_project01\src\main\resources
     [INFO]
     [INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ test01 ---
     [INFO] Nothing to compile - all classes are up to date
     [INFO] ------------------------------------------------------------------------
     [INFO] BUILD SUCCESS
     [INFO] ------------------------------------------------------------------------
     [INFO] Total time:  1.882 s
     [INFO] Finished at: 2019-11-14T14:59:53+08:00
     [INFO] ------------------------------------------------------------------------
     ```
     
     

4. 开发工具创建maven项目

5. maven配置文件之settings文件

   maven全局配置文件

   1. `mirrors`标签表示配置镜像位置,配置为阿里镜像站，只需在mirrors标签中添加

   ```xml
       <mirror>
         <id>alimaven</id>
         <name>aliyun maven</name>
         <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
         <mirrorOf>central</mirrorOf>        
       </mirror>
   ```

   2. `localRepository`
   3. `interactiveMode` 表示maven是否需要和用户交互获得输入，默认为true``
   4. `offline`表示maven是否需要在离线模式下运行
   5. `pluginGroups`当插件groupid没有显示提供时，供搜寻插件groupid的列表
   6. `proxy`用于配置不同的代理
   7. `server`仓库的下载和部署是在pom.xml文件中进行定义的，比如说用户名，密码需要访问远程仓库的时候，有时候需要安全认证，这个配置就可以配置在server标签中
   8. `profiles`根据环境参数来调整构建配置的列表

6. maven仓库

   maven把jar包下载下来之后，jar包保存的目录可以自己指定，默认保存在`${user.home}/.m2/repository`

   Tips:

   在maven构建项目的时候，它会帮我们把项目中所需要的一些基础的jar包下载下来，jar包下载的地址由mirrors标签指定，maven仓库实际上指的就是jar包下载下来之后保存的目录

   手动指定本地仓库

   ` <localRepository>E:\MyMavenRepo</localRepository> `

7. maven配置文件之pom.xml文件

   Project Object Model 项目对象模型，唯一表示该项目的

   由`groupId  artifactId  version` 所组成的就可以唯一确定一个项目

   1. 三个必填字段

   - `groupId`标识的项目组（填写公司域名）

   - `artifactId`项目名称

   - `version`版本号

   - 以上三个标签必填的

   2. `dependencies`标签，配置项目组需要的依赖jar包

   3. `properties`定义pom中的一些属性

   4. `build`指定如何构建当前项目的

   5. `source`指定了当前构建的source目录

   6. `plugin`指定了进行构建时使用的插件

   7. `package`标签 指定当前构建项目的类型

      Tips: pom文件是可以继承的，超级pom文件等等，

8. maven依赖

   `dependencies`标签中包含很多`dependency`子节点

   maven项目中想要下载指定的jar包，就需要在`dependency`标签中进行配置

   在`https://mvnrepository.com/` 中搜索需要的配置信息添加到标签中

   例如：

   ```xml
       <!-- https://mvnrepository.com/artifact/org.mybatis/mybatis -->
       <dependency>
         <groupId>org.mybatis</groupId>
         <artifactId>mybatis</artifactId>
         <version>3.4.5</version>
       </dependency>
   ```

   不仅可以把当前指定的jar包下载下来，而且它所依赖的所有jar包都会被下载

   对于同一个maven仓库，已经下载过的jar包，maven不会再次下载，

9. maven插件

   maven实际上是一个依赖插件执行的框架，每个任务都是由插件完成的

   插件类型：

   - Build plugins  在构建时执行，需要在pom.xml文件中配置
   - Reporting plugins  在网站生成过程中执行，也需要在pom.xml文件中执行

   常用的插件列表

   `clean` 项目构建之后用于清理项目的

   `compiler` 编译java源代码的

   `jar` 构建jar文件

   `war` 构建war文件

   `tomcat` ....

   ```xml
     <build>
       <plugins>
         <plugin>
           <groupId>org.apache.maven.plugins</groupId>
           <artifactId>maven-clean-plugin</artifactId>
           <version>2.5</version>
           <configuration></configuration>
         </plugin>
       </plugins>
     </build>
   ```

   

10. maven之archetype

    1. maven本身来说，它会帮我们定义好一些archetype，这些archetype是我们开发中常用的一些项目模板，新建maven项目的时候，只需要选择合适的archetype即可

    2. 自定义archetype

       - pom.xml文件中声明插件

         ```xml
         <build>
         		<plugins>
         		  <plugin>
         			<groupId>org.apache.maven.plugins</groupId>
         			<artifactId>maven-archetype-plugin</artifactId>
         			<version>2.2</version>
         		  </plugin>
         		</plugins>
           </build>
         ```

       - 在项目所在目录执行`mvn archetype:create-from-project`

       - 在target目录中就会生成一个自定义archetype

       - 使用`mvn install `安装自定义archetype

### **三、搭建Maven私服**

1. 搭建maven私服

   nexus

2. maven聚合项目

   聚合项目--多module的maven项目

   maven实际上可以有一个父项目，父项目下有多个子项目

3. maven插件使用之tomcat

   




