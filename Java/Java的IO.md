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

      输入流     输出流

   3. 

2. 