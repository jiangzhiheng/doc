1. 终端读写

   操作终端相关的文件句柄常量

   - `os.Stdin`   标准输入
   - `os.Stdout`   标准输出
   - `os.stderr`  标准错误输出

   ```go
   package main
   
   import "fmt"
   
   type student struct {
   	Name  string
   	Age   int
   	Score float32
   }
   
   func main() {
   	var str = "stu01 18 98.9"
   	var stu student
   	fmt.Sscanf(str, "%s %d %f", &stu.Name, stu.Age, stu.Score)
   	fmt.Println(stu)
   }
   
   ```

2. 文件读写

   ```go
   package main
   
   import (
   	"bufio"
   	"fmt"
   	"io"
   	"os"
   )
   
   type CharCount struct {
   	ChCount    int
   	NumCount   int
   	SpaceCount int
   	OtherCount int
   }
   
   func main() {
   	file, err := os.Open("D:/test.log")
   	if err != nil {
   		fmt.Println("read file faied", err)
   		return
   	}
   	defer file.Close() //关闭文件句柄
   	var count CharCount
   	reader := bufio.NewReader(file) //以bufio读入
   	for {
   
   		str, err := reader.ReadString('\n') //按行读入，
   		if err == io.EOF {                  //文件结尾为EOF
   			//fmt.Println("read string faied, err:",err)
   			//return
   			break
   		}
   		if err != nil {
   			fmt.Println("read string faied, err:", err)
   			return
   		}
   		runeArr := []rune(str) //强制转换为字符数组，默认为字节数组
   		for _, v := range runeArr {
   			switch {
   			case v >= 'a' && v <= 'z':
   				fallthrough
   			case v >= 'A' && v <= 'Z':
   				count.ChCount++
   			case v == ' ' || v == '\t':
   				count.SpaceCount++
   			case v >= 0 && v <= 9:
   				count.NumCount++
   			default:
   				count.OtherCount++
   			}
   		}
   	}
   	fmt.Printf("char count:%d\n", count.ChCount)
   	fmt.Printf("num count:%d\n", count.NumCount)
   	fmt.Printf("space count:%d\n", count.SpaceCount)
   	fmt.Printf("other count:%d\n", count.OtherCount)
   }
   
   ```

   1. `os.File`封装所有文件相关操作，之前的`os.Stdin,os.Stdout,os.Stderr`都是`*os.File`

      - 打开一个文件进行读操作：`os.Open(name String)(*File,error)`
      - 关闭一个文件：`File.Close()`

   2. 读取整个文件

      `io/ioutil`

      ```go
      package main
      
      import (
      	"fmt"
      	"io/ioutil"
      	"os"
      )
      
      func main() {
      	inputFile := "products.txt"
      	outputFile := "products_copy.txt"
      	buf, err := ioutil.ReadFile(inputFile)
      	if err != nil {
      		fmt.Fprint(os.Stderr, "File Error: %s\n", err)
      		return
      	}
      	fmt.Printf("%s\n", string(buf))
      	err = ioutil.WriteFile(outputFile, buf, 0x64)
      	if err != nil {
      		panic(err.Error())
      	}
      }
      
      ```

   3. 读取压缩文件示例

      ```go
      package main
      
      import (
      	"bufio"
      	"compress/gzip"
      	"fmt"
      	"os"
      )
      
      func main() {
      	fileName := "MyFile.gz"
      	var r *bufio.Reader
      	fi, err := os.Open(fileName)
      	if err != nil {
      		fmt.Fprintf(os.Stderr, "Can't open %s :error:%s\n", os.Args[0], fileName, err)
      		os.Exit(1)
      	}
      	fz, err := gzip.NewReader(fi)
      	if err != nil {
      		fmt.Fprintf(os.Stderr, "open gzip faied,err:%v\n", err)
      		return
      	}
      	r = bufio.NewReader(fz)
      	for {
      		line, err := r.ReadString('\n')
      		if err != nil {
      			fmt.Println("Done reading file")
      			os.Exit(0)
      		}
      		fmt.Println(line)
      	}
      
      }
      
      ```

   4. 文件写入

      `os.OpenFile("output.dat",os.O_WRONLY|os.O_CREATE,0666)`

      第二个参数：文件打开模式

      - `os.O_WRONLY`  只写
      - `os.O_CREATE`  创建文件
      - `os.O_RDONLY`  只读
      - `os.RDWR`   读写
      - `os.O_TRUNC`  清空

      第三个参数：权限控制

      - r---004
      - w---002
      - x---001

      ```go
      package main
      
      import (
      	"bufio"
      	"fmt"
      	"os"
      )
      
      func main() {
      	outputFile, outputError := os.OpenFile("output.dat", os.O_WRONLY|os.O_CREATE, 0666)
      	if outputError != nil {
      		fmt.Printf("An error occurred with file failed %v", outputError)
      		return
      	}
      	defer outputFile.Close()
      	outputWriter := bufio.NewWriter(outputFile)
      	outputString := "Hello World\n"
      	for i := 0; i < 10; i++ {
      		outputWriter.WriteString(outputString)
      	}
      	outputWriter.Flush()
      }
      
      ```

   5. 拷贝文件

   ```go
   package main
   
   import (
   	"fmt"
   	"io"
   	"os"
   )
   
   func CopyFile(dstName, srcName string) (written int64, err error) {
   	src, err := os.Open(srcName)
   	if err != nil {
   		return
   	}
   	defer src.Close()
   	dst, err := os.OpenFile(dstName, os.O_WRONLY|os.O_CREATE, 0644)
   	if err != nil {
   		return
   	}
   	defer dst.Close()
   	return io.Copy(dst, src) //调用Copy接口
   }
   
   func main() {
   	CopyFile("target.txt", "source.txt")
   	fmt.Println("Copy Done!")
   }
   
   ```

