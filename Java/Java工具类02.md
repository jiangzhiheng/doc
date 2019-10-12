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

4. ### **LinkedList+Vector+Stack+Queue**

   1. LinkedList
   
      1. java.util包
   
      2. 底层使用双向链表的数据结构形式来存储
   
         适用于频繁插入删除，不适合遍历轮询
   
      3. 构建对象   
   
         - 无参数构造方法
         - 有参数构造方法
   
      4. 常用方法
   
         增删改查  CURD
   
         手册中提供的其它常用方法
   
         - addAll()
         - addFirst()
         - clear()
         - contains()
         - .........
   
   2. Vector（ArrayList的早期版本）
   
      1. java.util包
   
      2. 是ArrayList集合的早期版本
   
         - Vector底层也是利用动态数组的形式存储
         - Vector是线程同步的，安全性高，效率低
   
      3. 扩容方式与ArrayList不同
   
         默认是扩容两倍  可以通过构造方法创建对象时修改这一机制
   
      4. 构造方法
   
      5. 常用方法
   
      ```java
      import java.util.Vector;
      
      public class TestList01 {
          public static void main(String[] args) {
              Vector<String> vector = new Vector();
              //Vector<String> vector1 = new Vector(4,6);  //初始值4个元素，每次增加4个
              vector.add("a");
              vector.add("b");
              System.out.println(vector);
              vector.get(1);
              System.out.println(vector.size());
          }
      }
      ```
   
   3. Stack类  栈    FILO先进后出
   
      - java.util包   继承Vector
   
      - 构造方法只有一个无参数方法
   
      - 除了继承自Vector的方法之外只有几个特殊方法
   
        push()   将元素压入栈顶  压栈
   
        pop()   弹栈    ，将元素取出并删除
   
        peek()   查看栈顶的一个元素 不删除
   
        empty()   判断栈内元素是否为空
   
        search()   查看给定元素在栈中的位置
   
      -   应用场景
   
        撤销到上一步
   
      ```java
      import java.util.Stack;
      
      public class TestList01 {
          public static void main(String[] args) {
              Stack<String> stack = new Stack();
              stack.push("a");
              stack.push("b");
              System.out.println(stack);
              System.out.println(stack.size());
              System.out.println(stack.search("a"));
          }
      }
      ```
   
   4. Queue  队列   FIFO 先进先出   接口
   
      - java.util包   常用子类 LinkedList ArrayList
   
      - 通常无参数构造方法创建
   
      - 常用方法
   
        1. 一般方法
   
           add()
   
           element()   ----->get()
   
           remove()
   
        2. 特有方法
   
           boolean = offer(E e);//相当于add     不会抛出异常
   
           E = peek();  //相当于element方法
   
           E = poll();    //相当于remove
   
      ```java
      //Demo   ArrayList和LinkedList性能比较
      import java.util.ArrayList;
      import java.util.LinkedList;
      
      public class TestList01 {
          public static void main(String[] args) {
              //ArrayList
              ArrayList<String> arrayList = new ArrayList<>();
              long time1 = System.currentTimeMillis();
              for (int i = 00;i<=200000;i++){
                  arrayList.add(0,"a");
              }
              long time2 = System.currentTimeMillis();
              System.out.println("ArrayList运行时间："+(time2-time1));
      
              //--------------------------------------------------
              //LinkedList
              LinkedList<String> linkedList = new LinkedList<>();
              long time3 = System.currentTimeMillis();
              for (int i = 0;i<=200000;i++){
                  linkedList.add(0,"a");
              }
              long time4 = System.currentTimeMillis();
              System.out.println("LinkedList运行时间："+(time4-time3));
          }
      }
      //ArrayList运行时间：插入用时1332毫秒
      //LinkedList运行时间：插入用时11毫秒
      ```
   
      
   
