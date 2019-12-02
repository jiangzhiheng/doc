一、Http相关

1. http编程

   - Go原生支持http，`import("net/http")`
   - Go的http服务性能和nginx比较接近

   ```go
   //Http Server
   package main
   
   import (
   	"fmt"
   	"net/http"
   )
   
   func Hello(w http.ResponseWriter, r *http.Request) {
   	fmt.Println("Handle Hello")
   	fmt.Fprintf(w, "hello")
   }
   func Login(w http.ResponseWriter, r *http.Request) {
   	fmt.Println("Handle login")
   	fmt.Fprintf(w, "Login")
   }
   
   func main() {
   	http.HandleFunc("/", Hello)
   	http.HandleFunc("/user/login", Login)
   	err := http.ListenAndServe("0.0.0.0:8080", nil)
   	if err != nil {
   		fmt.Println("http listen failed")
   	}
   }
   
   ```

   ```go
   //http client
   package main
   
   import (
   	"fmt"
   	"io/ioutil"
   	"net/http"
   )
   
   func main() {
   	res, err := http.Get("https://www.baidu.com/")
   	if err != nil {
   		fmt.Println("get err ,", err)
   		return
   	}
   	data, err := ioutil.ReadAll(res.Body)
   	if err != nil {
   		fmt.Println("get data err :", err)
   		return
   	}
   	fmt.Println(string(data))
   }
   ```

2. http常见请求方法

   - Get请求
   - Post请求
   - Put请求
   - Delete请求
   - Head请求

   ```go
   package main
   
   import (
   	"fmt"
   	"net"
   	"net/http"
   	"time"
   )
   
   var url = []string{
   	"http://www.baidu.com",
   	"http://www.google.com",
   	"http://www.taobao.com",
   }
   
   func main() {
   	for _, v := range url {
   		//自定义一个Client
   		c := http.Client{
   			Transport: &http.Transport{
   				Dial: func(network, addr string) (net.Conn, error) {
   					timeout := time.Second * 2
   					return net.DialTimeout(network, addr, timeout)
   				},
   			},
   		}
   		//使用自定义客户端
   		resp, err := c.Head(v)
   		//resp,err := http.Head(v)
   		if err != nil {
   			fmt.Printf("head %s failed,err:%v\n", v, err)
   			continue
   		}
   		fmt.Printf("head succ,status:%v\n", resp.Status)
   	}
   }
   
   ```

3. http创建状态码

   - `http.StatusContinue=100`
   - `http.StatusOK=200`
   - `http.StatusFound=302`
   - `http.StatusBadRequest=400`
   - `http.StatusUnauthorized=401`
   - `http.StatusForbidden=403`
   - `http.StatusNotFound=404`
   - `http.StatusInternalServerError=500`

4. 表单处理

   ```go
   package main
   
   import (
   	"io"
   	"net/http"
   )
   
   const form = `<html>
   			<body>
   			<form action="#" method="post" name="bar">
                       <input type="text" name="in"/>
                       <input type="text" name="in"/>
   					<input type="submit" value="Submit"/>
   			</form>
   			</body>
   			</html>`
   
   func SimpleServer(w http.ResponseWriter, request *http.Request) {
   	io.WriteString(w, "<h1>hello, world</h1>")
   }
   
   func FormServer(w http.ResponseWriter, request *http.Request) {
   	w.Header().Set("Content-Type", "text/html")
   	switch request.Method {
   	case "GET":
   		io.WriteString(w, form)
   	case "POST":
   		request.ParseForm()
   		io.WriteString(w, request.Form["in"][1])
   		io.WriteString(w, "\n")
   		io.WriteString(w, request.FormValue("in"))
   	}
   }
   func main() {
   	http.HandleFunc("/test1", SimpleServer)
   	http.HandleFunc("/test2", FormServer)
   	if err := http.ListenAndServe(":8088", nil); err != nil {
   	}
   }
   
   ```

