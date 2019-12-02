一、TCP编程

1. 服务端的处理流程

   - 监听端口
   - 接收客户端的连接
   - 创建goroute，处理该链接

   ```go
   package main
   
   import (
   	"fmt"
   	"net"
   )
   
   func main() {
   	fmt.Println("Start Server...")
   	listen, err := net.Listen("tcp", "0.0.0.0:50000")
   	if err != nil {
   		fmt.Println("Listen Failed,err: ", err)
   	}
   	for {
   		conn, err := listen.Accept()
   		if err != nil {
   			fmt.Println("Accept failed,err:", err)
   			continue
   		}
   		go Process(conn)
   	}
   }
   
   func Process(conn net.Conn) {
   	defer conn.Close()
   	for {
   		buf := make([]byte, 512)
   		n, err := conn.Read(buf)
   		if err != nil {
   			fmt.Println("read err:", err)
   			return
   		}
   		fmt.Println("read:", string(buf[0:n]))
   	}
   }
   ```

2. 客户端的处理流程

   - 简历与服务端的链接
   - 进行数据收发
   - 关闭连接

   ```go
   package main
   
   import (
   	"bufio"
   	"fmt"
   	"net"
   	"os"
   	"strings"
   )
   
   func main() {
   	conn, err := net.Dial("tcp", "localhost:50000")
   	if err != nil {
   		fmt.Println("error dialing", err.Error())
   		return
   	}
   	defer conn.Close()
   	inputReader := bufio.NewReader(os.Stdin)
   	for {
   		input, _ := inputReader.ReadString('\n')
   		trimedImput := strings.Trim(input, "\r\n")
   		if trimedImput == "Q" {
   			return
   		}
   		_, err = conn.Write([]byte(trimedImput))
   		if err != nil {
   			return
   		}
   	}
   }
   ```

3. 发送http请求

二、Redis使用

1. `redis`是个开源的高性能key-value的内存数据库，可以把它当成远程的数据结构。支持的value类型非常多，比如`string，list（链表），set，hash表`等等。`redis`的性能非常高，单机能够达到`15w qps`，通常适合做缓存

2. 链接`redis`

   ```go
   package main
   
   import (
   	"fmt"
   	"github.com/garyburd/redigo/redis"
   )
   
   func main() {
   	c, err := redis.Dial("tcp", "localhost:6379")
   	if err != nil {
   		fmt.Println("conn redis failed,", err)
   		return
   	}
   	defer c.Close()
   }
   
   ```

3. set接口

   ```go
   package main
   
   import (
   	"fmt"
   	"github.com/garyburd/redigo/redis"
   )
   
   func main() {
   	c, err := redis.Dial("tcp", "localhost:6379")
   	if err != nil {
   		fmt.Println("conn redis failed,error:", err)
   		return
   	}
   	defer c.Close()
   
   	_, err = c.Do("Set", "age", "100")
   	if err != nil {
   		fmt.Println(err)
   		return
   	}
   
   	r, err := redis.Int(c.Do("Get", "age"))
   	if err != nil {
   		fmt.Println("Get age failed,", err)
   		return
   	}
   	fmt.Println(r)
   }
   
   ```

4. hash操作

   ```go
   package main
   
   import (
   	"fmt"
   	"github.com/garyburd/redigo/redis"
   )
   
   func main() {
   	c, err := redis.Dial("tcp", "localhost:6379")
   	//建立连接
   	if err != nil {
   		fmt.Println("conn redis failed,err:", err)
   		return
   	}
   	defer c.Close()
   	//redis关闭句柄
   	_, err = c.Do("HSet", "books", "abc", 123)
   	if err != nil {
   		fmt.Println(err)
   		return
   	}
   	r, err := redis.Int(c.Do("HGet", "books", "abc"))
   	if err != nil {
   		fmt.Println("abc get faied", err)
   		return
   	}
   	fmt.Println(r)
   }
   
   ```

5. 批量set

   ```go
   package main
   
   import (
   	"fmt"
   	"github.com/garyburd/redigo/redis"
   )
   
   func main() {
   	c, err := redis.Dial("tcp", "localhost:6379")
   	if err != nil {
   		fmt.Println("conn redis failed,err:", err)
   		return
   	}
   	defer c.Close()
   	_, err = c.Do("MSet", "abc", 100, "seg", 300)
   	if err != nil {
   		fmt.Println(err)
   		return
   	}
   
   	r, err := redis.Ints(c.Do("MGet", "abc", "seg"))
   	if err != nil {
   		fmt.Println("get data failed,", err)
   		return
   	}
   	for _, v := range r {
   		fmt.Println(v)
   	}
   	//fmt.Println(r)
   }
   
   ```

6. 过期时间

   ```go
   package main
   
   import (
   	"fmt"
   	"github.com/garyburd/redigo/redis"
   	"time"
   )
   
   func main() {
   	c, err := redis.Dial("tcp", "localhost:6379")
   	//建立连接
   	if err != nil {
   		fmt.Println("conn redis failed,err:", err)
   		return
   	}
   	defer c.Close()
   	//redis关闭句柄
   	_, err = c.Do("SET", "mykey", "jiangzhiheng", "EX", "5")
   	//set k-v并设置过期时间
   	if err != nil {
   		fmt.Println("redis set failed:", err)
   	}
   
   	username, err := redis.String(c.Do("GET", "mykey"))
   	if err != nil {
   		fmt.Println("redis get failed:", err)
   	} else {
   		fmt.Printf("Get mykey: %v \n", username)
   	}
   
   	time.Sleep(8 * time.Second)
   
   	username, err = redis.String(c.Do("GET", "mykey"))
   	if err != nil {
   		fmt.Println("redis get failed:", err)
   	} else {
   		fmt.Printf("Get mykey: %v \n", username)
   	}
   }
   
   ```

7. `redis_pool`

   ```go
   package main
   
   import (
   	"fmt"
   	"github.com/garyburd/redigo/redis"
   )
   
   var pool *redis.Pool
   
   func init() {
   	pool = &redis.Pool{
   		MaxIdle:     16,
   		MaxActive:   0,
   		IdleTimeout: 300,
   		Dial: func() (conn redis.Conn, e error) {
   			return redis.Dial("tcp", "localhost:6379")
   		},
   	}
   }
   
   func main() {
   	c := pool.Get()
   	defer c.Close()
   	_, err := c.Do("Set", "abc", 100)
   	if err != nil {
   		fmt.Println(err)
   		return
   	}
   	r, err := redis.Int(c.Do("Get", "abc"))
   	if err != nil {
   		fmt.Println("Get abc failed", err)
   		return
   	}
   	fmt.Println(r)
   	pool.Close()
   }
   ```