5. ### **HashSet+TreeSet**

   Set的具体实现类
   
   无序无重复
   
   - HashSet
   - TreeSet
   
   1. HashSet     （HashMap）
   
      1. Java.util包
   
      2. 如何创建对象
   
         - 无参数构造方法
         - 有参数构造方法
   
      3. 集合容器的基本使用
   
         - boolean = add()
   
           addAll(collection)
   
           retainAll()
   
           removeAll()
   
         - boolean = remove(object o)
   
         - 无set方法
   
         - 可以使用增强fao进行集合遍历
   
         - iterator()   获取一个迭代器对象
   
      4. 无重复的原则
   
         - 通过equals方法进行比较
         - 同时重写equals方法和hashCode方法
         - set集合是发现重复的元素拒绝存入
   
      5. Demo
   
      ```java
      import java.util.HashSet;
      import java.util.Iterator;
      
      public class TestSet {
          public static void main(String[] args) {
              HashSet<String> hashSet = new HashSet<>();
              hashSet.add("a");
              hashSet.add("b");
              hashSet.add("c");
              hashSet.add("B");
              hashSet.add("A");
              System.out.println(hashSet);
              //先获取一个迭代器对象
              Iterator<String> it = hashSet.iterator();  //Iterator接口 多态效果
              //判断下一个位置是否有元素
              while (it.hasNext()){
                  String value = it.next();
                  System.out.println(value);
              }
          }
      }
      ```
   
      
   
   2. TreeSet      （TreeMap   二叉树  ）
   
      - 无序无重复 java.util
   
      - 无参数构造方法 带collection对象的构造方法
   
      - 基本常用方法
   
        add(E e)   iterator()   remove() size()
   
      - TreeSet的无重复实现原理
   
        treeSet本身有顺序，我们只得无序存入和取出来的不一致
   
        conpareTo--->String类 按照字母的自然顺序排布
   
        如果想要把自己写的类型 存入TreeSet即合里面，不能随意得存储，需要让自己写的类先实现Comparable接口    compareTo方法
   
