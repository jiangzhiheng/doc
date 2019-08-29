1. 面向对象之属性

   - 面向过程的编程思想

     解决问题的时候按照一定的过程（流程）

     以过程为本，增加了很多冗余

   - 面向对象的编程思想

     解决问题的的时候，考虑在这个问题的过程中，有几个实体参与进来

     理解为 实体动作的支配者

   - 类和对象

     1. 类 

        抽象笼统的概念，描述一类事物 具有相同的特征行为

        - 类的属性
        - 类的方法

     2. 对象

        类中一个具体的实体

     3. 如何在计算机中创建一个类

        - 创建一个类
        - 利用属性或方法描述这个类
        - 创建当前类的对象来使用类的属性或方法

     4. Demo

     ```java
     public class Person {
         //属性
         //必要的组成部分
         //  修饰符  数据类型  属性名称 [= 值]
         public String name; //全局属性
         public int age;
         public String sex;   //'男'  ‘女’
         //方法
     
     }
     ```

     ```java
     public class Test {
         public static void main(String[] args) {
             //创建一个对象 找一个空间存储
             Person p = new Person();
             //调用属性
             //堆内存中的空间有默认值
             p.name = "Martin";
             p.age = 18;
             p.sex = "男";
             System.out.println(p.name +"今年"+p.age+";");
     
             Person p1 = new Person();
             p1.name = "Jerry";
             p1.age = 18;
             p1.sex = "女";
             System.out.println(p1.name +"今年"+p1.age+";");
         }
     }
     ```

     

2. 面向对象之方法设计

   - 方法的结构

     权限修饰符   [特征修饰符]  返回值类型 方法名字（参数列表）[抛出异常]{

     ​				方法体

     }

     1. 无参数无返回值
     2. 无参数有返回值
     3. 有参数无返回值
     4. 有参数有返回值

   - Demo

     ```java
     public class Person {
         //属性
         //必要的组成部分
         //  权限修饰符 [特征修饰符] 数据类型  属性名称 [= 值]
         public String name; //全局属性
         public int age;
         public String sex;   //'男'  ‘女’
         //方法
         //设计一个方法 用来描述人类可以吃饭这件事情
         public void eat(){    //无参数无返回值
             System.out.println("Eat some food");
         }
     
         //设计一个方法，用来告诉别人我的名字
         //必须通过return关键字返回一个值
         public String tellName(){ //无参数有返回值
             System.out.println("Name: ");
             return "Jerry";
         }
     
         public void eatFood(int count,String foodName){  //无返回值有参数
             System.out.println("Eat "+count+" "+foodName);
         }
     
         public String buyDrink(int money){
             if(money >5){
                 return "Milk";
             }else {
                 return "Water";
             }
         }
     
         //画星星
         public void drawStar(int line,boolean f){
             //f=true偏左，f=false偏右
                 for(int i =1;i <=line;i++){
                     if(!f){
                         for(int j=1;j<=line-i;j++){
                             System.out.print(" ");
                         }
                     }
                     for(int j=1;j<=i;j++){
                         System.out.print("*");
                     }
                     System.out.println();
                 }
         }
     
     //        for(int i =1;i <=4;i++){
     //            for(int j=1;j<=4;j++){
     //                System.out.print("*");
     //            }
     //            System.out.println();
     //        }
     
     
     //    //画直角三角形
     //    public void drawStar2(int line){
     //
     //        for(int i =1;i <=line;i++){
     //            for(int j=1;j<=i;j++){
     //                System.out.print("*");
     //            }
     //            System.out.println();
     //        }
     //    }
     }
     ```

     ```java
     public class Test {
         public static void main(String[] args) {
             //创建一个对象 找一个空间存储
             Person p = new Person();
             p.drawStar(8,true);
             //p.drawStar();
             //p.drawStar2(9);
     
     //        //调用方法
     //        p.eat();
     //        String myName= p.tellName(); //创建一个变量存方法的返回值
     //        System.out.println(myName);
     //        p.eatFood(2,"noodle");
     //        String drinkName = p.buyDrink(10);
     //        System.out.println(drinkName);
         }
     }
     ```

     

