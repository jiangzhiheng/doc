### **函数**

- 完成特定功能的代码块
- 在shell中定义函数可以使代码模块化，便于复用代码
- 函数必须先定义才可以使用

1. 定义函数

   方法一：

   函数名(){

   ​		函数体

   }

   方法二：

   function 函数名{

   ​		函数体

   }

2. 调用函数

   函数名

   函数名 参数1，参数2

   ```shell
   #!/bin/bash
   # 阶乘
   
   factorial(){
   result=1
   for((i=1;i<=$1;i++))
   #for i in `seq $1`
   do
           result=$[$result * $i]
           #let result=$result*$i
           #let result*=$i
   done
   echo "$1 的阶乘：$result"
   }
   #调用函数
   factorial $1
   factorial $2
   factorial $3
   
   ```

3. 函数的返回值

   ```shell
   #!/bin/bash
   
   fun(){
           read -p "Please enter num" num
           echo "$[2*$num]"
   }
   
   result=`fun`
   echo "fun return value:$result"
   ```

   

4. 

