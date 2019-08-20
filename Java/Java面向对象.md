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

     

3. 