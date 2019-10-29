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


### **生产者消费者模型**

- Demo：

  ```java
  package producer;
  
  import java.util.ArrayList;
  
  public class Warehorse {
      //创库里面的集合
      private ArrayList<String> arrayList = new ArrayList<>();
  
      //向集合内添加元素
      public synchronized void add(){
          if (arrayList.size()<20){
              arrayList.add("a");
          }else {
              //return; //让方法执行到这里结束
              try {
                  this.notifyAll();
                  this.wait();   //不是仓库wait，而是访问仓库的线程wait，生产者
              } catch (InterruptedException e) {
                  e.printStackTrace();
              }
          }
      }
  
      //取元素
      public synchronized void get(){
          if (arrayList.size()>0){
              arrayList.remove(0);
          }else {
              //return;
              try {
                  this.notifyAll();
                  this.wait();  //不是仓库wait，而是访问仓库的线程wait，消费者
              } catch (InterruptedException e) {
                  e.printStackTrace();
              }
          }
      }
  }
  
  ```

  ```java
  package producer;
  
  public class Producer extends Thread{
  
      //为了保证生产者和消费者使用同一个仓库对象，添加一个属性
      private Warehorse warehorse;
      public Producer(Warehorse warehorse){
          this.warehorse = warehorse;
      }
  
      //生产者中的run方法
      public  void run(){
          while (true){
              warehorse.add();
              System.out.println("生产者存入一个元素");
              try {
                  Thread.sleep(200);
              } catch (InterruptedException e) {
                  e.printStackTrace();
              }
          }
      }
  }
  
  ```

  ```java
  package producer;
  
  public class Consumer extends Thread {
  
      private Warehorse warehorse;
      public Consumer(Warehorse warehorse){
          this.warehorse = warehorse;
      }
      //消费者的方法，一直拿元素
      public void run(){
          while (true){
              warehorse.get();
              System.out.println("消费者获取了一个元素");
              try {
                  Thread.sleep(300);
              } catch (InterruptedException e) {
                  e.printStackTrace();
              }
          }
      }
  }
  
  ```

  ```java
  package producer;
  
  public class TestMain {
      public static void main(String[] args) {
          Warehorse warehorse = new Warehorse();//里面有一个ArrayList
  
          Producer p = new Producer(warehorse);
          //设置线程的优先级别1-10
          p.setPriority(10);
          Consumer c1 = new Consumer(warehorse);
          Consumer c2 = new Consumer(warehorse);
          p.start();
          c1.start();
          c2.start();
      }
  }
  
  ```

1. 通过这个模型演示了线程安全问题

   两个消费者同时访问一个仓库对象， 仓库内只有一个元素的时候

   两个消费者并发访问，可能会产生抢夺资源的问题

2. 解决线程安全问题

   让仓库对象被线程访问的时候，仓库对象被锁定

   `synchorized`   同步，一个时间点只有一个线程访问

   线程安全锁

   - 将`synchronized`关键字，放在方法的结构上

     `public synchronized void test(){}`

     锁定的是调用方法时的那个对象

   - 将`synchronized`关键字放在方法的内部

     public void get(){

     ​		代码

     ​		synchronized(对象){

     ​				代码

     ​		{

     ​		代码

     }

3. 将return修改为wait状态

   `wait()   Object`类中的方法

   对象.wait()    ：不是当前的这个对象wait，而是访问当前这个对象的线程wait

   `notify   notifyAll`

   假死状态，所有线程进入等待状态

4. 通过上述生产消费者模型

   - 利用线程安全锁 特征修饰符 `synchronized`,两种不同的写法

   - 利用方法控制线程状态的来回切换

     `wait    notify    notifyAll`

   - Thread类中的方法

     sleep方法  静态方法(参数 long)

     `setPriority(10)`  设置优先级

     `getPriority();`

### **join方法&死锁&Timer**

1. join方法

   两个线程并行变成单线程

   ```java
   package testjoin;
   
   public class Thread1 extends Thread{
       public void run(){
           System.out.println("Thread-one Start");
           Thread2 thread2 = new Thread2();
           thread2.start();
           try {
               thread2.join(2000);  //线程2加入线程1里面
               /*
               * 1.有两个线程， two加入one，在one的run里面创建
               * 2.thread2.join();
               * 3.synchronized 一旦有对象被锁定，不释放的情况下，其它对象都要等待
               * */
           } catch (InterruptedException e) {
               e.printStackTrace();
           }
           System.out.println("Thread=ont End");
       }
   }
   ```

   ```java
   package testjoin;
   
   public class Thread2 extends Thread{
       public void run(){
           System.out.println("Thread-two Start");
           Thread3 thread3 = new Thread3(this);
           thread3.start();
   
           try {
               Thread.sleep(5000);
           } catch (InterruptedException e) {
               e.printStackTrace();
           }
           System.out.println("Thread-two End");
       }
   }
   
   ```

   ```java
   package testjoin;
   
   public class Thread3 extends Thread{
       private Thread2 thread2;
       public Thread3(Thread2 thread2){
           this.thread2 = thread2;
       }
       //在two执行的过程中，one等待的过程中  three将two锁定
       public void run(){
           System.out.println("Thread-three Start");
           synchronized (thread2){
               System.out.println("thread2 is locked");
               try {
                   Thread.sleep(10000);
               } catch (InterruptedException e) {
                   e.printStackTrace();
               }
               System.out.println("thread2 is free");
           }
           System.out.println("Thread-three End");
       }
   }
   
   ```

   ```java
   package testjoin;
   
   public class TestMain {
       public static void main(String[] args) {
           Thread1 thread1 = new Thread1();
           thread1.start();
       }
   }
   ```

2. 死锁的效果

   经典的哲学家就餐问题

   解决：

   - 时间差
   - 不要产生对象共用的问题

### **计时器/定时器---->线程应用**

1. Timer类

2. 示例

   ```java
   package timer;
   
   import java.text.ParseException;
   import java.text.SimpleDateFormat;
   import java.util.ArrayList;
   import java.util.Date;
   import java.util.Timer;
   import java.util.TimerTask;
   
   public class TestTimer {
   
       //设计一个方法
       //每隔一段时间发送一些数据
       //属性  集合
       private ArrayList<String> userBox = new ArrayList<>();
       {
           userBox.add("a");
           userBox.add("b");
           userBox.add("c");
           userBox.add("d");
       }
   
       public void test() throws ParseException {
           Timer timer = new Timer();
           SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
           Date firstTime = simpleDateFormat.parse("2019-10-29 10:45:00");
           timer.schedule(new  TimerTask(){
               @Override
               public void run() {
                   for (int i=0;i<userBox.size();i++){
                       System.out.println("给"+userBox.get(i)+"发送了一条消息");
                   }
               }
           },firstTime,3000);
       }
   
       public static void main(String[] args) {
           TestTimer testTimer = new TestTimer();
           try {
               testTimer.test();
           } catch (ParseException e) {
               e.printStackTrace();
           }
       }
   }
   
   ```

   