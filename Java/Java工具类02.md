1. ### **StringBuffer+StringBulider**

   1. 所属java.lang包

   2. 无继承关系，实现接口Serializable, Appendable, CharSequence

      没有compareTo方法，含有一个String中没有的方法append();拼接

   3. 特性

      - 可变字符串 char[] value;动态扩容

   4. 对象的构建

      - 无参数构造方法
      - 有参数构造方法

      ```java
      public class TestUtil {
          public static void main(String[] args) {
              //默认构建一个长度为16个空间的对象
              StringBuilder stringBuilder = new StringBuilder();
              //利用给定的参数构建一个自定义长度空间的对象
              StringBuilder stringBuilder1 = new StringBuilder(20);
              //利用带String参数的构造方法 默认数组长度字符串长度+16个
              StringBuilder stringBuilder2 = new StringBuilder("abc");
          }
      }
      ```

   5. 常用的方法

      - append() 最主要的方法，频繁的拼接字符串的情况下用来提高性能

      - length();    //字符串有效元素个数

        setLength();  //修改有效元素个数

      - capacity();  //返回字符串底层char[]的容量

      - charAt();

        codePointAt();

      - String = subString(int start [,int end]);  //注意需要接受返回值，看见截取出来的字串

      - delete(int start [,int end]);  //StringBuilder类中独有的方法，不用接收返回值

      - deleteCharAt(int index);    //删除某一个字符

        setCharAt(int index,char value)  //将index位置的字符改成给定的value

      - indexOf();   //找寻元素出现的位置，从前往后找

        lastIndexOf();

      - insert(int index,value);   //将给定的value插入到index位置上

      - replace(int start,int end,String str); //将start和end之间的部分替换成str

      - reverse();  //反转字符串

      - toString();  //将StringBuilder对象转化成String对象

      - trimToSize();  //将数组中不用的容量去掉，变成length长度的数组

   6. 总结

      1. StringBuilder类不一定需要 是为了避免String频繁拼接修改字符串信息时候采用的，提高了性能

      2. 常用方法

         append()  insert()  delete()  deleteCharAt()   reverse()

      3. StringBuilder和StringBuffer的区别

         - StringBuffer是早期版本 StringBuider后来的版本1.5
         - 早期版本 线程同步  安全性较高 执行效率相对较低
         - 后期版本 线程非同步  安全性低，执行效率高

2. ### **正则表达式**

   一个带有一定规律的表达式，用来匹配字符串格式

   正则表达式通常的作用如下

   - 字符串的格式校验          String中的一个方法boolean = str.matches("regex");
   - 字符串的拆分及替换       String类中提供的方法replace split
   - 字符串的查找                  Pattern模式     Matcher匹配器

   常用匹配模式：

   - .  任意单个字符
   - \d    digit数字 [0-9]
   - \D    非数字  \[^0-9]
   - \s     space留白  一个空格  回车 换行。。。
   - \S    非留白
   - \w    word单词  [0-9A-Za-z]  数字或字母都可以
   - \W   非单词   \[^0-9A-Za-z]

   匹配字符出现的次数

   - ？0次或1次   [0-9]?    //只能出现一次0-9范围内的数子
   - \*  0-n次
   - \+ 1-n次
   - {n}  固定n次
   - {n,}  至少出现n次 
   - {m,n} m-n次之间

   ```java
   public class TestUtil {
       public static void main(String[] args) {
           Scanner input = new Scanner(System.in);
           System.out.println("请输入：");
           String str = input.nextLine();
           //判断输入的字符串是否满足给定的格式
           boolean result = str.matches("a[abc]");    //匹配范围内的单个字符
           boolean result1 = str.matches("a[^abc]");  //取反
           boolean result3 = str.matches("a[a-zA-Z]");//匹配范围内的单个字符
           boolean result4 = str.matches("a[a-z&&^[bc]]");  //a-z之间，不能是b和c
           boolean result6 = str.matches("\\d{6,}");  //至少出现6个数字
           boolean result8 = str.matches("[a-zA-Z]{6,10}");  //6-10位大小写字母
   
           String value = "a,b+c#d";
           String[] result7 = value.split(",|\\+|#"); //+号需要转义
           System.out.println(result7.length);
           
       }
   }
   ```

   

   字符串查找

   ```java
   import java.util.Scanner;
   import java.util.regex.Matcher;
   import java.util.regex.Pattern;
   
   public class TestUtil {
       public static void main(String[] args) {
           
           //所有字串中找寻满足如下规则的信息  例如邮政编码
           String str001 = "123456abc123456abc123456abc";
           //1.利用Parttern类创建一个模式   模式理解为一个正则表达式对象
           Pattern pattern = Pattern.compile("\\d{6}");  //6位邮编
           //2.需要提供一个字符串
           //3.利用pattern模式对象创建一个匹配器
           Matcher matcher = pattern.matcher(str);
           //找寻字符串中出现满足上述格式的字串
           while (matcher.find()){
               System.out.println(matcher.group()); //找到满足字符串格式的那一串文字
           }
   
       }
   }
   ```

