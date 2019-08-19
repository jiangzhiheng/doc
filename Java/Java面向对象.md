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

     

2. 