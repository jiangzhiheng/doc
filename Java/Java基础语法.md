最有效率的计算2*8的结果 2<<3相当于2乘以2的3次幂

#### Java语法结构

1. 顺序结构

2. 分支结构

   - 单分支if

     ```java
     import java.util.Scanner;
     public class Test{
         public static void main(String[] args){
             Scanner input = new Scanner(System.in);
             int day = input.nextInt();
             if(day == 1){
              	System.out.println("Monday");           
             }else if(day == 5) {
                 System.out.println("Friday");
             }else {
                 System.out.println("Input error");
             }
         }
     }
     ```

     ```java
     //Demo01
     import java.util.Scanner;
     
     public class SeasonDemo {
         public static void main(String[] args) {
             Scanner input  = new Scanner(System.in);
             System.out.println("Please input month: ");
             int month = input.nextInt();
             if (month == 3 || month == 4 || month == 5){
                 System.out.println("Spring");
             }else if(month == 6 || month == 7 || month == 8){
                 System.out.println("Summer");
             }else if (month == 9 || month == 10 || month == 11){
                 System.out.println("Autumn");
             }else if(month == 12 || month == 1 || month == 2){
                 System.out.println("Autumn");
             }else {
                 System.out.println("input error");
             }
         }
     }
     ```

     ```java
     //Demo02
     
     import java.lang.Math;
     import java.util.Scanner;
     
     public class GuessDice {
         public static void main(String[] args) {
             //1.随机摇骰子的过程 随机产生一个点数 1-6整数
             double value = Math.random();
             int number = (int)(value*6+1);
             //value范围[0,1)  (int)(value*6+1)
             //2.让玩家猜测大小
             Scanner input  = new Scanner(System.in);
             System.out.println("买大买小，买定离手");
             String userChoose = input.nextLine();
             //3.比较点数与猜测结果
             //点数1，2，3并且同时猜小，，点数4，5，6同时猜大
             //== equals();区别  equals比较引用类型
             System.out.printf("当前点数为%s\n",number);
             if (number <= 3 && userChoose.equals("小") || number > 3 && userChoose.equals("大")) {
                 System.out.println("恭喜你，猜对啦！");
             }else {
                 System.out.println("Sorry,猜错啦！");
             }
         }
     }
     ```

   - 多分支switch

     switch(值){     //int  char
     
     ​	case 值1：
     
     ​		代码1；
     
     ​	。。。
     
     ​	default：
     
     }
     
     ```java
     import java.util.Scanner;
     
     public class testSwitch {
         public static void main(String[] args) {
             Scanner input = new Scanner(System.in);
             System.out.println("Please input a number:");
             int day = input.nextInt();
             switch (day){
                 case 1:
                     System.out.println("Monday");
                     break;
                 case 2:
                     System.out.println("Tuesday");
                     break;
                 case 3:
                     System.out.println("Wendensday");
                     break;
                 default:
                     System.out.println("Input Error");
                     break;
             }
         }
     }
     ```
     
     ```java
     //Demo01
     
     import java.util.Scanner;
     
     public class GradeTest {
         public static void main(String[] args) {
             //创建一个变量存储Score
             Scanner input = new Scanner(System.in);
             System.out.println("Please input Score:");
             int score = input.nextInt();
             //利用成绩的值，来判断区间
             switch (score/10){
                 case 1:
                 case 2:
                 case 3:
                 case 4:
                 case 5:
                     System.out.println("不及格");
                 case 6:
                     System.out.println("及格");
                     break;
                 case 7:
                     System.out.println("中等");
                     break;
                 case 8:
                     System.out.println("良好");
                     break;
                 case 9:
                     System.out.println("优秀");
                     break;
                 default:
                     System.out.println("Input Error");
             }
         }
     }
     ```
     
     
     
   