3. ### **List集合**

   集合是指具有某种特定性质的具体或抽象的对象汇总而成的集体

   集合的两个分支

   Collection   存储的都是value

   - List   有序可重复
   - Set   无序无重复

   Map   存储的都是key-value形式存在

   1. List集合

      - ArrayList
      - LinkedList
      - Vector

   2. ArrayList

      - 所属java.util包

      - 创建对象

        无参数构造方法

        带初始容量的构造方法

        带collection参数的构造方法

      - 泛型相关

        由于ArrayList底层是一个Object []  什么类型都可以存进去，取出来之后是多态的效果，需要自己造型 用起来比较复杂

        泛型不能使用基本类型，如果要使用基本类型，需要使用其对应的包装类

        ```java
        ArrayList<Integer> list1 = new ArrayList<Integer>();
        ```

        JDK1.5之后--->泛型

        - 用来规定数据类型，定义的时候用一个符号代替某种类型，在使用的时候用具体的数据类型，将定义的那个富豪替换掉

        - 泛型可以用在哪里

          1. 泛型类

             类定义的时候描述某种数据类型  集合的使用就是这样

          2. 泛型接口

             与泛型类的使用基本一致 子类实现接口时必须添加泛型

          3. 泛型方法

             方法调用时传参数  方法的泛型与类无关  带有泛型的方法可以不放在带有泛型的类中

          4. 高级泛型  规范边界 

      - 常用方法

        add()

        remove(int index)

        removeAll()     //差集

        retainAll()        //交集

        get(int index)

        addAll()   //拼接集合    并集

        clear()   //清楚集合内的所有元素

        contains()    //找寻是否含有某元素，返回值为boolean

        indexOf()    //某元素第一次出现的位置

        isEmpty()   //判断是否为空

        iterator()   //迭代器

        set(int index)   //修改

        size()   

        subList(int begin,int end)   //截取一段子集

        toArray()   //集合变成数组

        trimToSize()    变成有效元素个数那么长

   3. Demo

   ```java
   import java.util.ArrayList;
   
   public class TestList01 {
       public static void main(String[] args) {
           ArrayList<Integer> list1 = new ArrayList<Integer>();
           //ArrayList
           ArrayList<String> list = new ArrayList<String>();   //利用泛型规定集合的元素类型
           list.add("a");
           list.add("b");
           list.add("c");
           list.add("d");
           list.add("e");
           System.out.println(list.size());
   //      System.out.println(list.get(5));  //ndexOutOfBoundsException: Index: 5,
   //        list.add(10);
   //        list.add(true);
   
           for (int i=0;i<list.size();i++){
               String value = list.get(i);
               System.out.println(value);
           }
   
           list.get(0);
           list.remove(0);
           System.out.println(list);  //重写了toString方法
   
       }
   }
   ```

4. 

   