3. 方法参数返回值

   ```java
   public class Test {
       public int changeNum(int x){
           System.out.println("Start: "+x);
           x = 10;
           System.out.println("End: "+x);
           return x;  //
       }
   
       public void changeArray(int[] x){
           System.out.println("Start: "+x[0]);
           x[0] = 10;
           System.out.println("End: "+x[0]);
       }
   /*
       public static void main(String[] args) {
   
           //创建一盒对象-前提：有类模板
           //类加载器
           Test t =new Test();  //堆内存中开辟空间
           int a = 1;
           //调用方法
           //方法存储在堆内存的对象空间内
           //栈内存中开辟一块临时的执行空间
           a = t.changeNum(a);
           System.out.println(a);
           //如果想让a的值变化，return返回值
           //输出结果：
           //Start: 1
           //End: 10
           //10
       }
       */
   
       public static void main(String[] args) {
           Test t = new Test();
           int[] a = new int[]{1,2,3};
           t.changeArray(a);
           System.out.println(a[0]);
           //注意数组为引用类型，会改变数组里面的值，实际传递的是数组的地址
       }
   }
   ```

   Demo01:

   ```java
   public class Demo {
   
       public int[][] changeTwoArray(int[] a,int[] b){
           //将两个数组的地址引用直接交换
           int[] tmp;
           tmp = a;
           a=b;
           b=tmp;
           int[][] result = {a,b};
           return result;
       }
   
       public static void main(String[] args) {
           //交换两个数组对应位置的元素
           int[] a = {1,2,3,4};
           int[] b = {5,6,7,8};
           Demo d = new Demo();
           int[][] value = d.changeTwoArray(a,b);
           a = value[0];
           b = value[1];
       }
   }
   ```

   Demo02

   ```java
   public class Functions {
   
       //找寻数组内最大值最小值问题
       public int findMaxOrMinNum(int[] array,boolean flag){
           int temp = array[0];
           for(int i = 0;i <array.length;i ++){
               if (flag && array[i]<temp){    //最小值
                   temp = array[i];
               }else if (!flag && array[i]>temp){  //最小值
                   temp = array[i];
               }
           }
           return temp;
       }
   }
   ```

   Demo03

   ```java
   public class TestFunctions {
   
       //冒泡排序
       //flag = true升序
       //flag = false 降序
       public void orderArray(int[] array,boolean flag){
           for(int i = 1;i <array.length;i ++){
               for(int j =array.length-1;j >=i;j --){ //控制比较的次数
                   if((flag == true && array[j]<array[j-1]) ||(flag ==false && array[j]>array[j-1])){
                       int tmp = array[j];
                       array[j] = array[j-1];
                       array[j-1] = tmp;
                   }
   //                if(flag){
   //                    if(array[j]<array[j-1]){
   //                        int tmp = array[j];
   //                        array[j] = array[j-1];
   //                        array[j-1] = tmp;
   //                    }
   //                }else {
   //                    if(array[j]>array[j-1]){
   //                        int tmp = array[j];
   //                        array[j] = array[j-1];
   //                        array[j-1] = tmp;
   //                    }
   //                }
               }
           }
       }
   }
   
   ```

   Demo04

   ```java
   public class TestFunctions {
       //用户数据信息
       String[][] userBox = {{"Martin","123456"},{"Tony","666666"},{"Java","888888"}};
       //用户输入登陆信息
       //提供用户名和密码  返回值
       public String login(String user,String password){
   
           String result = "用户名或密码不正确";
           for(int i=0;i<userBox.length;i++){
               if(userBox[i][0].equals(user)) {
                   if (userBox[i][1].equals(password)) {
                       result = "登陆成功";
                   }
                   break;
               }
           }
           return result;
       }
   }
   ```

   

4. 面向对象之方法重载

   - 概念
     1. 一个类中的一组方法 相同的方法名字 不同的参数列表 这样的一组方法，构成了方法重载

   - 作用：为了让使用者便于记忆与调用 只需要记录一个名字 执行不同的操作
     1. 参数的个数 参数的类型
     2. 调用方法的时候 首先通过方法名字定位方法
     3. 如果方法名字有一致 可以通过参数的数据类型定位方法
     4. 如果没有与传递参数类型一致的方法 可以找一个参数类型可以进行转化（自动）

   - JDK1.5之后 动态参数列表
     1. 动态参数列表的方法，不能与相同意义的数组类型方法构成方法重载  本质一样
     2. 动态参数列表在方法的参数中只能存在一份，并且放置在方法参数的末尾

   ```java
   public class TestOverLoad {
   
       public void test(int... x){   //动态参数个数
           //动态参数列表本质上为一个数组
           for (int i = 0;i <= x.length;i++){
               System.out.println("参数为"+x);
           }
       }
   
       public void test(boolean flag){
           System.out.println("参数为"+flag);
       }
   
       public void test(int a){
           System.out.println("参数为"+a);
       }
   
       public void test(String b){
           System.out.println("参数为"+b);
       }
   
       public static void main(String[] args) {
           //1.创建对象
           TestOverLoad t = new TestOverLoad();
           //2.调用方法
           t.test(false); //必须传参数个数，类型一致的参数
           System.out.println();  //println()-----方法  属于out对象
           System.out.println(232);
           System.out.println(t);
       }
   }
   ```

   

