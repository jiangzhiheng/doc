1. 枚举类enum

   一个类中的对象 认为个数是有限且固定的 可以挨个将每一个对象一一列举出来

   手动设计

   - private构造方法

   ```java
   package myenum;
   
   public class Day { //描述星期 7个
       //类似单例模式
       private Day(){}
   
       //所有对象都是属性
       public static final Day monday = new Day();
       public static final Day tuesday = new Day();
       public static final Day wendesday = new Day();
       public static final Day thursday = new Day();
       public static final Day friday = new Day();
       public static final Day saturday = new Day();
       public static final Day sunday = new Day();
   
       //一般属性
   }
   ```

   - public static final 属性 = new

   JDk1.5之后可以手动定义enum类型,我们自己定义的enum类型直接默认继承Enum（java.lang包）

   - name属性：枚举对象名字 name()获取name属性
   - ordinal属性：枚举对象在类中的顺序，类似index 从0开始 ordinal获取ordinal属性

   一些常用的方法

   - valueOf():通过给定的name获取对应的枚举对象
   - values():获取全部的枚举对象，返回一个数组 Day[]
   - compareTo():可以比较两个枚举对象
   - toString()：该方法可以重写

   <u>**switch中enum的应用**</u>

   我们也可以在enum中描述自己的一些属性或方法，不常用

   - 必须在enum类中第一行 描述以下枚举的样子，需要以分号结束；
   - 可以定义自己的属性
   - 类创建过程中 帮我们创建枚举类型的对象
   - 需要给枚举类型提供对应样子的构造方法 构造方法只能private修饰  可以重载

   ```java
   package myenum;
   
   public enum Day {
   
       //描述了当前类的七个对象
       monday,thesday,wednesday,thursday,friday,saturday,sunday
   }
   
   ```

   ```java
   package myenum;
   
   import java.util.Scanner;
   
   public class Test {
       public static void main(String[] args) {
           //Day day = Day.thesday;
           //day---->枚举类型的对象 默认继承object hashCode toString等方法
           //除了继承Object类的方法之外，还有一些别的当法 ，证明我们自己创建的enum类型默认继承了Enum类
           //我们自己定义的每一个enum类型，都会默认继承Enum
           //Day[] days = Day.values();
   //        for (Day d:days){
   //            System.out.println(d.name()+"--"+d.ordinal());
   //        }
   
   //        Day d =  Day.valueOf("sunday");
   //        System.out.printf(d.name()+"--"+d.ordinal());
   
           //输入一个字符串monday 输出对应的信息
           Scanner input = new Scanner(System.in);
           System.out.println("Please input a word:");
           String key = input.nextLine();
           Day day = Day.valueOf(key);
           switch (day){ //1.5之前只能使用int byte  1.6 enum 1.8 String
               case monday:
                   System.out.println("星期一");
                   break;
               case thesday:
                   System.out.println("星期二");
                   break;
               case wednesday:
                   System.out.println("星期三");
                   break;
           }
       }
   }
   ```

   

2. 