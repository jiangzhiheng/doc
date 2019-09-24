1. ### **枚举类enum**

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

   

2. ### **Runtime**

   堆内存------->new创建的对象 Garbage Collection垃圾回收

   Runtime类中提供了几个管理内存的方法

   Object类中有一个finalize方法，如果重写也能看见对象回收

   GC----->系统提供的一个线程 回收算法

   OutOfMemoryError 堆内存溢出

   ```java
   public class Test {
       public static void main(String[] args) {
   
           //1.抽象类 或者 接口 2.无参数的构造方法没有 3.构造方法私有
           //Runtime r = new Runtime();
   
           //堆内存中的内存
           Runtime r = Runtime.getRuntime();
           long max = r.maxMemory();
           long total = r.totalMemory();
           long free = r.freeMemory();
           System.out.println(max);
           System.out.println(total);
           System.out.println(free);
       }
   }
   ```

   Java开发者写好的类

   - 包装类
   - 数学相关
   - 日期相关
   - 字符串
   - 集合相关
   - 异常相关
   - 输入输出相关I/O 流
   - 线程相关
   - 网络通信相关
   - 反射注解

3. ### **包装类（封装类）**

   1. 类所在的包 
   2. 类的关系
   3. 常用方法
   4. 是否可以创建对象

   `byte---Byte  short---Short  int---Integer   long---Long`

   `float---Float  double---Double  char-Character  boolean---Boolean`

   1. 八个包装类都在同一个包下，`java.lang`包，不需要import直接使用

   2. 八个包装类中6个与数字相关，默认继承Number类，

   3. 八个包装类都实现了`Serializable, Comparable`接口

   4. 每一个类中的构造方法

      - 八个包装类都有带自己对应参数类型的构造方法

      - 八个包装类中有七个（除了Character）还有构造方法重载 带String类型

   5. 创建对象，调用方法

      - 有6个与数字相关的类都继承`Number xxxValue();`将一个包装类类型转化为对应的基本类型（拆包）

      - `Integer i1 = new Integer(10);`

        `int value = i1.intValue`

        `// int value = Integer.parseInt("123");`

   6. tips

      1. ==与equals()的区别

         ==可以比较基本数据类型 也可以比较引用类型数据（变量中存储的内容）

         如果比较基本类型，比较变量中存储的值

         如果比较引用类型，比较变量中存储的地址引用

         默认equals()方法比较与==一致

         Integer类重写了equals()方法，所以比较的是数值

      2. Integer类加载的时候，自己有一个静态的空间

         空间内立即加载integer类型的数组，内存储256个Interger对象 -128~127

         如果使用的对象在这范围内，直接从静态区中找对应的对象，否则在堆内存中创建

   

4. ### **数学相关**

   1. 所属`java.lang`包

   2. Math构造方法私有，不能直接创建对象

   3. Math中提供的属性及方法都是static

   4. 常用方法

      - `abs()  `绝对值
      - `ceil() 向上取整 floor() 向下取整 rint()  round()四舍五入整数`  返回临近的整数
      - `max(a,b)  min(a,b)`
      - `pow(a,b)` 计算a的b次方
      - `sqrt(a)` 获取给定参数的平方根
      - `double = random()`  随机产生一个【0.0-1.0】之间的随机数

   5. 0-9之间的随机整数

      `int value = (int)(Math.random()*10);`

   6. `Math.random()`计算小数的时候精确程度可能会有损失

   7. UUID类

      - Java.util包 需要import导入

      - 无任何继承关系

      - 构造方法  没有无参数构造方法

      - 基本用法

        ```java
            UUID uuid = UUID.randomUUID();
            System.out.println(uuid.toString());
        //产生一个32位16进制的随机数
        ```

   8. BigInteger类

      - 所属java.math包

      - 继承Number类

      - 提供的构造方法都是带参数的

        通常利用带String参数的构造方法创建这个类的对象

        ```java
            System.out.println(uuid.toString());
            BigInteger bi = new BigInteger("1231412");
        //  bi1.add();
        //  bi1.subtract();
        //  bi1.multiply();
        //  bi1.divide();
        ```

      - 四则运算

      - 计算阶乘

        ```java
            public BigInteger factorial(int num){//计算阶乘
                BigInteger result = new BigInteger("1");
                for (int i=1;i <= num;i++){
                    result = result.multiply(new BigInteger(i+""));
                }
                return result;
            }
        ```

        

   9. BigDecimal  大小数

      ```java
              BigDecimal decimal = new BigDecimal("123.2341");
              decimal =  decimal.setScale(2,BigDecimal.ROUND_DOWN);
      		//控制保留小数位数及策略，小数点后向下取整保留两位
              System.out.println(decimal);
      ```

      

   10. DecimalFormat

       ```java
               DecimalFormat df = new DecimalFormat("000.###");  
       	    //0表示必需，#表示可有可无
               String value = df.format(12.23134);
               System.out.println(value);
               //输出012.231
       ```

       

   11. Random类

       - Java.util包中，需要import导入是使用

       - 无任何继承关系 默认继承Obiect类

       - 查看构造方法----->创建对象

       - 常用方法

         ```java
         import java.util.Random;
         
         public class TestUtil {
             public static void main(String[] args) {
                 Random r = new Random();
                 int value = r.nextInt();  //随机产生int整数 有正有负
                 int result = r.nextInt(10); //[0,10) 之间的随机数
                 //tips:bound必须为整数
         
                 float f = r.nextFloat();  //[0.0---1.0)
                 //5.0---10.9之间的整数
                 float f1 = r.nextInt(6)+5+r.nextFloat();
                 Boolean b = r.nextBoolean();
             }
         }
         ```

       

