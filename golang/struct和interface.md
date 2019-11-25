### 一、结构体

1. `struct`概述

   - 用来自定义复杂的数据结构
   - `struct`里面可以包含多个字段(属性)
   - `struct`是值类型
   - `struct`可以嵌套
   - Go语言中没有Class类型，只有struct类型

2. `struct`定义

   1. `struct`声明

      `type  标识符 struct{}`

   2. `struct`中字段访问，和其它语言一样，使用.

      `var stu Student`

      `stu.Name="Tony"`

      `stu.XXXX`

   3. `struct`定义的三种形式

      - `var stu Student`

      - `var stu *Student = new (Student)`

      - `var stu *Student = &Student{}`

        1）其中第二和第三都是返回指向结构体的指针

   4. `struct`的内存布局：`struct`中的所有字段在内存是连续的

      ```go
      package main
      
      import "fmt"
      
      type Student struct {
      	Name  string
      	Age   int
      	Score float32
      }
      
      func main() {
      	var stu Student
      	stu.Name = "Tony"
      	stu.Age = 18
      	stu.Score = 90
      
      	var stu1 *Student = &Student{
      		Age:  90,
      		Name: "Martin",
      	}
      
      	var stu2 = Student{
      		Name: "jack",
      		Age:  19,
      	}
      	fmt.Println(stu2.Name)
      	fmt.Println(stu1.Name)
      	fmt.Println(stu)
      	fmt.Printf("Name:%p\n", &stu.Name)
      	fmt.Printf("Age:%p\n", &stu.Age)
      	fmt.Printf("Score:%p\n", &stu.Score)
      }
      
      ```

3. 链表

   1. 单项链表

      链表定义：

      `type Studeng struct{`

      `           Name string`

      `Next* Student`

      `}`

      每个节点包含下一个节点的地址，这样把所有节点串起来了

      ```go
      package main
      
      import "fmt"
      
      type Student struct {
      	Name  string
      	Age   int
      	Score float32
      	next  *Student
      }
      
      func trans(p *Student) {
      	for p != nil {
      		fmt.Println(*p)
      		p = p.next
      	}
      }
      
      //尾部插入法
      func main() {
      	var head Student
      	head.Name = "Tony"
      	head.Age = 19
      	head.Score = 90
      
      	var stu1 Student
      	stu1.Name = "Martin"
      	stu1.Age = 19
      	stu1.Score = 98
      
      	head.next = &stu1
      
      	//trans(&head)
      
      	var stu2 Student
      	stu2.Name = "Martin"
      	stu2.Age = 19
      	stu2.Score = 98
      	stu1.next = &stu2
      
      	trans(&head)
      
      }
      
      //输出
      //{Tony 19 90 0xc042037f50}
      //{Martin 19 98 <nil>}
      
      ```

      ```go
      package main
      
      import (
      	"fmt"
      	"math/rand"
      )
      
      type Student struct {
      	Name  string
      	Age   int
      	Score float32
      	next  *Student
      }
      
      //遍历链表
      func trans(p *Student) {
      	for p != nil {
      		fmt.Println(*p)
      		p = p.next
      	}
      }
      
      //批量尾部插入节点
      func InsertTail(p *Student) {
      	var tail = p
      	for i := 0; i < 10; i++ {
      		stu := Student{
      			Name:  fmt.Sprintf("stu%d", i),
      			Age:   rand.Intn(100),
      			Score: rand.Float32() * 100,
      		}
      		tail.next = &stu
      		tail = &stu
      	}
      }
      
      //头部插入
      func insertHead(p **Student) { //二级指针
      	for i := 0; i < 10; i++ {
      		stu := Student{
      			Name:  fmt.Sprintf("stu%d", i),
      			Age:   rand.Intn(100),
      			Score: rand.Float32() * 100,
      		}
      		stu.next = *p
      		//head = stu  ----->{stu.next = head.next....}
      		*p = &stu
      	}
      }
      
      //删除节点
      func delNode(p *Student) {
      	var prev *Student = p
      	for p != nil {
      		if p.Name == "stu6" {
      			prev.next = p.next
      			break
      		}
      		prev = p
      		p = p.next
      	}
      }
      
      //添加一个节点
      func addNode(p *Student, newNode *Student) {
      	for p != nil {
      		if p.Name == "stu6" {
      			newNode.next = p.next
      			p.next = newNode
      			break
      		}
      		p = p.next
      	}
      }
      
      func main() {
      	var head *Student = new(Student)
      	head.Name = "Martin"
      	head.Age = 19
      	head.Score = 98
      	//var head *Student = &Student{
      	//	Name:"tony",
      	//	Age:18,
      	//	Score:98,
      	//}
      	//InsertTail(head)
      	//trans(head)
      	//fmt.Println()
      	insertHead(&head)
      	trans(head)
      }
      
      ```

      

   2. 双向链表

      如果有两个指针分别指向前一个节点和后一个节点，我们叫做双链表

