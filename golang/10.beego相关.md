1. Beego操作mysql数据库

   ```go
   package models
   
   import (
   	"github.com/astaxie/beego"
   	"github.com/astaxie/beego/logs"
   	"github.com/astaxie/beego/orm"
   	//导入驱动包!!!
   	_ "github.com/go-sql-driver/mysql"
   )
   
   func init()  {
   	/*
   	获取数据库类型，注册数据库驱动
   	*/
   	driverName := beego.AppConfig.String("driverName")
   	orm.RegisterDriver(driverName,orm.DRMySQL)
   	/*
   	连接数据库
   	配置信息存储在app.conf中
   	*/
   	user := beego.AppConfig.String("mysqluser")
   	pwd := beego.AppConfig.String("mysqlpwd")
   	host := beego.AppConfig.String("host")
   	port := beego.AppConfig.String("port")
   	dbname := beego.AppConfig.String("dbname")
   
   	//数据库连接串
   	dbConn := user + ":" + pwd + "@tcp(" + host + port + ")/" + dbname + "?charset=utf8"
   	/*
   	注册数据库
   	*/
   	err := orm.RegisterDataBase("default",driverName,dbConn)
   	if err!= nil{
   		logs.Error("连接接数据库出错")
   		return
   	}
   	logs.Debug("连接数据库成功")
   }
   ```

   ```ini
   appname = myweb
   httpport = 8080
   runmode = dev
   # mysql 配置
   driverName = mysql
   mysqluser = root
   mysqlpwd = 123456
   host = 192.168.1.129
   port = 3306
   dbname = myblogweb
   ```

   