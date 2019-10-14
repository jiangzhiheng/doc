### **Java异常处理**

1. 程序运行过程中，可能会发生一些不被期望的效果，阻止我们的程序按照预定流程执行

   这种不被于其出现的效果，肯定需要抛出来告诉我们

2. 在Java中有一个定义好的规则`Throwable`（可以抛出的）

3. Error错误

   通常是一些物理性的，JVM虚拟机本身出现的问题，程序指令无法处理

4. Exception异常

   通常是认为规定的不正常的现象，通常是给定的程序指令产生了一些不符合规范的事情

5. Throwable

   - Error (`StackOverFlowError. OutOfMemoryError....`)
   - Exception
     - `RuntimeException`(运行时异常)
     - `IOExpetion`
     - ......

6. 异常的分支体系

   - 运行时异常(非检查异常)

     `Error`和`RuntimeException`都算作运行时异常

     `javac`编译的时候，不会提示和发现的，在程序编写时不要求必须做处理，

     如果我们愿意可以添加处理手段（try  throws）

     1. `ImputMisMatchException` 输入类型不匹配
     2. `NumberFormatException`  数字格式化异常
     3. `NegativeArraySizeException`  数组长度为负数
     4. `NullPointerException`  空指针异常
     5. `ArrayIndexOutOfException` 数组索引越界
     6. `ArithmeticException` 数学性异常   10/0
     7. `ClassCastException` 造型异常
     8. `StringIndexOutOfException`  字符串索引越界
     9. `IndexOutOfBoundsException` 集合越界
     10. `ILLegalArgumentException`  非法参数异常
     11. ........

   - 编译时异常(检查异常)

     除了Error和RuntimeException以外的其它异常

     javac编译的时候，强制要求我们必须为这样的异常做处理

     异常产生后，后续的所有执行就停止

7. 添加处理异常的手段

   处理异常指的是，处理掉异常之后 后续的代码不会因为此异常而终止执行

   两种手段

   try{}catch(){}[finally{}]

   1. try不能单独出现

   2. 后面必须添加catch或finally

   3. catch有一组()   ，目的是为了捕获某一种异常

   4. catch可以后很多个

      捕获的异常之间没有任何的继承关系

      捕获的异常需要从小到大进行捕获

   5. finally不是必须存在的

      若存在，则必须执行

      注意：final   finally  finalize区别

   6. 处理异常放在方法内部

      如果在方法内部含有返回值，不管return关键字在哪里，一定会执行finally

      返回值的具体结果，看情况

   ```java
   package test_throwable;
   
   public class Test {
   
       public String testException(){
           try {
               return "try中的返回值"; //事先约定好返回值
           }catch (Exception e){
               //e.printStackTrace(); //打印输出异常的名字
               System.out.println("捕获到了异常");
           }finally {
               System.out.println("finally");
           }
           return "最终的返回值";
       }
   
   
       public static void main(String[] args) {
           //ArithmeticException: / by zero
           //System.out.println(10/0);
           try {
               //String str = null;
               String str2 = "abc";
               //str.length();
               str2.charAt(10);
           }catch (NullPointerException e){
               System.out.println("NullPoint");
           }catch (StringIndexOutOfBoundsException e){
               System.out.println("字符串越界异常");
           }catch (Exception e){  //Exception范围最大
               System.out.println("其它异常");
           }finally {
               System.out.println("必须执行的块");
           }
       }
   }
   
   ```

   

   //======================================================

   throw抛出

   1. 异常只能是在方法内产生的，属性是不能处理异常的
   2. 方法可以抛出不止一个异常，通过,隔开
   3. 方法  构造方法都能throws出异常

   ```java
   package test_throwable;
   
   public class Test {
   
       public String testException() throws NullPointerException,StringIndexOutOfBoundsException{
           String str = null;
           str.length();
           return "最终的返回值";
       }
   
   
       public static void main(String[] args) {
           Test te = new Test();
           try {
               te.testException();
           }catch (Exception e){
               System.out.println("捕获到异常");
           }
   
       }
   }
   
   ```

   

8. 自定义异常

   1. 自己描述一个异常的类

   2. 让我们自己的类继承

      如果继承的是`RuntimeException`---->运行时异常(不需要必须添加处理手段)

      如果继承是Exception------->编译时异常(必须添加处理手段)

   3. 创建一个当前自定义类的对象

      通过throw关键字，主动产生异常

   4. 当我们设计描述的方法(事情) 之前没有相关的异常能描述我的问题，这个时候才会用到自定义异常

   ```java
   public class MyException extends Exception{
       public MyException(){};
       public MyException(String msg){
           super(msg);
       }
   }
   ```

   ```java
   public class Test {
       public void testMyexception()throws MyException{
           System.out.println("测试自定义异常");
           if (3>2){  //若满足某个条件
               throw new MyException("说明异常问题");
           }
       }
   
       public static void main(String[] args) {
           Test te = new Test();
           try {
               te.testMyexception();
           }catch (Exception e){
               System.out.println("捕获到异常");
           }
   
       }
   }
   ```