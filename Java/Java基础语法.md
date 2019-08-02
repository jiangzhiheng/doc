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

     

3. 循环结构

   - for
   - while
   - do...while

4. 