3. 命令行参数

   1. `os.Args`是一个string的切片，用来存储命令行参数
   2. flag包，用来解析命令行参数

   ```go
   package main
   
   import (
   	"fmt"
   	"os"
   )
   
   func main() {
   	fmt.Printf("len of args:%d\n", len(os.Args))
   	for i, v := range os.Args {
   		fmt.Printf("args[%d] = %s \n", i, v)
   	}
   }
   ```

4. `Json`数据协议

   `golang---->Json字符串---->程序----->其它语言`

   ```go
   package main
   
   import (
   	"encoding/json"
   	"fmt"
   )
   
   //json序列化结构体
   
   type User struct {
   	UserName string `json:"username"`
   	NickName string `json:"nickname"`
   	Age      int
   	Birthday string
   	Sex      string
   	Email    string
   	Phone    string
   }
   
   //结构体序列化
   func testStruct() {
   	user1 := &User{
   		UserName: "user1",
   		NickName: "Tony",
   		Age:      18,
   		Birthday: "2001/01/02",
   		Sex:      "男",
   		Email:    "tony@trustfar.cn",
   		Phone:    "12306",
   	}
   	data, err := json.Marshal(user1)
   	if err != nil {
   		fmt.Printf("json.marshal failed,err:", err)
   		return
   	}
   	fmt.Printf("%s\n", string(data))
   }
   
   func testInt() {
   	var age int = 19
   	data, err := json.Marshal(age)
   	if err != nil {
   		fmt.Printf("json.marshal failed,err:", err)
   		return
   	}
   	fmt.Printf("%s\n", string(data))
   }
   
   func testMap() {
   	var m map[string]interface{}
   	m = make(map[string]interface{})
   	m["username"] = "Martin"
   	m["age"] = 18
   	m["sex"] = "男"
   	data, err := json.Marshal(m)
   	if err != nil {
   		fmt.Printf("json.marshal failed,err:", err)
   		return
   	}
   	fmt.Printf("%s\n", string(data))
   
   }
   func testSlice() {
   	var s []map[string]interface{}
   	m := make(map[string]interface{})
   	m["username"] = "Martin"
   	m["age"] = 18
   	m["sex"] = "男"
   	s = append(s, m)
   
   	m = make(map[string]interface{})
   	m["username"] = "Bob"
   	m["age"] = 19
   	m["sex"] = "gay"
   	s = append(s, m)
   
   	data, err := json.Marshal(s)
   	if err != nil {
   		fmt.Printf("json.marshal failed,err:", err)
   		return
   	}
   	fmt.Printf("%s\n", string(data))
   
   }
   func main() {
   	//testStruct()
   	//testInt()
   	//testMap()
   	testSlice()
   }
   
   //{"UserName":"user1","NickName":"Tony","Age":18,"Birthday":"2001/01/02","Sex":"男","Email":"tony@trustfar.cn","Phone":"12306"}
   //[{"age":18,"sex":"男","username":"Martin"},{"age":19,"sex":"gay","username":"Bob"}]
   
   ```

   

   - 导入包：`import encoding/json`
   - 序列化：`json.Marshal(data interface{})`
   - 反序列化：`json.UnMarshal(data []byte,v interface{})`

   ```go
   package main
   
   import (
   	"encoding/json"
   	"fmt"
   )
   
   type User struct {
   	UserName string `json:"username"`
   	NickName string `json:"nickname"`
   	Age      int
   	Birthday string
   	Sex      string
   	Email    string
   	Phone    string
   }
   
   func testStruct() (ret string, err error) {
   	user1 := &User{
   		UserName: "user1",
   		NickName: "上课看似",
   		Age:      18,
   		Birthday: "2008/8/8",
   		Sex:      "男",
   		Email:    "mahuateng@qq.com",
   		Phone:    "110",
   	}
   
   	data, err := json.Marshal(user1)
   	if err != nil {
   		err = fmt.Errorf("json.marshal failed, err:", err)
   		return
   	}
   
   	ret = string(data)
   	return
   }
   
   func testMap() (ret string, err error) {
   	var m map[string]interface{}
   	m = make(map[string]interface{})
   	m["username"] = "user1"
   	m["age"] = 18
   	m["sex"] = "man"
   
   	data, err := json.Marshal(m)
   	if err != nil {
   		err = fmt.Errorf("json.marshal failed, err:", err)
   		return
   	}
   
   	ret = string(data)
   	return
   }
   
   //map反序列化
   func test2() {
   	data, err := testMap()
   	if err != nil {
   		fmt.Println("test map failed, ", err)
   		return
   	}
   
   	var m map[string]interface{}
   	err = json.Unmarshal([]byte(data), &m)
   	if err != nil {
   		fmt.Println("Unmarshal failed, ", err)
   		return
   	}
   	fmt.Println(m)
   }
   
   //struct反序列化
   func test() {
   	data, err := testStruct()
   	if err != nil {
   		fmt.Println("test struct failed, ", err)
   		return
   	}
   
   	var user1 User
   	err = json.Unmarshal([]byte(data), &user1)
   	if err != nil {
   		fmt.Println("Unmarshal failed, ", err)
   		return
   	}
   	fmt.Println(user1)
   }
   
   func main() {
   	test()
   	test2()
   }
   
   ```

