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

      

2. 