5. ### **日期相关的类**

   1. 补充

      - Scanner类
        1. 所属包java.util包 需要导入
        2. 通过一个带输入流的构造方法创建对象
        3. 常用方法  nextInt(); nextFloat();  next();  nextLine();
      - System类
        1. 所属java.lang包，不需要导入
        2. 不需要创建对象，类名访问
        3. 有三个属性及若干方法
           - 属性 out    int    error
           - 方法gc();    exit(0);   currentTimeMillis();当前时间的毫秒值

   2. Date类

      1. 通常使用的是java.util包

      2. 导包使用  构建对象

      3. 通常使用无参数构造方法或long类型参数的构造方法

      4. 处理Date日期的格式

      5. Date中常用的方法

         `before();    after();`

         `setTime();   getTime();`

         `compareTo();  -1  1  0`

         ```java
         import java.util.Date;
         
         public class TestDate {
             public static void main(String[] args) {
                 //返回当前系统时间与计算机元年之间的毫秒差
                 long time =  System.currentTimeMillis();
                 System.out.println(time);
                 //1568964554959
         
                 Date date1 = new Date(1568964554959L);
                 Date date2 = new Date();
                 System.out.println(date2);  //重写了toString  格林威治时间
                 Boolean x =  date1.after(date2);  //date1是否在date2之后
                 Boolean y =  date1.before(date2);
                 date1.setTime(1568964554959L);
                 long reTime =  date1.getTime();
         
             }
         }
         
         ```

   3. DateFormat类

      1. 属于java.text包，需要导包使用
      2. 此类属于abstract类，通过字类使用
      3. SimpleDateFormat类 是DateFormat的子类
      4. 调用带String参数的构造方法创建对象

      ```java
              SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
              String v = sdf.format(date1);
              System.out.println(v);
      ```

      

   4. Calendar类

      1. 所属java.util包 需要导包

      2. 有构造方法，但是是protected修饰 通常调用默认的`getInstance()`;

      3. 常用方法

         - `after();   before();`
         - `getTime(); setTime();`

         ```java
                 Calendar calendar = Calendar.getInstance();
                 //calendar  里面包含一个date属性，可以才做date的某一个局部属性
                 calendar.set(Calendar.YEAR,2017);   //可以手动设置需要的时间构建对象
                 int year = calendar.get(Calendar.YEAR);
                 int mouth = calendar.get(Calendar.MONTH);  //从0开始数
                 int day = calendar.get(Calendar.DAY_OF_MONTH);
         ```

      4. 

   5. TimeZone

      1. java.util包
      2. 通过`calendat对象.getTimeZone()`获取 或 `TimeZone.getDefault();`创建
      3. 常用方法

      ```java
              TimeZone tz = calendar.getTimeZone();
              //TimeZone tz1 = TimeZone.getDefault();
              System.out.println(tz.getID());
              System.out.println(tz.getDisplayName());
      ```

      