4. 二叉树

   `type Studeng struct{`

   `Name string`

   `left* Studeng`

   `right* Studeng`

   `}`

   如果每个节点有两个指针分别用来指相左子树和右子树，我们把这样的结构叫做二叉树

   ```go
   package main
   
   import (
   	"fmt"
   )
   
   type Student struct {
   	Name  string
   	Age   int
   	Score float32
   	left  *Student
   	right *Student
   }
   
   func trans(root *Student) {
   	if root == nil {
   		return
   	}
   	fmt.Println(root)
   	trans(root.left) //递归解决
   	trans(root.right)
   }
   
   func main() {
   	var root *Student = new(Student)
   	root.Name = "stu01"
   	root.Age = 18
   	root.Score = 90
   
   	var left1 *Student = new(Student)
   	left1.Name = "stu02"
   	left1.Age = 11
   	left1.Score = 98
   
   	root.left = left1
   
   	var right1 *Student = new(Student)
   	right1.Name = "stu04"
   	right1.Age = 11
   	right1.Score = 98
   	root.right = right1
   
   	var left2 *Student = new(Student)
   	left2.Name = "stu03"
   	left2.Age = 11
   	left2.Score = 98
   	left1.left = left2
   
   	trans(root)
   }
   /*
   输出
   &{stu01 18 90 0xc042042300 0xc042042330}
   &{stu02 11 98 0xc042042360 <nil>}
   &{stu03 11 98 <nil> <nil>}
   &{stu04 11 98 <nil> <nil>}
   */
   ```

5. Go中的`struct`没有构造函数，一般可以使用工厂模式来解决这个问题

6. `struct`中的tag：我们可以为`struct`中的每一个字段写上一个tag，这个tag可以通过反射方式获取到，最常用的场景就是json序列化和反序列化

   ```go
   package main
   
   import (
   	"encoding/json"
   	"fmt"
   )
   
   type Student struct {
   	Name  string `json:"name"`
   	Age   int    `json:"age"`
   	Score int    `json:"score"`
   	//如果定义的字段首字母小写，则不能被其它包访问，json转的时候会获取不到
   }
   
   func main() {
   	var stu Student = Student{
   		Name:  "stu01",
   		Age:   18,
   		Score: 98,
   	}
   	data, err := json.Marshal(stu)
   	if err != nil {
   		fmt.Println("json encode stu failed", err)
   	}
   	fmt.Println(string(data))
   }
   
   //输出
   //{"name":"stu01","age":18,"score":98}
   
   ```

7. Go中的结构体，中的字段可以没有名字，即匿名字段

   ```go
   package main
   
   import (
   	"fmt"
   	"time"
   )
   
   type Cart1 struct {
   	Name string
   	Age  int
   }
   
   type Cart2 struct {
   	Name string
   	Age  int
   }
   
   type Train struct {
   	Cart1 //匿名字段
   	Cart2
   	int   //匿名字段
   	Start time.Time
   }
   
   func main() {
   	var t Train
   	t.Cart1.Name = "train" //需要指明引用的匿名子段type
   	//t.Name = "martin"
   	t.int = 100
   
   	t.Cart1.Name = "marry"
   	t.Cart1.Age = 19
   	fmt.Println(t)
   }
   
   ```