3. 循环结构

   - for

     ```java
     public class ForLoop {
         public static void main(String[] args) {
             //double value = Math.pow(a,b);a的b次方
             for (int x = 100;x <= 999;x ++){
                 int a = x%10;
                 int b = (x/10)%10;
                 int c = (x/100)%10;
                 //int sum = a*a*a + b*b*b + c*c*c;
                 double sum = Math.pow(a,3) + Math.pow(b,3)+Math.pow(c,3);
                 if (sum == x){
                     System.out.println(x+"是水仙花数");
                 }
             }
         }
     }
     
     ```

     循环嵌套

     ```java
     //Demo02
     public class ForLoop02 {
         public static void main(String[] args){
             for (int i = 1; i <= 4; i ++){
                 for (int j = 1; j <= i ;j ++){
                     System.out.print("*");
                 }
                 System.out.println();
             }
         }
     }
     //*
     //**
     //***
     //****
     ```

     ```java
     import java.util.Scanner;
     
     public class ForLoop03{
         public static void main(String[] args){
             Scanner input = new Scanner(System.in);
             System.out.println("Please input line number:");
             int line = input.nextInt();
             for(int i = 1;i <= line;i ++){//控制行数
                 if(i == 1){//第一行规则
                     for (int j = 1;j <= 2*line-1;j++){
                         System.out.print("*");
                     }
                 }else{//后三行规则
                     for(int j = 1;j<=(line+1)-i;j++){
                         System.out.print("*");
                     }
                     for (int j = 1;j<=2*i-3;j++){
                         System.out.print(" ");
                     }
                     for (int j = 1;j<=(line+1)-i;j++){
                         System.out.print("*");
                     }
                 }
             System.out.println();
             }
     
         }
     }
     //*******
     //*** ***
     //**   **
     //*     *
     
     ```

     ```java
     //9*9乘法表
     public class Demo03 {
         public static void main(String[] args) {
             for(int i = 1;i <= 9;i++){
                 for (int j = 1;j <= i; j++){
                     System.out.print(i+"*"+j+"="+(i*j)+"\t");
                 }
                 System.out.println();
             }
         }
     }
     ```

     ```java
     //素数
     public class Demo04 {
         public static void main(String[] args) {
             for(int num = 2;num <= 100;num++) {
                 boolean flag = false;
                 for (int i = 2; i <= num/2 - 1; i++) {
                     if (num % i == 0) {
                         System.out.println(num + "不是素数");
                         flag = true;
                         break;
                     }
                 }
                 if (flag == false) {
                     System.out.println(num + "是素数");
                 }
             }
         }
     }
     ```

   - while

     ```java
     public class WhileDemo {
         //初始值
         //while(终点判断条件){
         // }
         public static void main(String[] args) {
             int i = 1;
             while (i <= 5){
                 System.out.println("hello World");
                 i ++;
             }
             System.out.println("exec Complete");
         }
     }
     ```

   - do...while

     ```java
     public class DoWhileDemo {
         //初始值
         //do{
         // }while()
     
         public static void main(String[] args) {
             int i = 1;
             do {
                 i++;
                 System.out.println("hello World");
             }while (i<=5);
             System.out.println("Exec Complete");
         }
     }
     ```

     


4. Java数组的使用

   数据组是一组数据类型相同的数据的组合，将这些数据统一的管理起来

   数组是一个引用类型，数组内存储的类型可以是基本类型，也可以是引用类型

   1. 数据的定义（声明）

      - 数据类型[]    数组名字

        int[] x;

        char[] y;

        String[] m;

   2. 数组的初始化

      - 静态初始化

        int[] array = new int[]{10,20,30,40,50};

        int[] array = {10,20,30,40,50};

      - 动态初始化  有长度，无元素

        int [] array = new int[5];

      - 

      

   3. 数组元素的访问

      通过元素在数组中的位置来访问

      索引有取值范围，会出现异常ArrayIndexOutOfBoundsException

   4. 通过循环遍历数组

      JDK1.5版本之后，新特性，增强for循环 forEach

      for(自己定义的变量（接受数组内的每一个元素：遍历的数组Array）){

      }

      ```java
      public class TestArray {
          public static void main(String[] args) {
              int[] array01 = new int[5];   //动态初始化
              for(int value:array01){
                  System.out.println(value);
              }
              
              
              int[] array = new int[]{10,20,30,40,50};
              //通过元素在数组中的位置index来访问
              //array[index]
              int value = array[1];
              //改变数组内值
              array[3] = 400;
              System.out.println(value);
              //value = array[5];
              //System.out.println(value);
              //异常----运行时异常InputMisMatchException输入类型不匹配
              //ArrayIndexOutOfBoundsException数组索引越界
      
              //遍历数据
              for(int i = 0;i < 5;i ++){
                  System.out.println(array[i]);
              }
              //增强for循环:有两个条件，无索引，只能取值，不能存，找不到索引
              System.out.println("--------------------");
              for (int value1:array){
                  System.out.println(value1);
              } 
          }
      }
      ```

      

   5. 基本数据类型和引用数据类型在内存结构上的区别

      new关键字相当于在堆内存中申请开辟一块新的空间

      - 数组在堆内存的空间形态，是一串连续的地址

      - 基本类型变量空间存储的是值，传递的是值

      - 数组是在堆内存中的一段连续的地址存在

      - 堆内存的数组空间长度一旦确定，不能发生改变

      所有的基本类型都存储在栈内存

      如果存储的是基本数据类型，存储的是值

      如果存储的是引用数据类型，传递的是引用，值存储在堆内存

      ```java
      public class TestArray {
          public static void main(String[] args) {
              //1.创建一个数组
              int[] array = new int[50];
              //2.将1-100之间的偶数存入数据
              for (int i = 0;i < array.length;i ++){
                  array[i] = 2*i +2;
              }
              //3.输出验证
              for (int value:array){
                  System.out.println(value);
              }
          }
      }
      /*
      1.使用动态初始化
      2.使用两个循环
      */
      ```

      

   6. 

5. 