6. ### **字符串相关String类**

   1. String类

      ```java
      public class TestString {
          public static void main(String[] args) {
              String s1 = "abc";
              String s2 = "abc";
              String s3 = new String("abc");
              String s4 = new String("abc");
              System.out.println(s1 == s2); //true
              System.out.println(s1 == s3); //false
              System.out.println(s3 == s4); //false
              System.out.println(s1.equals(s2)); //true    重写equals方法
              System.out.println(s1.equals(s3)); //true    将==比较改为比较自负
              System.out.println(s3.equals(s4)); //true
              //  ==比较栈内存变量空间中的内容
              //  equals（object类中的方法，默认==）
              //如果想要改变比较的的规则，可以重写equals方法
          }
      }
      ```

      

   2. 所属java.lang包  无继承关系，实现三个接口

   3. 找寻构造方法创建对象

      `String s1 = "abc"; `     直接将字符串常量赋值给str（字符串常量池）

      `String s3 = new String()；`  //无参数构造方法创建的空对象

      `String s2 = new String("abc"); ` //带String参数的构造方法创建对象

      `String s5 = new String(byte[]);`  //将数组中的每一个元素转化成对应的char组合成String

      `String s6 = new String(char[]);`  //将数组中的每一个char元素拼接成最终的String

   4. String特性

      String不可变特性

      - 在String类中包含一个数组

        private final char[]  value;  //存储String中的每一个字符

        体现在两个地方 长度和内容

        长度----->final修饰的数组  数组长度本身不变 final修饰数组的地址也不可变

        内容------>private修饰的属性  不能在类的外部访问

      

   5. String类中常用方法

      - `boolean = equals(object obj)`  //继承object类

      - `int = hashCode();`   //

      - `int = compareTo(String str);`  //实现Comparable接口，按照字典索引顺序比较

      - `String = toString();`  //重写   不再输出类命@hashCode  输出字符串中的值

        ```java
        public class TestString {
            public static void main(String[] args) {
        //        byte[] value = new byte[]{65,97,48};
        //        String str = new String(value);
        //        System.out.println(str);
        //
        //        char[] value1 = new char[]{'a','v','c'};
        //        String str1 = new String(value1);
        //        System.out.println(str1);
        //        //=============================常用方法================
        //        str1.equals(null);   //重写
        //        int = str1.hashCode();   //重写
        //        int =  str1.compareTo()
        
                String str1 = "abc";
                String str2 = "abc";
        
                System.out.println(str1.compareTo(str2));
                //先找寻字符串中长度较短的那个做为比较循环的次数
                //挨个比较元素  str1[i]-str2[i]
                //如果循环过后发现所有字符都一样 len1-len2
                //返回0表示两个字符相等
        
            }
        }
        
        ```

        

      - `char = charAt(int index)`   //返回给定index的char值

      - `int = codePointAt(int index) `//返回index位置char对应的code码

      - `length();  `//返回字符串的长度

      - `String = concat(String)`   //拼接字符串,若遇到频繁拼接字符串-->通常使用`StringBuilder`或`StringBuffer`

        ```java
        public class TestString {
            public static void main(String[] args) {
                String str = "abcd";
                for (int i = 0;i < str.length(); i ++){
                    char value = str.charAt(i);
                    int result = str.codePointAt(i);
                    System.out.println(value);
                }
        
                String str2 =  str.concat("ddd");
                str = str.concat("ddd");
                System.out.println(str2);
        
            }
        }
        ```

      - `boolean =  contains(CharSequence s) ` 判断给定的s是否在字符串中存在

      - `startsWith(String prefix)` //以...开头

        `endWith(String suffux)`  //以...结尾

      - `byte[] =  getBytes() `  //将字符串转换成数组

        `char[] =  toCharArray()` //将字符串转换成数组

      - `indexOf();`   //找寻给定的元素第一次在字符串中出现的索引的位置,若字符串不存在则返回-1

        `lastIndexOf();` //从后往前找，找寻给定的元素在字符串中最后一次出现的位置

      - `boolean =  isEmpty`   //判断字符串是否为空    Tips：注意与null的区别

      - `String = replace();` 

        `String = replaceAll();`

        `String = replaceFirst();`  //替换第一次出现的元素

      - `split(String regex [,int limit]);` //按照给定的表达式将原来的字符串拆分

      - `String = substring(int beginIndex [,int endIndex]);`  //将当前的字符串截取一部分

        从`beginIndex`开始截取到`endIndex`结束

        ```java
        public class TestString {
            public static void main(String[] args) {
                String str = "abcdefg";
                //判断此字符串中是否含有a
                boolean value = str.contains("a");
                System.out.println(value);
        
                String str1 = "abcdefgha";
                int index = str1.indexOf("a",3); //四个方法重载
                System.out.println(index);
        
                String str2 = "";
                boolean value1 =  str2.isEmpty();
                System.out.println(value1);
        
                String str3 = "a-b-c-d";
                String[] value3=  str3.split("-");
                for (String s:value3){
                    System.out.println(s);
                }
        
                String str4 = "abcdgdad";
                String temp = str4.substring(3);  //从3号索引开始截取到最后
                String temp1 = str4.substring(3,6);  //从3号索引开始截取到5号 [3,6)
                System.out.println(temp);
            }
        }
        ```

      - `toUpperCase();`

        `toLowerCase();`

      - `trim();`  //去掉字符串前后多余的空格

      - `boolean = matches(String regex)`

   6. 

7. 