8. Go中的方法是作用在特定类型的变量上，因此自定义类型，都可以有方法，而不仅仅是`struct`

   定义：`func (recevier type) methodName(参数列表)（返回值列表）{}`

   ```go
   package main
   
   import "fmt"
   
   type Student struct {
   	Name  string
   	Age   int
   	Score int
   }
   
   func (p *Student) init(name string, age int, score int) {
   	p.Name = name
   	p.Age = age
   	p.Score = score
   	fmt.Println(p)
   }
   
   func (p Student) get() Student {
   	return p
   }
   func main() {
   	var stu Student
   	stu.init("stu", 10, 98)
   	stu1 := stu.get()
   	fmt.Println(stu1)
   }
   
   ```

9. Go中的继承实现

   如果一个`struct`嵌套了另一个匿名结构体，那么这个结构体就可以访问匿名结构图中的方法，从而实现了继承

   ```go
   package main
   
   import "fmt"
   
   type Car struct {
   	Weight int
   	Name   string
   }
   
   type Bike struct {
   	Car
   	Wheel int
   }
   
   func (p *Car) Run() {
   	fmt.Println("running")
   }
   
   type Train struct {
   	c Car
   }
   
   func main() {
   	var a Bike
   	a.Weight = 100
   	a.Name = "bike"
   	a.Wheel = 2
   	fmt.Println(a)
   	a.Run()
   
   	//组合
   	var b Train
   	b.c.Run()
   }
   
   ```

10. 组合和匿名子段

    - 如果一个`struct`嵌套了另一个匿名结构体，那么这个结构体就可以访问匿名结构图中的方法，从而实现了继承
    - 如果一个结构体嵌套了另一个有名结构图，那么这个模式就叫做组合

11. 多重继承

12. 实现String()     类似于java中重写类的`toString()`方法

    如果一个变量实现了String()这个方法，那么`fmt.Println`默认会调用这个变量的String()进行输出

    ```go

    package main
    
    import "fmt"
    
    type Car struct {
    	Weight int
    	Name   string
    }
    
    func (p *Car) Run() {
    	fmt.Println("running")
    }
    
    type Bike struct {
    	Car
    	Wheel int
    }
    
    type Train struct {
    	Car
    }
    
    func (p *Train) String() string {
    	str := fmt.Sprintf("name = [%s]", p.Name)
    	return str
    }
    func main() {
    	var a Bike
    	a.Weight = 100
    	a.Name = "bike"
    	a.Wheel = 2
    	fmt.Println(a)
    	a.Run()
    
    	//组合
    	var b Train
    	b.Name = "martin"
    	b.Run()
    	fmt.Printf("%s", &b)
    }
    
    ```

### 二、interface

1. 定义：interface类型可以定义一组方法，但这些方法不需要实现，并且interface不能包含任何变量。

   ```go
   package main
   
   import "fmt"
   
   type Carer interface {
   	GetName() string
   	Run()
   	DiDi()
   }
   type BMW struct {
   	Name string
   }
   
   func (p *BMW) GetName() string {
   	return p.Name
   }
   func (p *BMW) Run() {
   	fmt.Printf("%s is Running", p.Name)
   }
   func (p *BMW) DiDi() {
   	fmt.Printf("%s is DiDiDi..", p.Name)
   }
   
   func main() {
   	/*
   		var a interface{}
   		var b int
   		a = b  //任何数据类型都可以转成空接口
   
   		fmt.Printf("type is %T\n",a)
   	*/
   	var car Carer
   	fmt.Println(car)
   	var bmw BMW
   	bmw.Name = "BMW"
   	car = &bmw
   	car.Run()
   }
   
   ```

   

2. 定义：

   ```go
   type example interface{
        Method1(参数列表) 返回值列表
        Method1(参数列表) 返回值列表
        ...
   }
   ```

3. interface默认是一个指针

   ```go
   type example interface{
       Method1(参数列表) 返回值列表
       Method1(参数列表) 返回值列表
       ...
   }
   var a example
   a.Method1()
   ```

4. 接口实现：

   - `Golang`中的接口，不需要显式的实现，只要一个变量含有接口类型中的所有方法，这个变量就实现这个接口，因此`Golang`中没有`implement`类似的关键字
   - 如果一个变量含有了多个interface类型的方法，那么这个变量就实现了多个接口
   - 如果一个变量只含有一个interface的部分方法，那么这个变量没有实现这个接口

5. 多态

   一种事物的多种形态，都可以按照统一的接口进行操作

6. 接口嵌套

   一个接口可以嵌套在另外的接口

7. 类型断言