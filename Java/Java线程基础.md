### **线程**

- 程序    

  可以理解为一组静态的代码

- 进程

  正在运行的程序  运行起来的代码

- 线程

  正在执行的程序中的小单元

- 主线程     系统线程
- 用户线程     main
- 守护线程      GC

1. 线程的几种不同状态 及状态之间如何切换

   创建线程---->就绪状态---->执行状态----->等待/挂起---->异常/死亡

   new					start()             run()                wait()             exception over

   notify/notifyAll

2. Java线程的使用

   - 自己实现一个类
   - 继承父类Thread
   - 重写run()方法
   - new一个线程对象   调用start()方法  让线程进入就绪状态

   ```java
   package testthread;
   
   public class Runer extends Thread{
       private String name;
       public Runer(){}
       public Runer(String name){
           this.name = name;
       }
       //重写run方法
       public void run(){
           for (int i=0;i<=100;i++){
               System.out.println(this.name+"跑了"+i+"米了");
           }
       }
   }
   
   ```

   ```java
   package testthread;
   
   public class TestMain {
       public static void main(String[] args) {
           //1.创建一个线程对象
           Runer r1 = new Runer("Martin");
           Runer r2 = new Runer("Jerry");
           Runer r3 = new Runer("Tony");
           //调用start方法，让线程进入就绪状态
           r1.start();
           r2.start();
           r3.start();
       }
   }
   ```

3. 实现线程的过程2

   - 自己描述一个类
   - 实现一个父接口implements Runnable
   - 重写run方法

   ```java
   package testthread;
   
   public class Runer implements Runnable{
       private String name;
       public Runer(){}
       public Runer(String name){
           this.name = name;
       }
       //重写run方法
       public void run(){
           for (int i=0;i<=100;i++){
               System.out.println(this.name+"跑了"+i+"米了");
           }
       }
   }
   
   ```

   ```java
   package testthread;
   
   public class TestMain {
       public static void main(String[] args) {
           //1.创建一个线程对象
           Runer r1 = new Runer("Martin");
           Runer r2 = new Runer("Jerry");
           Runer r3 = new Runer("Tony");
           //调用start方法，让线程进入就绪状态
           Thread t1 = new Thread(r1);
           Thread t2 = new Thread(r2);
           Thread t3 = new Thread(r3);
           t1.start();
           t2.start();
           t3.start();
       }
   }
   
   ```

4. Demo

   模拟火车站售票

   ```java
   package system_tickets;
   
   import java.nio.channels.FileLock;
   
   public class Ticket {
       /*
       * 起始站
       * 终点站
       * 票价
       * 只包含一些基本属性 每个对象一个小容器
       * 一个对象包含很对属性，增强可读性  POJO  JavaBean
       * */
       private String start;
       private String end;
       private Float price;
   
       public Ticket(){}
       public Ticket(String start,String end,Float price){
           this.start = start;
           this.end = end;
           this.price = price;
       }
   
       public String toString(){
           StringBuilder stringBuilder = new StringBuilder("[");
           stringBuilder.append(this.start);
           stringBuilder.append("-->");
           stringBuilder.append(this.end);
           stringBuilder.append(":");
           stringBuilder.append(this.price);
           stringBuilder.append("]");
           return stringBuilder.toString();
       }
   
       public String getStart() {
           return start;
       }
   
       public String getEnd() {
           return end;
       }
   
       public Float getPrice() {
           return price;
       }
   
       public void setStart(String start) {
           this.start = start;
       }
   
       public void setEnd(String end) {
           this.end = end;
       }
   
       public void setPrice(Float price) {
           this.price = price;
       }
   
   }
   
   ```

   ```java
   package system_tickets;
   
   import java.util.Vector;
   
   public class System12306 {
       /*
       * 属性 集合 ArrayList  Vector Stack
       * Vector线程安全
       * */
       private Vector<Ticket> tickets = new Vector<>();
   
       //单例模式
       private System12306(){}
       private static System12306 sys = new System12306();
       public static System12306 getInstance(){
           return sys;
       }
   
       //当前系统创建后给tickets集合赋值
       {
           for (int i=10;i<100;i++){
               tickets.add(new Ticket("beijing"+i,"shenzhen"+i,(i%5+5)*25F));
           }
       }
       //设计一个方法从几何中获取一张票
       public Ticket getTicket(){
           try {
               return tickets.remove(0);
           }catch (Exception e){
               return null;
           }
   
       }
   }
   
   ```

   ```java
   package system_tickets;
   
   public class Window extends Thread {
       private String windosName;//窗口名称
   
       public Window(String windosName){
           this.windosName = windosName;
       }
   
       public void run(){
           this.seleTicket();
       }
   
       public void seleTicket(){
           while (true){
               System12306 sys = System12306.getInstance();
               Ticket ticket = sys.getTicket();//Vector
               if (ticket==null){
                   System.out.println(windosName+"已售完");
                   break;
               }
               System.out.println(windosName+"售出一张票："+ticket);
           }
       }
   }
   
   
   ```

   ```java
   package system_tickets;
   
   public class TestMain {
       public static void main(String[] args) {
           Window w1 = new Window("北京");
           Window w2 = new Window("北京西");
           Window w3 = new Window("北京南");
           w1.start();
           w2.start();
           w3.start();
       }
   }
   
   ```

5. 