5. 错误处理

   1. 定义错误

      ```go
      package main
      
      import (
      	"fmt"
      	"os"
      	"time"
      )
      
      type PathError struct {
      	Path    string
      	Op      string
      	Time    string
      	Message string
      }
      
      func (p *PathError) Error() string {
      	return fmt.Sprintf("path=%s op=%s time=%s message=%s ", p.Path, p.Op, p.Time, p.Message)
      }
      func Open(filename string) error {
      	file, err := os.Open(filename)
      	if err != nil {
      		return &PathError{
      			Path:    filename,
      			Op:      "read",
      			Message: err.Error(),
      			Time:    fmt.Sprintf("%v", time.Now()),
      		}
      	}
      	defer file.Close()
      	return nil
      }
      
      func main() {
      	err := Open("C:/shshsh.sl")
      	if err != nil {
      		fmt.Println(err)
      	}
      }
      
      ```

      

   2. `panic/recover`错误处理

      ```go
      package main
      
      import (
      	"fmt"
      )
      
      func badCall() {
      	panic("bad end")
      }
      func test() {
      	defer func() {
      		if e := recover(); e != nil {
      			fmt.Printf("panicking %s\r\n", e)
      		}
      	}()
      	badCall()
      	fmt.Printf("After bad Call\r\n")
      }
      
      func main() {
      	fmt.Printf("Calling test\r\n")
      	test()
      	fmt.Printf("Test completed\r\n")
      }
      
      //F:\goWorks\Project01>main.exe
      //Calling test
      //panicking bad end
      //Test completed
      
      ```

      

