### 一、Goroute

1. 线程和进程

   - 进程是程序在操作系统中的一次执行过程，系统进行资源分配和调度的一个独立单位

   - 线城是一个进程的执行实体，是CPU调度和分配的基本单位，它是比进程更小的独立运行的基本单位
   - 一个进程可以创建和撤销多个线程，同一个进程中的多个线程之间可以并发执行

2. 单线程程序

   多线程程序

3. 并发和并行

   - 多线程程序在一个核心的cpu上执行，就是并发
   - 多线程程序在多个核心的cpu上执行，就是并行

   ```go
   package main
   
   import (
   	"fmt"
   	"time"
   )
   
   func test() {
   	var i int
   	for {
   		fmt.Println(i)
   		time.Sleep(time.Second)
   	}
   }
   
   func main() {
   	go test()
   	//time.Sleep(time.Second*10)
   	for {
   		fmt.Println("'''''ssss'''ss")
   		time.Sleep(time.Second)
   	}
   }
   
   ```

4. 协程和线程

   - 协程：独立的栈空间，共享堆空间，调度由用户自己控制，本质上有点类似于用户级线程，这些用户级线程的调度也是由自己实现的
   - 线程：一个线程上可以跑多个协程，协程就是轻量级线程

5. goroute调度模型

6. 设置goroute运行的cpu核心数     go1.8默认使用所有核心

   ```go
   package main
   
   import (
   	"fmt"
   	"runtime"
   )
   
   func main() {
   	num := runtime.NumCPU()
   	runtime.GOMAXPROCS(num)
   	fmt.Println(num)
   }
   ```

### 二、Channel

- 程序中共享内存的两种方式

  - 全局变量

  ```go
  package main
  
  import (
  	"fmt"
  	"sync"
  	"time"
  )
  
  type task struct {
  	n int
  }
  
  var (             //全局变量
  	m    = make(map[int]uint64)
  	lock sync.Mutex
  )
  
  func calc(t *task) {
  	var sum uint64
  	sum = 1
  	for i := 1; i < t.n; i++ {
  		sum *= uint64(i)
  	}
  	lock.Lock()
  	m[t.n] = sum
  	lock.Unlock()
  
  }
  func main() {
  	for i := 0; i < 16; i++ {
  		t := &task{n: i}
  		go calc(t)
  	}
  	time.Sleep(time.Second * 10)
  	lock.Lock()
  	for k, v := range m {
  		fmt.Printf("%d！ = %v\n", k, v)
  	}
  	lock.Unlock()
  }
  
  ```

  - channel

1. channel概念

   - 类似unix中的pipe
   - 先进先出
   - 线程安全，多个goroute同时访问，不需要加锁
   - chanel是有类型的，一个整数的channel只能存放整数

2. channel声明

   - `var test chan int`
   - `var test chan string`
   - `var test chan map[int]string`

   ```go
   package main
   
   import "fmt"
   
   type Student struct {
   	name string
   }
   
   func main() {
   
   	var intChan chan int         //定义变量
   	intChan = make(chan int, 10) //初始化chan类型
   	intChan <- 10
   
   	var mapChan chan map[string]string
   	mapChan = make(chan map[string]string, 10)
   	m := make(map[string]string, 16)
   	m["stu01"] = "001"
   	m["stu02"] = "002"
   	mapChan <- m
   
   	//空接口类型写入接口
   	var stuChan chan interface{}
   	stuChan = make(chan interface{}, 10)
   	stu := Student{name: "stu01"}
   	stuChan <- &stu
   
   	//从channel读数据
   	var stu01 interface{}
   	stu01 = <-stuChan
   	fmt.Println(stu01)
   
   	//转为struct类型，“类型断言”
   	var stu02 *Student
   	stu02, ok := stu01.(*Student)
   	if !ok {
   		fmt.Println("can not convert")
   		return
   	}
   	fmt.Println(stu02)
   
   }
   
   ```

3. channel基本操作

   从channel中读取数据

   n = <- testChan

