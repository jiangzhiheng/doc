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

   

3. 