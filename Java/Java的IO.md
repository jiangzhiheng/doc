1. ### **IO之File类**

   I/O相关  输入/输出  流（数据流动）

   数据流动的方向  读数据（输入Input） 写数据（输出Output）

   文件流  字符流   数据流  对象流  网络流.....

   1. 什么叫文件

      一种电脑的存储形式

      文件有不同的格式  .txt   .doc .ppt   .mp4

      文件夹？----目录路径

      File---->与电脑上的文件或文件夹产生一一对应的映射关系

      - File是一个类，属于java.io包，文件或路径名的抽象表示形式，与真实硬盘中的文件不是同一个东西，是在内存中的一个对象

      - File类中常用的方法

        canRead()   canWrite()  isHidden()  isFile()   isDirectory()  length()  lastModified()  

        setLastModified(time);  getAbsolutePath(); 

        ```java
        import java.io.File;
        public class TestFile {
            public static void main(String[] args) {
                File file = new File("F:\\Test\\Test.txt");
                //file对象不是真正的文件，是堆内存中创建出来的一个对象空间
                //路径是看创建的对象能否与硬盘中的真实文件产生映射
                //系统内硬盘上的文件名不区分大小写
                //文件本身的属性
                System.out.println(file.canExecute());
                System.out.println(file.canRead());
                System.out.println(file.canWrite());
                System.out.println(file.isHidden());  //是否隐藏
                System.out.println(file.isFile());//判断当前file是否为一个文件
                long l = file.length();  //获取文件长度
                long mt = file.lastModified();  //获取最后修改时间
                file.setLastModified(mt);  //设置最后修改时间，参数为毫秒值
                String path = file.getAbsolutePath(); //获取绝对路径
                String name = file.getName(); //获取文件名
                file.createNewFile(); //创建新文件
                file.mkdir();  //创建目录
            }
        }
        ```

        createNewFile();

        mkdir();   //无法递归创建

        mkdirs();  //可以递归创建

        ```java
        import java.io.File;
        import java.io.IOException;
        
        public class TestFile {
            public static void main(String[] args) {
                File file = new File("F:\\Test\\abc.txt");
                try {
                    boolean value =  file.createNewFile(); //创建文件
                } catch (IOException e) {
                    e.printStackTrace();
                }
        
                File file1 = new File("F:\\Test\\aaa/bbb");
                boolean value1 = file1.mkdir(); //父目录需要真实存在，不能递归创建
                file1.mkdirs(); //该方法可以递归创建
            }
        }
        ```

        String name = getParent();  //获取当前file的父亲名字

        File parentFile = file.getParentFile();  //获取当前file的父亲对象

        String[] names = list()  获取当前file的所有儿子名字

        File[] files = listFiles();  获取当前file的所有儿子对象

        delete();  删除文件或空文件夹

        ```java
        import java.io.File;
        
        public class TestFile {
            public static void main(String[] args) {
                File file = new File("F:\\Test\\abc.txt");
                boolean value2 = file.delete(); //删除元素（文件或空文件夹）
                File[] files = file.listFiles();
                //数组对象为空  证明当前file是一个文件
                //数组对象不为空  证明当前file是一个文件夹
                //数组对象的长度部位0，证明当前file是一个不为空的文件夹，里面有文件
        
                //遍历当前file的所有父目录
                File pfile = file.getParentFile();
                while (pfile!=null){
                    System.out.println(pfile.getAbsolutePath());
                    pfile = file.getParentFile();  //再找一遍
                }
                //遍历子元素  递归
            }
        }
        ```

   2. 什么叫文件流  做什么

      按照方向（功能）来区分 :输入流     输出流

      操作的目标来区分

      - 文件流  数组流 字符串流  数据流  对象流 网络liu .......

      文件流

      - 读取文件中的信息，将信息写入文件中

      文件流按照读取或写入的单位大小来区分

      - 字节型文件流

        FileInputStream/FileOutputStream

      - 字符型文件流

        FileReader/FileWirter

   3. IO之文件夹遍历删除（递归）

      1. 文件夹的遍历
      2. 文件夹的删除

      ```java
      package testfile;
      
      import com.sun.xml.internal.fastinfoset.tools.FI_DOM_Or_XML_DOM_SAX_SAXEvent;
      
      import java.io.File;
      
      public class TestMethord {
          //遍历或者展示文件夹
          public void showFile(File file){
              //判断如果file是一个文件夹 并且文件夹内有元素
              File[] files = file.listFiles();  //files=bull说明是个文件
              //files!=null说明是个文件夹，files.length!=0说明文件夹有元素
              if (files!=null && files.length!=0){
                  for (File f:files){ //遍历每一个子元素
                      this.showFile(f);
                  }
              }
              //做自己的显示
              System.out.println(file.getAbsolutePath());
          }
      
          //删除文件夹
          public void deleteFile(File file){
              //判断是不是空文件夹
              File[] files = file.listFiles();
              if (files!= null && files.length!=0){
                  for (File f:files){
                      this.deleteFile(f);
                  }
              }
              //删除文件或者空文件夹
              file.delete();
          }
      
          public static void main(String[] args) {
              TestMethord tm = new TestMethord();
              File file = new File("F:\\Test");
              tm.showFile(file);
          }
      }
      
      ```

2. ### **字节型文件流**

   FileInputStream/FileOutputStream

   FileInputStream

   1. java.io类

   2. 继承InputStream类，字节型输入流的父类

   3. 创建对象

      调用一个带File类型的构造方法

      调用一个带String类型的构造方法

   4. 常用方法

      - int code = read();  每次从流管道中读取一个字节 字节的code码
      - int count = read(byte[] ); 每次从流管道中读取若干个字节存入数组中 返回有效元素
      - int count = available(); 返回流管道中还有多少缓存的字节数
      - long count  = skip(long n);  跳过n个字节开始读取
      - close();  表示将流通到关闭，最好放在finally里，注意代码的严谨性判断

      ```java
      package teststream;
      
      import java.io.File;
      import java.io.FileInputStream;
      import java.io.FileNotFoundException;
      import java.io.IOException;
      
      public class TestFileInputStream {
          public static void main(String[] args) {
              try {
                  FileInputStream fis = new FileInputStream("F:\\Test\\Test.txt");
                  //创建一个空数组，从文件读东西，存入数组
                  byte[] b = new byte[5];
                  int count= fis.read(b);
                  while (count!=-1){
                    String value = new  String(b,0,count);//指定构建的起始位置，数量
                    System.out.print(value);
                    count = fis.read(b);
                  }
      
              } catch (IOException e) {
                  e.printStackTrace();
              }
      
      
              //创建一个FileInputStream对象 字节型
              FileInputStream fileInputStream = null;
              try {
                  File file = new File("F:\\Test\\Test.txt");
                  fileInputStream = new FileInputStream(file);
                  int value1 = fileInputStream.available(); //流管道中有多少缓存的字节
                  int code = fileInputStream.read();  //读取的字节对用的unicode码
                  while (code!=-1){
                      //System.out.print((char)code);
                      code = fileInputStream.read();
                  }
              } catch (FileNotFoundException e) { //编译时异常
                  e.printStackTrace();
              } catch (IOException e) {
                  e.printStackTrace();
              }finally {
                  try {
                      if (fileInputStream!=null){  //判断非空才能close，否则会空指针
                          fileInputStream.close(); //关闭流通道,必须进行的操作
                      }
                  } catch (IOException e) {
                      e.printStackTrace();
                  }
              }
          }
      }
      
      ```

      

   FileOutputStream

   

3. ### **字符型文件流**

4. ### **缓冲流+对象流**