4. channel结合goroute

   ```go
   package main
   
   import (
   	"fmt"
   	"time"
   )
   
   func Write(ch chan int) {
   	for i := 0; i < 100; i++ {
   		ch <- i
   		fmt.Println("put data:", i)
   	}
   }
   func Read(ch chan int) {
   	for {
   		var b int
   		b = <-ch
   		fmt.Println(b)
   		time.Sleep(time.Second)
   	}
   }
   
   func main() {
   	intChan := make(chan int, 10) //初始化chan，缓冲区为10
   	go Write(intChan)
   	go Read(intChan)
   	time.Sleep(100 * time.Second)
   }
   
   ```

5. channel阻塞

6. 带缓冲区的channel

7. 双channel交互

   ```go
   package main
   
   import (
   	"fmt"
   )
   
   func calc(task chan int, resChan chan int, exitChan chan bool) {
   	for v := range task { //循环channel
   		flag := true
   		for i := 2; i < v; i++ {
   			if v%i == 0 { //判断是否素数
   				flag = false
   				break
   			}
   		}
   		if flag {
   			resChan <- v
   		}
   	}
   	//fmt.Println("exit")
   	exitChan <- true
   }
   func main() {
   	intChan := make(chan int, 1000) //初始化chan，缓冲区为1000
   	resultChan := make(chan int, 1000)
   	exitChan := make(chan bool, 8)
   	go func() {
   		for i := 0; i < 1000; i++ {
   			intChan <- i
   		}
   		close(intChan)
   	}()
   	for i := 0; i < 8; i++ {
   		go calc(intChan, resultChan, exitChan)
   	}
   	//等待所有计算的goroute全部退出
   	for i := 0; i < 8; i++ {
   		a := <-exitChan //从chan中取出数据丢弃
   		fmt.Println(a)
   	}
   	close(resultChan)
   	for v := range resultChan {
   		fmt.Println(v)
   	}
   
   	//time.Sleep(time.Second * 10)
   }
   
   ```

   ```go
   package main
   
   import (
   	"fmt"
   )
   
   func Send(ch chan int, exitChan chan struct{}) {
   	for i := 0; i < 10; i++ {
   		ch <- i
   	}
   	close(ch)
   	var a struct{}
   	exitChan <- a
   }
   func Recv(ch chan int, exitChan chan struct{}) {
   	for {
   		v, ok := <-ch
   		if !ok {
   			break
   		}
   		fmt.Println(v)
   	}
   	var a struct{}
   	exitChan <- a
   }
   
   func main() {
   	ch := make(chan int, 10)
   	exitChan := make(chan struct{})
   	go Send(ch, exitChan)
   	go Recv(ch, exitChan)
   	var total = 0
   	for _ = range exitChan {
   		total++
   		if total == 2 {
   			close(exitChan)
   		}
   	}
   	//for i :=0;i<2;i++{
   	//	<- exitChan
   	//}
   	//time.Sleep(time.Second)
   }
   
   ```

8. channel关闭

9. channel遍历

   ```go
   package main
   
   import "fmt"
   
   func main() {
   	var ch chan int
   	ch = make(chan int, 1000)
   	for i := 0; i < 1000; i++ {
   		ch <- i
   	}
   	close(ch)
   	for v := range ch {
   		fmt.Println(v)
   	}
   }
   ```

10. 只读chan和只写chan

    ```go
    func main() {
    	//var ch chan<- int //只写channel
    	//var ch2 <-chan int //只读channel
    }
    ```

    

11. 对channel进行select操作

    ```go
    package main
    
    import (
    	"fmt"
    	"time"
    )
    
    func main() {
    	var ch chan int
    	ch = make(chan int, 10)
    	ch2 := make(chan int, 10)
    	go func() {
    		for i := 0; i < 10; i++ {
    			ch <- i
    			time.Sleep(time.Second)
    			ch2 <- i * i
    		}
    	}()
    	for {
    		select { //使用select进行分支选择，否则chan中无数据将会阻塞
    		case v := <-ch:
    			fmt.Println(v)
    		case v := <-ch2:
    			fmt.Println(v)
    		case <-time.After(time.Second):
    			fmt.Println("get data timeout")
    			time.Sleep(time.Second)
    			//default:
    			//	fmt.Println("get data timeout")
    			//	time.Sleep(time.Second)
    		}
    	}
    }
    ```

