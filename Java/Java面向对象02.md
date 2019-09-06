1. 类的关系之继承

   A is a B泛化（继承  实现）

   A has a B 包含（组合  聚合  关联）

   A use  a  B  依赖

   1. 继承

      子类  父类

      - 子类继承父类，通过一个关键字 `extends`

      - 子类可以调用父类中（public protected）的属性和方法，拿来自己用

      - 子类可以添加自己独有的方法或功能

      - 子类从父类中继承过来的方法不能满足子类要求，可以在子类中重写（覆盖）父类的方法override

      - 重写（产生两个继承关系的类，子类重写父类的方法）

      - 方法重载（一个类中的一组方法）

      - 每一个类都有继承类，默认继承Object。如果不写extends，默认继承Object

        可以理解为Object类非常重要，是任何一个引用类型的父类

        1. object类中的方法

           `toString();`  //打印输出时将一个对象编程字符串

           `hashCode();`  //将对象在内存中的地址进行计算得到一个int整数

           `equals();`    //用来比较两个对象的内容

           `getClass();`  //获取对象对应类的类映射（反射）

           `wait();`      //线程进入挂起等待状态，存在方法重载

           `notify();`    //方法唤醒

           `notifyAll();` //唤醒所有

           `finalize();`  //权限修饰符是`protected`  在对象被GC回收的时候，默认调用执行的方法

           `clone();`     //权限修饰符是`protected`

      - Java中继承是单个存在的（单继承）每一个类只有一个继承类

        目的是为了让类变得更安全

      - 可以通过传递的方式实现多继承的效果  后续还会有多实现的效果

      - 继承在内存中的存储形式

   2. 关于this和super的用法（*重要）

      - this和super都是指代词 代替的是对象
      - this代替的是当前执行方法时的那个对象，不一定是当前类的
      - super代替的是当前执行方法时的对象的父类对象
      - 都能调用一般属性和一般方法
      - 可以放置在类成员的任意位置
      - 可以调用构造方法（放在构造方法的第一行）
        1. 构造方法之间不能来回调用
        2. this和super在构造方法中调用另一个类的构造方法不能同时出现在第一行
      - 

   3. Demo

      ```java
      public class Animal {
          public String name;
      
          public void eat(){
              System.out.println("Eat");
          }
      
          public void sleep(){
              System.out.println("Sleep");
          }
      
          //public protected  默认不写  private
          //子类的权限修饰符可以大于等于父类
          //特征修饰符 final static abstract
          //父类方法是final   子类不能重写
          //父类方法是static  子类不存在
          //父类方法是abstract 子类必须重写，否则子类是抽象类
      }
      ```

      ```java
      public class Person extends Animal {
      
          //方法重写
          public void eat(){
              System.out.println("Eat 。。。。。");
          }
          //添加一些独有的方法或属性
          public void study(){
              System.out.println("Study");
          }
      }
      
      ```

      Tips：
      
      1. 包Package
      
         类的第一行会出现package关键字
      
         如果package和import同时出现，先写package后写import
      
         package只能有一个，import可以有多个
      
         

2. 类的关系之包含和依赖

   1. has-a    包含关系（组合  聚合  关联）

      ​								亲密成都不一样

      组合----->整体和部分的关系，不可分割，关系最紧密

      聚合----->整体和部分的关系，创建时有可能是分开的

      关联----->可以分割，后期组合程一起

      从Java程序来描述这样的关系 通过一个类的对象当作另一个类的属性来存储

      Demo：

      ```java
      package contains;
      
      public class Wheel {
          //属性
          public String brand; //品牌
          public int size;
          public String color; //颜色
      
          //方法
          public Wheel(){}
      
          public Wheel(String brand,int size,String color){
              this.brand = brand;
              this.size = size;
              this.color = color;
          }
      
      
          public void turn(){
              System.out.println("旋转");
          }
      }
      
      ```

      ```java
      package contains;
      
      public class Car {
          //属性
          public String brand; //汽车品牌
          public String type;  //型号
          public String color; //颜色
          public Wheel whell;  //车里面有一个轮子--->包含关系
      
          //方法
          public Car(){}
      
          public Car(String brand,String type,String color,Wheel wheel){
              this.brand = brand;
              this.type = type;
              this.color = color;
              this.whell = wheel;
          }
      
          public void showCar(){
              System.out.println("这是一辆"+brand+"品牌"+type+"型号"+color+"的小汽车");
              System.out.println("车上搭载着"+whell.brand+"品牌的"+whell.size+"尺寸"+whell.color+"颜色的车轮子");
              whell.turn();   //方法一定是对象调用的
          }
          
      }
      ```

      ```java
      package contains;
      
      public class Test {
          public static void main(String[] args) {
              Car car = new Car("BMW","Z4","宝石蓝",new Wheel("米其林",400,"黑色"));
              car.showCar();
          }
      }
      ```

      

   2. use-a   依赖

      不是整体和部分的关系 某一件事产生了关系，临时组合在一起 ，这件事情一旦完成关系即解散

      一个类的方法中使用到了另一个类的对象

      - 在方法中传递参数
      - 在方法中自己创建

      设计类的关系遵循的原则：高内聚低耦合

      紧密程度：紧密  继承>包含>依赖

   3. 