5. 构造方法

   - 类的内部成员：

     属性---静态描述类的特征

     方法---动态描述类的行为

     构造方法---用来创建当前类的对象

     程序块（代码块----无参数无返回值无名字的特殊方法）

   - 构造方法

     1. 作用：只有一个 构建（构造）当前类的对象

     2. 写法   权限修饰符    与类名一致的方法名（参数列表）{

        ​		创建一个对象

        ​		返回对象

        }

     3. 调用

        通过new关键字调用

     4. 特点

        - 每一个类都有构造方法，若自己在类中没有定义，系统会默认提供一个无参数的构造方法；若在类中自己定义了构造方法，则默认的构造方法会被覆盖
        - 构造方法存在构造方法重载

     5. 在创建对象的同时 想要一并做一些事情 默认提供的构造方法是不会做的

     6. this关键字的使用

        - 是一个关键字（指代词） 代替的是某一个对象（当前调用方法时的那个对象）

6. 类的第四个成员---程序块

   1. 作用：跟普通方法一样，实现功能

   2. 写法：{

      }

   3. 用法：块也需要调用才会执行

      每一次调用构造方法之前 系统会自动调用一次程序快

   4. 特点：无重载的概念，但是可以在类中定义和创建多个程序块

   5. 块里面写一些程序，在创建对象之前执行

   6. 

7. this关键字

   - this关键字的使用

     1. 是一个关键字（指代词） 代替的是某一个对象（当前调用方法时的那个对象）

     2. this可以调用属性 方法

     3. 可以放置在类中的任何成员位置 上下顺序随意

     4. 在一个构造方法内可以调用另一个构造方法

        通过this();省略构造方法的名字

        **必须在另一个构造方法中调用，且必须放在第一行**

   ```java
   public class Person {
   
       //属性
       public String name;
       public int age;
       public String sex;
   
       //构造方法
       public Person(){  //默认构造方法
   
       }
   
       public Person(String name,int age,String sex){  //自定义构造方法
           this.name = name;  //this.代替的是某一个对象（当前调用属性或方法时的那个对象）
           this.age = age;
           this.sex = sex;
       }
   
   
       {
           //程序块
           System.out.println("程序块");
       }
   }
   ```

   Tips：方法之间来回调用执行可能会产生`StackOverflowError` 栈溢出错误

   知识补充：Scanner类及其中方法的使用

   包装类：`String<------->int      int--Integer   char--Character   byte--Byte`

   `String password = input.nextLine()`

   `int value = Integer.parseInt(password)`

8. Demo01----计算器的实现

   ```java
   import java.util.Scanner;
   
   public class Calculator {
       //设计一个方法  加法运算
       public float add(float a, float b){
           return a + b;
       }
       //减法
       public float sub(float a, float b){
           return a - b;
       }
       //乘法
       public float multi(float a, float b){
           return a * b;
       }
       //除法
       public float devide(float a, float b){
           return a / b;
       }
       //控制计算流程
       public void calculate(){
           Scanner input = new Scanner(System.in);
           System.out.println("请输入第一个数字：");
           String one = input.nextLine();
           float a = Float.parseFloat(one);
           while (true) {
               System.out.println("请输入运算符：");
               String symbol = input.nextLine();
               if(symbol.equals("=")){
                   System.out.println("运行完毕");
                   break;
               }
               if(!(symbol.equals("+")||symbol.equals("-")||symbol.equals("*")||symbol.equals("/"))){
                   System.out.println("输入的运算符不支持[+ - * /]");
                   continue;
               }
               System.out.println("请输入第二个数字：");
               String two = input.nextLine();
               float b = Float.parseFloat(two);
   
               switch (symbol) {
                   case "+":
                       a = this.add(a, b);
                       break;
                   case "-":
                       a = this.sub(a, b);
                       break;
                   case "*":
                       a = this.multi(a, b);
                       break;
                   case "/":
                       a = this.devide(a, b);
                       break;
               }
               System.out.println(a);
           }
       }
   }
   
   //Scanner用法
   //1.从读取方式上来讲，除了nextLine外，其余方法都不读取回车符
   //2.读取的返回结果来讲
   //      next方法看到回车或空格都认为结束 nextLine只认回车符
   //利用包装类做String与基本类型转化的问题
   ```

   

