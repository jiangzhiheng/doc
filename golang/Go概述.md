### 一、`Golang`语言特性

1. 垃圾回收

   - 内存自动回收，再也不需要开发人员管理内存
   - 开发人员专注业务实现，降低了心智负担
   - 只需new分配新内存，不需要释放

2. 天然并发

   - 从语言层面支持并发，非常简单
   - `goroute`，轻量级线程，创建成千上万个`goroute`成为可能
   - 基于`CSP(Communicating Sequential Process)`模型实现

   ```go
   //goroute.go
   package main
   import (
      "fmt"
   )
   func test_goroute(a int){
      fmt.Println(a)
   }
   ```

   ```go
   //main.go
   package main
   
   import "time"
   
   
   func main(){
      for i :=0; i < 100; i++{
         go test_goroute(i)
      }
      time.Sleep(time.Second)
   }
   ```

3. channel

   - 管道 ，类似与`unix/Linux`中的pipe
   - 多个`goroute`之间通过channel通信
   - 支持任何类型

   ```go
   //pipe.go
   package main
   
   import "fmt"
   
   func TestPipe()  {
   	pipe := make(chan int,4)
   	pipe <- 5
   	pipe <- 9
   	pipe <- 1
   
   	t1 := <- pipe
   	fmt.Println(t1)
   	fmt.Println(len(pipe))
   }
   ```

   ```go
   //main.go
   package main
   
   func main() {
   	TestPipe()
   }
   ```

4. 多返回值

   - 一个函数多个返回值

   ```go
   func Calc(a ,b int) (int,int) {
   	sum := a + b
   	avg := (a + b)/2
   	return sum,avg
   }
   ```

### 二、包的概念

1. 和python一样，把相同功能的代码放到一个目录，称之为包

2. 包可以被其它包引用

3. main包是用来生成可执行文件，每个程序只有一个main包

4. 包的主要用途是提高代码的可复用性

   ```go
   //goroute/add.go
   package goroute
   
   func Add(a, b int,c chan int)  {
   	sum := a + b
   	c <- sum
   }
   ```

   ```go
   //main/main.go
   package main
   
   import (
   	"fmt"
   	"go_dev/test/goroute"
   )
   
   func main() {
   	pipe := make(chan int, 5)
   	go goroute.Add(10,20,pipe)
   
   	sum := <- pipe
   	fmt.Println(sum)
   }
   ```

### 三、Go中的环境变量

1. `GOPATH`

   - 环境变量`GOPATH`的值可以是一个目录的路径，也可以包含多个目录路径

   - 每个目录都代表Go语言的一个工作区（`WorkSpace`）

   - 工作区用于放置Go语言的源码文件(`source file`)以及安装后的归档文件(`archive file,也就是以“.a”为扩展名的文件`)和可执行文件

   - 我们通常是在project目录下执行go build，`golang`会自动去`src`目录下找需要编译的目录

     ```powershell
     d:\project>go build go_dev/package_example\main
     ```

2. `GOROOT`

   - `golang`的安装路径

3. `GOBIN`

4. 一个完整的go开发目录

   ```go
   go_project     // go_project为GOPATH目录
     -- bin
        -- myApp1  // 编译生成
        -- myApp2  // 编译生成
        -- myApp3  // 编译生成
     -- pkg
     -- src
        -- myApp1     // project1
           -- models
           -- controllers
           -- others
           -- main.go 
        -- myApp2     // project2
           -- models
           -- controllers
           -- others
           -- main.go 
        -- myApp3     // project3
           -- models
           -- controllers
           -- others
           -- main.go
   ```

   

   

### 四、Go中的一些命令

1. `go build`
   - `-a` 强行编译目标代码及依赖代码包
   - `-insecure` 允许通过非安全的网络协议下载和安装代码包，例如`http`协议
   - `-d` 只下载代码包，不安装代码包
   - `-u` 下载并安装代码包
   - `-o` 编译时指定生成二进制文件的路径
2. `go get`
   - 从远程下载需要用到的包
   - 执行go install
3. go install
   - go install 会生成可执行文件直接放到bin目录下
   - 如果是一个普通的包，会被编译生成到pkg目录下，该文件以.a结尾