3. 类和类关系Demo

   ```java
   package computer;
   
   public class Student {
   
       private String name;
   
       public Student(){}
       public Student(String name){
           this.name = name;
       }
       //依赖关系
       public void useComputer(Computer computer){
           System.out.println(this.name+"开始使用电脑");
           computer.beOpen();
           computer.beUsing();
           computer.beClose();
       }
   
       public String getName(){
           return this.name;
       }
   }
   ```

   ```java
   package computer;
   
   public class Computer {
       //属性  开 关
       private boolean used = false; //true 开 false 关
       private int number;
   
       //构造方法
       public Computer(){}
       public Computer(int number){
           this.number = number;
       }
   
       //设计普通方法  打开 使用 关闭
   
       public void beOpen(){
           this.used = true;
           System.out.println(this.number+"号被打开");
       }
   
   
       public void beClose(){
           this.used = false;
           System.out.println(this.number+"号被关闭");
       }
   
       public void beUsing(){
           System.out.println(this.number+"号在使用中");
       }
   
       //获取状态和编号
       public int getNumber(){
           return this.number;
       }
   
       public boolean isUsed(){
           return this.used;
       }
   
   }
   
   ```

   ```java
   package computer;
   
   public class MachineRoom {
       //机房内有一台电脑
   
       //数组 ：存储5台电脑Computer[]
       public Computer[] computers = new Computer[5];
   
       //该方法迎来给数组初始化
       public MachineRoom(){  //也可以用程序块解决
           this.init();
       }
       //=============================程序块===================
   //    {
   //        for (int i = 0;i <computers.length;i++){
   //            computers[i] = new Computer(i+1);
   //        }
   //    }
       //===========================================================
       public void init(){
           for (int i = 0;i <computers.length;i++){
               computers[i] = new Computer(i+1);
           }
       }
   
       //机房--学生  依赖关系
       public void welcomeStudent(Student student){
           String studentName = student.getName();
           System.out.println("欢迎"+studentName+"进入机房");
           //使用电脑
           //进入机房后找出一台状态关闭的电脑
           for (int i = 0;i < computers.length;i++){
               boolean computerStatus = computers[i].isUsed();
               if(!computerStatus){
                   student.useComputer(computers[i]);
                   break;
               }
           }
           //student.useComputer(computers[]);
   
       }
   }
   ```

   ```java
   package computer;
   
   public class Test {
       public static void main(String[] args) {
           MachineRoom room = new MachineRoom();
           Student student = new Student("Martin");
           room.welcomeStudent(student);
       }
   }
   ```

   

4. 修饰符

   权限修饰符

   - public
   - protected
   - 默认不写
   - private

   特征修饰符

   - final     最终的 不可更改的
   - static    静态的
   - abstract    抽象的
   - native  本地的
   - transient   瞬时的 短暂的
   - synchronized    同步的
   - volatile   不稳定的

   <u>***权限修饰符***</u>

   1. 权限修饰符可以用来修饰类本身 和类中的成员（除程序块）

   2. 权限修饰符用来修饰类的时候只有两个可以用（public  默认不写）

   3. 权限修饰符都可以用来修饰类中的其它成员

      | 权限修饰符 |        |                                                  |
      | :--------: | ------ | :----------------------------------------------: |
      |   public   | 公共的 | 本类 ，同包，子类   任意类的位置只要有对象都可以 |
      | protected  | 保护的 |  本类，同包，子类（通过子类对象在子类内部访问）  |
      |  默认不写  | 默认的 |                    本类，同包                    |
      |  private   | 私有的 |                      本类，                      |

   4. 面向对象特征之封装：将一些数据或执行过程进行包装，保护这些数据或执行过程的安全

   <u>***特征修饰符***</u>

   **final**

   1. 可以修饰什么

      final                  最终的 不可更改的

      修饰变量

      - 如果在定义变量时没有赋初始值，给变量一次存值的机会，一旦被存储值后，则不可被修改，相当于一个常量
      - 注意变量类型是基本类型还是引用类型，基本类型变量值不能改变，引用类型变量的地址不允许改变

      修饰属性

      - 全局变量，存储在堆内存的对象空间内的一个空间，属性如果没有赋值，有默认值存在的
      - 属性用final修时候 必须赋初始值，否则编译报错 特点与修饰变量一直

      修饰方法

      - 方法是最终的方法 不可更改
      - final修饰的方法要求不可以被子类重写（覆盖）

      修饰类本身

      - 类是最终的，不可更改
      - 此类不可被其它子类继承，通常都是一些定义好的工具类
      - 例如`Math Scanner Integer  String`


   **static**

   1. 可以修饰什么

   2. 修饰后有什么特点

      修饰属性，修饰方法，***修饰快***，修饰类（内部类）

      特点：

      - 静态元素在类加载时就已经初始化，创建的非常早，此时没有创建对象
      - 静态元素存储在静态元素区中，每一个类有一个自己的区域，与别的类不冲突
      - 静态元素只加载一次（只有一份），全部类对象及类本身共享
      - 由于静态元素区加载的时候，有可能没有创建对象，可以通过类名字直接访问
      - 可以理解为静态元素不属于任何一个对象，属于类的
      - 内存管理 栈内存创建开始用完即回收 ，堆内存GC回收，静态元素去GC无法管理，可以粗暴的认为内存常驻
      - 非静态成员（堆内存对象里）中访问静态成员（静态区）
      - 静态成员中可以访问静态成员（都存在静态区中）
      - 静态成员中不可以访问非静态成员（静态元素属于类，非静态成员属于对象）
      - 静态元素中不可以出现this或super关键字

      Demo

      ```java
      package bookStore;
      
      public class BookShop {
      
          private static final int BOOKSTORE_ADMIN = 0;   //私有静态常量
          private static final int BOOKSTORE_VIP = 1;
          private static final int BOOKSTORE_NORMAL = 2;
      
          //打折的计算方法
          public void buyBook(float price,int identity){  //买书方法
              switch (identity){
                  case BookShop.BOOKSTORE_ADMIN:  //管理员
                      System.out.println("管理员5折:"+price*0.5);
                      break;
                  case BookShop.BOOKSTORE_VIP:  //VIP
                      System.out.println("VIP 8折:"+price*0.8);
                      break;
                  case BookShop.BOOKSTORE_NORMAL:  //普通用户
                      System.out.println("普通用户0折:"+price*1);
                      break;
                  default:
                      System.out.println("输入有误");
                      break;
              }
          }
      }
      ```

      ```java
      package bookStore;
      import java.util.Scanner;
      
      public class TestMain {
          public static void main(String[] args) {
              BookShop bookStore = new BookShop();
              Scanner input = new Scanner(System.in);
              System.out.println("请输入价格");
              float price = input.nextFloat();
              System.out.println("请出示身份");
              int identity = input.nextInt();
              bookStore.buyBook(price,identity);
          }
      }
      
      ```

      