9. 动态数组的实现

   异常处理：

   ```java
   public class BoxIndexOutOfBoundException extends RuntimeException{
       //想要描述这个类是一个（我们自己的异常 is a 异常）异常
       //继承extends  泛化（实现）implememts
       public BoxIndexOutOfBoundException(){}
       public BoxIndexOutOfBoundException(String msg){
           super(msg);  //msg提供给父类
       }
   }
   ```

   动态数组实现：

   ```java
   public class ArrayBox {
       //动态数组
       //描述事物
       //属性
       private int[] elementData;
       private int size = 0; //记录有效的元素个数
   
   
       //构造方法
       public ArrayBox(){
           elementData = new int[10];  //默认长度
       }
       public ArrayBox(int capacity){
           elementData = new int[capacity];
       }
   
       //负责创建一个新数组，并将旧元素移入
       //条件 新数组长度  需要提供旧数组
       //告知新数组的位置
       private int[] copyOf(int[] oldArray,int newCapacity){
           //创建一个新的数组
           int[] newArray = new int[newCapacity];
           //将旧数组元素移入新数组
           for(int i = 0;i< oldArray.length;i++){
               newArray[i] = oldArray[i];
           }
           return newArray;
       }
   
       //扩容数组
       //条件 需要扩的最小容量
       private void grow(int minCapacity){
           //获取旧数组的长度
           int oldCapacity = elementData.length;
           //以旧长度的1.5倍扩容
           int newCapacity = oldCapacity + (oldCapacity >> 1);  //右位移相当于除2
           //如扩容后还达不到要求，则直接利用minCapacity
           if(newCapacity-minCapacity < 0){
               newCapacity = minCapacity;
           }
           //按照新长度创建一个新的数组，并移动旧数组中的元素
           elementData = this.copyOf(elementData,newCapacity);
   
       }
   
       //计算数组容量
       //条件？ 需要的最小容量
       private void ensureCapacityInternal(int minCapacity){
           if(minCapacity - elementData.length > 0){  //存不下
               //扩容
               this.grow(minCapacity);
   
           }
       }
       //方法   添加元素方法
       // 参数？  返回值？
       public boolean add(int element){
           //确保属性数组容量
           this.ensureCapacityInternal(size + 1);
           elementData[size ++] = element;
           return true;
       }
   
   
       //帮忙判断给定index范围是是否合法
       //需要提供index
       private void rangeCheck(int index){
           if(index<0 ||index>=size){
               //自定义异常
               throw new  BoxIndexOutOfBoundException("Index:"+index+",Size:"+size);
           }
       }
       //获取元素方法
       //条件  提供元素的位置
       //返回值
       public int get(int index){
           //检测index范围是否合法>=0  <size
           this.rangeCheck(index);
           //如果上面执行顺利，证明index合法
           return elementData[index];
       }
   
       //删除元素
       //提供元素的位置   返回值---删除掉的那个元素
       public int remove(int index){
           //检测index范围
           this.rangeCheck(index);
           //保存index位置原始值
           int oldValue = elementData[index];
   
           for (int i = index;i<size-1;i++){
               elementData[i] = elementData[i+1]; //将后面位置元素向前移动覆盖
           }
           elementData[--size] = 0;
           return oldValue;
       }
   
       public int size(){
           return this.size;
       }
       //构造方法
   
       //程序块
   }
   
   ```

   测试验证：

   ```java
   public class Test {
       public static void main(String[] args) {
           //想要存储元素
           //创建对象
           ArrayBox box = new ArrayBox();
           //存储元素
           for(int i = 1;i <= 9; i++){
               box.add(i*10);
           }
           //System.out.println("有效元素个数："+box.size);
           //System.out.println("真实数组长度："+box.elementData.length);
   
           //获取第二个元素
           //int value = box.get(2);
           //System.out.println(value);
   
           //获取所有元素
           for (int i = 0;i < box.size();i++){
               int value = box.get(i);
               System.out.print(" "+value);
           }
   
           //删除2号位置的元素
           int removeValue = box.remove(2);
           System.out.println();
           System.out.println(removeValue);
           System.out.println(box.size());
           //查看删除后的数组
           for (int i = 0;i < box.size();i++){
               int value = box.get(i);
               System.out.print(" "+value);
           }
   
       }
   }
   
   ```

   