6. ### **Map**

   Map  通过某一个key可以直接定位带一个value值

   存储的方式以 key-value形式存储

   key无序无重复  value无序可重复

   1. map基本使用

      Hashmap

      TreeMap

      Properties

   2. HashMap

      1. java.util包

      2. 如何创建对象

      3. 基本方法

         put(k,v)    存放一组映射关系

         - key存储的顺序与取得顺序不同
         - 不同的key可以存储相同的value
         - key若相同，则将原有的value覆盖而不是拒绝存入（跟set相反）

         remove(key);

         replace(k,v);

         get(key);

         遍历hashmap

      4. 其它方法

         - clear()

         - containsKey(key)

         - containsValue(value)
         - getOrDefault(key，defaultvalue);    如果key存在则返回，否则返回default
         - putAll()
         - putIfAbsent(k,v)   如果key不存在才添加，否则不添加覆盖

         ```java
         import java.util.HashMap;
         import java.util.Iterator;
         import java.util.Set;
         
         public class HashMapTest {
             public static void main(String[] args) {
                 //创建一个HashMap对象
                 HashMap<Integer,String> hashMap = new HashMap<>();
                 //存入一些关系
                 hashMap.put(1,"martin");
                 hashMap.put(2,"tom");
                 hashMap.put(3,"Jerry");
                 hashMap.put(4,"tony");
                 System.out.println(hashMap);
                 hashMap.remove(3);
                 hashMap.replace(3,"timi");
                 hashMap.putIfAbsent(9,"hahah");
                 //遍历 先获取全部key
                 Set<Integer> keys = hashMap.keySet();
                 //通过迭代器遍历keys
                 Iterator<Integer> it = keys.iterator();
                 while (it.hasNext()){
                     Integer key = it.next();
                     String value = hashMap.get(key);
                     System.out.println(key+"---"+value);
                 }
         
             }
         }
         
         ```

         

      5. HashMap底层数据存储结构

         散列表的形式   数组+链表

         不同的对象可能产生相同的hashCode码

         不同的hashCode码应该对应不同的对象

      6. map集合使用情形

         1. 想要存储一组元素    数组 or 集合  如果存储的元素以后长度不变用数组  长度不确定，用集合

         2. 如果长度不确定----->集合

            List家族有序的 存储的有顺序用这个

            - ArrayList（Vector）更适合遍历轮询
            - LinkedList  更适合插入删除
            - Stack    LIFO

            Set家族无重复  存储元素希望自动去重的用这个

            - Hash  性能更高
            - Tree  希望存进去的元素自动去重，还能自动排序

         3. Map家族k-v  通过唯一的k快速寻找v用map

            - Hash  性能更高
            - Tree  希望存进去的元素key自动排序

      7. 登陆小流程------对比数组，集合以及map的存储取值特点

      ```java
      import java.util.ArrayList;
      import java.util.HashMap;
      import java.util.HashSet;
      import java.util.Iterator;
      
      public class LoginService {
      
          private String[] username = new String[]{"tom","marry","Martin"};
          private int[] passwd = new int[]{111,222,333};
          //设计方法用来登陆认证
          public String LoginForArray(String name,String password){
              for (int i=0;i<username.length;i++){
                  if (username[i].equals(name)){
                      if (passwd[i]== Integer.parseInt(password)){
                          return "Login succ";
                      }
                      break;
                  }
              }
              return "username or passwd error";
          }
      //---------------------------------------------------------------------
          //设计方法用ArrayList实现用户登录
          private ArrayList<String> userBox = new ArrayList<>();
          {
              userBox.add("martin-111");
              userBox.add("jerry-222");
              userBox.add("tony-333");
          }
          public String loginForList(String name,String password){
              for (int i = 0;i < userBox.size();i ++){
                  String[] value = userBox.get(i).split("-");
                  if (value[0].equals(name)){
                      if (value[1].equals(password)){
                          return "Login succ";
                      }
                      break;
                  }
              }
              return "username or passwd error";
          }
      
          //设计一个方法用Set实现登陆
          private HashSet<String> userBoxx = new HashSet<>();
          {
              userBoxx.add("martin-111");
              userBoxx.add("jerry-222");
              userBoxx.add("tony-333");
          }
          public String logForSet(String name,String password){
              Iterator<String> it = userBoxx.iterator();
              while (it.hasNext()){
                  String[] value = it.next().split("-");
                  if (value[0].equals(name)){
                      if (value[1].equals(password)){
                          return "Login succ";
                      }
                      break;
                  }
              }
              return "username or password error";
          }
      
          //设计方法用map实现登陆认证
          private HashMap<String,Integer> userBoxxx = new HashMap<>();
          {
              userBoxxx.put("martin",111);
              userBoxxx.put("jerry",222);
              userBoxxx.put("tony",333);
          }
          public String loginForMap(String name,String password){
              Integer readPassword = userBoxxx.get(name);
              if (readPassword!=null && readPassword ==Integer.parseInt(password)){
                  return "Login succ";
              }
              return "username or password error";
          }
      }
      ```

   3. TreeMap        自然有序 按照unicode编码自然有序

      1. java.util包

      2. 构造方法

         无参数构造方法

         带map参数的构造方法

      3. 常用方法

         put    get    remove    replace   size

      4. 底层数据结构的存储

         二叉树     红黑二叉树

   4. 考试系统练习

      - 考试题目如何存储

        自己描述一个类---->一个题目类型

        有两个属性----题干   真实答案

        public class Question(){}

      - 几个实体类（3个）类的关系

        考试机

        - 属性----题库 存储好多Question类型的对象   Set 无重复
        - 方法----随机抽题目，形成试卷

        学生

        - 方法---考试

        老师

        - 方法---批卷子（学生最终选项 真实的试卷）

      - 具体添加每一个类中的成员描述

        如何选择存储容器

      ```java
      package examsystem;
      
      import java.util.ArrayList;
      import java.util.Scanner;
      
      public class TestMain {
          public static void main(String[] args) {
              ExamMach examMach = new ExamMach();//创建考试机
      
              //创建学生对象
              Scanner input = new Scanner(System.in);
              System.out.println("请输入用户名");
              String username = input.nextLine();
              System.out.println("请输入密码");
              String password = input.nextLine();
              Student student = new Student(username,password);
              String result = examMach.login(student.getUsername(),student.getPassword());
              if (result.equals("Login succ")){
                  System.out.println("登陆成功，开始考试");
                  ArrayList<Question> paper = examMach.getPaper(); //获取试卷
                  String[] answers = student.exam(paper);  //考试
                  Teacher teacher = new Teacher();
                  int score = teacher.checkPaper(paper,answers);
                  System.out.println(student.getUsername()+"最终的成绩是"+score);
              }
      
      
          }
      }
      
      ```

      ```java
      package examsystem;
      
      import java.util.ArrayList;
      import java.util.HashSet;
      import java.util.Random;
      import java.util.HashMap;
      
      public class ExamMach {
          //属性  题库 Question对象
          //Set集合，自动
          private HashSet<Question> questionBank = new HashSet<>();
          {
              //利用块初始化hashSet集合内的题目对象
              questionBank.add(new Question("如下A哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","A"));
              questionBank.add(new Question("如下C哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","C"));
              questionBank.add(new Question("如下D哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","D"));
              questionBank.add(new Question("如下B哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","B"));
              questionBank.add(new Question("如下C哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","C"));
              questionBank.add(new Question("如下D哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","D"));
              questionBank.add(new Question("如下A哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","A"));
              questionBank.add(new Question("如下B哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","B"));
              questionBank.add(new Question("如下B哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","B"));
              questionBank.add(new Question("如下A哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","A"));
          }
      
          private HashMap<String,String> userBox = new HashMap<>();
          {
              userBox.put("martin","111");
              userBox.put("jerry","222");
              userBox.put("tony","333");
          }
      
          //登陆认证
          public String login(String name,String password){
              String readPassword = this.userBox.get(name);
              if (readPassword!=null && readPassword.equals(password)){
                  return "Login succ";
              }
              return "username or password error";
          }
      
      
          //设计方法 随机产生试卷
          //参数  确定试卷5道题  不用  返回值 试卷ArrayList<Question>
          public ArrayList<Question> getPaper(){
              //随机抽取试卷的时候 试卷题目应该不充分 Set存 --->ArrayList
              HashSet<Question> paper = new HashSet<>(); //试卷
              //产生一个随机序号 去寻找题目 题库是Set无序号
              ArrayList<Question> questionBank = new ArrayList<>(this.questionBank);
              //随机抽取题目
              while (paper.size()!=5){
                  int index = new Random().nextInt(this.questionBank.size());
                  paper.add(questionBank.get(index));
              }
              return new ArrayList<Question>(paper);
          }
      }
      
      ```

      ```java
      package examsystem;
      
      public class Question {
          private String title;
          private String answer; //真实答案
      
          public Question(String title,String answer){
              this.title = title;
              this.answer = answer;
          }
      
          //重写方法，将默认比较题目对象的地址规则改编成比较题干
          public boolean equals(Object obj) {
              if (this==obj){
                  return true;
              }
              if (obj instanceof Question){
                  Question anotherQuestion = (Question)obj;
                  if (this.title.equals(anotherQuestion)){
                      return true;
                  }
              }
              return false;
          }
          public int hashCode(){
              return this.title.hashCode();
          }
      
          public String getTitle(){
              return this.title;
          }
          public String getAnswer(){
              return this.answer;
          }
      
      }
      
      
      ```

      ```java
      package examsystem;
      
      import java.security.PublicKey;
      import java.util.ArrayList;
      import java.util.Scanner;
      
      public class Student {
          //属性
          private String username;
          private String password;
          public Student(String username,String password){
              this.username = username;
              this.password = password;
          }
          public String getUsername(){
              return this.username;
          }
          public String getPassword(){
              return this.password;
          }
      
          //考试方法
          //参数是一套试卷  返回值 学生的所有选项String[]
          public String[] exam(ArrayList<Question> paper){
              String[] answers = new String[paper.size()];
              for (int i=0;i<paper.size();i++){
                  Scanner input  = new Scanner(System.in);
                  Question question = paper.get(i);
                  System.out.println((i+1)+"."+question.getTitle());
                  System.out.println("请输入您认为正确的选项？");
                  answers[i] = input.nextLine();
              }
              return answers;
          }
      
      }
      
      ```

      ```java
      package examsystem;
      
      import javax.swing.table.TableRowSorter;
      import java.util.ArrayList;
      
      public class Teacher {
          //批卷子
          //参数 学生作答的选项 真实的试卷
          //返回值 int
          public int checkPaper(ArrayList<Question> paper,String[] answers){
              System.out.println("老师正在批阅，请等待");
              try {
                  Thread.sleep(5000);
              }catch (Exception e){
                  e.printStackTrace();
              }
              int score = 0;
              for (int i =0;i<paper.size();i++){
                  Question question = paper.get(i);
                  if (question.getAnswer().equalsIgnoreCase(answers[i])){
                      score+=(100/paper.size());
                  }
              }
              return score;
          }
      }
      
      ```

      