3. 单例模式Singleton

   设计模式

   - 设计模式用来解决某些场景下的某一类问题的------>通用的解决方案

   设计模式分为三类

   1. 创建型模式------>用于解决对象创建的过程

      *单例模式  工厂方法模式   抽象工厂模式   建造者模式  原型模式*

   2. 结构型模式------>把类和对象通过某种形式结合在一起，构成某种复杂或合理的结构

      *适配器模式  装饰者模式  代理模式  外观模式  桥接模式  组合模式 享元模式*

   3. 行为型模式------>用来解决类和对象之间的交互，更合理的优化类或对象之间的关系

      *观察者模式  策略模式   模板模式   责任链模式  解析器模式  迭代子模式 命令模式  状态模式*

      *备忘录模式  访问者模式 中介者模式* 

   单例模式

   - 设计-->一个类只能创建一个对象，有效减小内存占用空间

   单例模式的实现

   1. 私有的构造方法
   2. 私有的静态的当前类作为属性
   3. 共有的静态的方法返回当前类对象

   对象的加载模式

   1. 立即加载

      ```java
      package singleton;
      
      public class SingleTon {
          //通过设计，让这个类只能创建一个对象
      
          //默认无参数构造方法---公有,在外面可以随意创建
          //1.让构造方法变成私有，外面无法随便创建
          private SingleTon(){}
      
          //2.单例 在本类中的某个成员位置上创建唯一的一个对象
          //在类中的某一成员中写一行new SingleTon
          //属性
          //方法 -----每次执行都会产生一个过程，无法保证唯一
          //构造方法 ----私有
          //块 -----无返回值，创建对象也无法给别人使用
          //3.在当前类中存在私有静态一个属性，属于当前类类型
          private static SingleTon single = new SingleTon();   //直接加载
      
          //4.提供一个获取单个对象的方法
          public static SingleTon getSingleTon(){  //get类名 newInstance
              return single;
          }
      
      }
      ```

      ```java
      package singleton;
      
      public class Test {
          public static void main(String[] args) {
              //SingleTon single = new SingleTon();
              SingleTon s1 = SingleTon.getSingleTon();
              SingleTon s2 = SingleTon.getSingleTon();
              System.out.println(s1==s2);  //true比较地址
              System.out.println(s1.equals(s2)); //默认比地址
              System.out.println(s1);
              System.out.println(s2);
          }
      }
      //true
      //true
      //singleton.SingleTon@1b6d3586
      //singleton.SingleTon@1b6d3586
      ```

      

   2. 延迟加载

      ```java
      package singleton;
      
      public class SingleTon {
          private SingleTon(){}
          private static SingleTon single ;
          public static SingleTon getSingleTon(){  //get类名 newInstance
              if (single == null){
                  single = new SingleTon();  //延迟加载的方式
              }
              return single;
          }
      }
      ```

   3. 生命周期托管

   

4. 