5. panic处理

   ```go
   package main
   
   import (
   	"log"
   	"net/http"
   )
   
   const form = `<html><body><form action="#" method="post" name="bar">
                       <input type="text" name="in"/>
                       <input type="text" name="in"/>
                        <input type="submit" value="Submit"/>
                </form></html></body>`
   
   //代码省略
   func main() {
   	//	http.HandleFunc("/test1", logPanics(SimpleServer))
   	//	http.HandleFunc("/test2", logPanics(FormServer))
   	if err := http.ListenAndServe(":8088", nil); err != nil {
   	}
   }
   
   func logPanics(handle http.HandlerFunc) http.HandlerFunc {
   	return func(writer http.ResponseWriter, request *http.Request) {
   		defer func() {
   			if x := recover(); x != nil {
   				log.Printf("[%v] caught panic: %v", request.RemoteAddr, x)
   			}
   		}()
   		handle(writer, request)
   	}
   }
   
   ```

6. web模板

   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <title>{{.Title}}</title>
   </head>
   <body>
   {{if gt .Age 18}}
       <p>hello,old man {{.Name}}</p>
   {{else}}
       <p>hello,young man {{.Name}}</p>
   {{end}}
   <p>{{ .}}</p>
   </body>
   </html>
   ```

   ```go
   package main
   
   import (
   	"fmt"
   	"net/http"
   	"text/template"
   )
   
   type Person struct {
   	Name  string
   	Age   int
   	Title string
   }
   
   var myTemplate *template.Template
   
   func userInfo(w http.ResponseWriter, r *http.Request) {
   	p := Person{Name: "Mary", Age: 19, Title: "个人主页"}
   	myTemplate.Execute(w, p)
   }
   func initTemplate(filename string) (err error) {
   	myTemplate, err = template.ParseFiles(filename)
   	if err != nil {
   		fmt.Println("parse file failed:", err)
   		return
   	}
   	return
   }
   
   func main() {
   	initTemplate("F:/goWorks/Project01/src/go_dev/day10/httpTemplate/main/index.html")
   	http.HandleFunc("/user/info", userInfo)
   	err := http.ListenAndServe("0.0.0.0:8080", nil)
   	if err != nil {
   		fmt.Println("http listen failed")
   	}
   }
   
   ```

   - 替换

   - if判断

     `{{ . }}`

     `{{ range . }}`

     `{{ end }}`

二、Mysql相关

1. 登录数据库，创建库，创建表

   ```sql
       CREATE TABLE person (
           user_id int primary key auto_increment,
           username varchar(260),
           sex varchar(260),
           email varchar(260)
       );
   
       CREATE TABLE place (
           country varchar(200),
           city varchar(200),
           telcode int
       );
   ```

2. 连接mysql

   `database, err := sqlx.Open("mysql", "root:@tcp(127.0.0.1:3306)/test")`

3. CRUD操作

   - insert操作

     `r, err := Db.Exec("insert into person(username, sex, email)values(?, ?, ?)", "stu001", "man", "stu01@qq.com")`

   - select操作

     `err := Db.Select(&person, "select user_id, username, sex, email from person where user_id=?", 1)`

   - update操作

     `_, err := Db.Exec("update person set username=? where user_id=?", "stu0001", 1)`

   - delete操作

     `_, err := Db.Exec("delete from person where user_id=?", 1)`

   ```go
   package main
   
   import (
   	"fmt"
   	_ "github.com/go-sql-driver/mysql"
   	"github.com/jmoiron/sqlx"
   )
   
   type Person struct {
   	UserId   int    `db:"user_id"`
   	Username string `db:"username"`
   	Sex      string `db:"sex"`
   	Email    string `db:"email"`
   }
   
   type Place struct {
   	Country string `db:"country"`
   	City    string `db:"city"`
   	TelCode int    `db:"telcode"`
   }
   
   var Db *sqlx.DB
   
   func init() {
   	database, err := sqlx.Open("mysql", "root:123456@tcp(172.16.100.10:3306)/martin")
   	if err != nil {
   		fmt.Println("open mysql failed ", err)
   		return
   	}
   	Db = database
   }
   
   func main() {
   	r, err := Db.Exec("insert into person(username, sex, email)values(?, ?, ?)", "stu001", "man", "stu01@qq.com")
   	if err != nil {
   		fmt.Println("exec failed,", err)
   		return
   	}
   	id, err := r.LastInsertId()
   	if err != nil {
   		fmt.Println("exec failed,", err)
   		return
   	}
   	fmt.Println("insert succ", id)
   }
   
   ```

   ```go
   package main
   
   import (
   	"fmt"
   	_ "github.com/go-sql-driver/mysql"
   	"github.com/jmoiron/sqlx"
   )
   
   type Person struct {
   	UserId   int    `db:"user_id"`
   	Username string `db:"username"`
   	Sex      string `db:"sex"`
   	Email    string `db:"email"`
   }
   
   type Place struct {
   	Country string `db:"country"`
   	City    string `db:"city"`
   	TelCode int    `db:"telcode"`
   }
   
   var Db *sqlx.DB
   
   func init() {
   
   	database, err := sqlx.Open("mysql", "root:123456@tcp(172.16.100.10:3306)/martin")
   	if err != nil {
   		fmt.Println("open mysql failed,", err)
   		return
   	}
   
   	Db = database
   }
   
   func main() {
   
   	_, err := Db.Exec("delete from person where user_id=?", 3)
   	_, err = Db.Exec("delete from person where user_id=?", 6)
   	if err != nil {
   		fmt.Println("exec failed, ", err)
   		return
   	}
   
   	fmt.Println("delete succ")
   }
   
   ```

   ```go
   package main
   
   import (
   	"fmt"
   	_ "github.com/go-sql-driver/mysql"
   	"github.com/jmoiron/sqlx"
   )
   
   type Person struct {
   	UserId   int    `db:"user_id"`
   	Username string `db:"username"`
   	Sex      string `db:"sex"`
   	Email    string `db:"email"`
   }
   
   type Place struct {
   	Country string `db:"country"`
   	City    string `db:"city"`
   	TelCode int    `db:"telcode"`
   }
   
   var Db *sqlx.DB
   
   func init() {
   
   	database, err := sqlx.Open("mysql", "root:123456@tcp(172.16.100.10:3306)/martin")
   	if err != nil {
   		fmt.Println("open mysql failed,", err)
   		return
   	}
   
   	Db = database
   }
   
   func main() {
   
   	var person []Person
   	err := Db.Select(&person, "select user_id, username, sex, email from person where user_id=?", 1)
   	if err != nil {
   		fmt.Println("exec failed, ", err)
   		return
   	}
   
   	fmt.Println("select succ:", person)
   
   }
   
   ```

   ```go
   package main
   
   import (
   	"fmt"
   	_ "github.com/go-sql-driver/mysql"
   	"github.com/jmoiron/sqlx"
   )
   
   type Person struct {
   	UserId   int    `db:"user_id"`
   	Username string `db:"username"`
   	Sex      string `db:"sex"`
   	Email    string `db:"email"`
   }
   
   type Place struct {
   	Country string `db:"country"`
   	City    string `db:"city"`
   	TelCode int    `db:"telcode"`
   }
   
   var Db *sqlx.DB
   
   func init() {
   
   	database, err := sqlx.Open("mysql", "root:123456@tcp(172.16.100.10:3306)/martin")
   	if err != nil {
   		fmt.Println("open mysql failed,", err)
   		return
   	}
   
   	Db = database
   }
   
   func main() {
   
   	_, err := Db.Exec("update person set username=? where user_id=?", "stu0001", 3)
   	if err != nil {
   		fmt.Println("exec failed, ", err)
   		return
   	}
   
   }
   
   ```

   