12. 定时器的使用

    ```go
    import (
    	"fmt"
    	"time"
    )
    
    func main() {
    	select {
    	case <-time.After(time.Second):
    		fmt.Println("After")
    	}
    }
    ```

13. 超时控制

    ```go
    package main
    
    import (
    	"fmt"
    	"runtime"
    	"time"
    )
    
    func main() {
    	num := runtime.NumCPU()
    	runtime.GOMAXPROCS(num - 1)
    
    	for i := 0; i < 16; i++ {
    		go func() {
    			for {
    				t := time.NewTicker(time.Second)
    				select {
    				case <-t.C:
    					fmt.Println("timeout")
    				}
    				t.Stop()
    			}
    		}()
    	}
    	time.Sleep(time.Second * 10)
    }
    
    ```

14. gorpute中使用recover

    ```go
    package main
    
    import (
    	"fmt"
    	"runtime"
    	"time"
    )
    
    func test() {
    	defer func() { //错误捕获
    		if err := recover(); err != nil {
    			fmt.Println("panic:", err)
    		}
    	}()
    	var m map[string]int
    	m["stu1"] = 100
    }
    func calc() {
    	for {
    		fmt.Println("I'm working")
    		time.Sleep(time.Second)
    	}
    
    }
    func main() {
    	num := runtime.NumCPU()
    	runtime.GOMAXPROCS(num - 1)
    	go test()
    
    	for i := 0; i < 2; i++ {
    		go calc()
    	}
    
    	time.Sleep(time.Second * 100000)
    }
    
    ```

三、go中的单元测试

1. 文件名必须以_test.go结尾

2. 编写单元测试用例

   ```go
   //student.go
   package main
   
   import (
   	"encoding/json"
   	"io/ioutil"
   )
   
   type Student struct {
   	Name string
   	Sex  string
   	Age  int
   }
   
   func (p *Student) Save() (err error) {
   	data, err := json.Marshal(p)
   	if err != nil {
   		return
   	}
   	err = ioutil.WriteFile("D:/stu.data", data, 0755)
   	return
   }
   
   func (p *Student) Load() (err error) {
   	data, err := ioutil.ReadFile("D:/stu.data")
   	if err != nil {
   		return
   	}
   	err = json.Unmarshal(data, p)
   	return
   }
   
   ```

   ```go
   //student_test.go
   package main
   
   import "testing"
   
   func TestSave(t *testing.T) {
   	stu := &Student{
   		Name: "stu01",
   		Sex:  "man",
   		Age:  19,
   	}
   	err := stu.Save()
   	if err != nil {
   		t.Fatal("save stu faild ,error:", err)
   	}
   }
   
   func TestLoad(t *testing.T) {
   	stu := &Student{
   		Name: "stu01",
   		Sex:  "man",
   		Age:  19,
   	}
   	err := stu.Save()
   	if err != nil {
   		t.Fatal("save stu faild ,error:", err)
   	}
   
   	stu2 := &Student{}
   	err = stu2.Load()
   	if err != nil {
   		t.Fatalf("Load student failed,err:", err)
   	}
   	if stu.Name != stu2.Name {
   		t.Fatalf("Name no equal")
   	}
   	if stu.Sex != stu2.Sex {
   		t.Fatalf("Sex no equal")
   	}
   	if stu.Age != stu2.Age {
   		t.Fatalf("Age no equal")
   	}
   }
   
   /*
   PS F:\goWorks\Project01\src\go_dev\day8\unit_test\main> go test -v
   === RUN   TestSave
   --- PASS: TestSave (0.00s)
   === RUN   TestLoad
   --- PASS: TestLoad (0.00s)
   PASS
   ok      go_dev/day8/unit_test/main      0.335s
   */
   
   ```

   

