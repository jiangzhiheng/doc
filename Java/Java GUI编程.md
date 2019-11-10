考试系统

1. 登录功能  用户名和密码存储---->文件
2. 考试功能  考试题目和答案------->文件
3. 展示功能   GUI

### **一、Swing窗口**

1. 概述

   `GUI `图形用户接口，采用图形的方式，进行操作页面的展示

   `AWT(Abstract Windows Toolkit)`

   窗体   `Frame JFrame`

   面板    `Panel  JPanel`

   组件    `JButton  JLabel  JTextField  JPasswordField JTextFiled JTextArea  JCheckBox J`     

   事件    

   - `ActionListener`  动作/响应事件
   - `KeyListener`      键盘事件
   - `MouseListener`    鼠标事件

   ```java
   package testgui;
   
   import javax.swing.*;
   
   public class TestGui {
       public static void main(String[] args) {
           /*
           * frame 最大的窗体  便捷式管理  中 东西南北 BorderLayout
           * JMenuBar 菜单条  上边
           * Panel  流式管理 居中  FlowLayout
           * */
           
           //创建一个窗体
           JFrame jFrame = new JFrame();
           //设置窗体Title
           jFrame.setTitle("TestGui01");
           //jFrame.setResizable(false);
           //设置窗体的属性状态为显示状态(默认隐藏)
           jFrame.setVisible(true);
           //设置窗体出现时的位置和自身的宽高
           jFrame.setBounds(500,250,300,250);
           //设计点击关闭按钮 窗体执行完毕
           jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
   
           //创建一个标签
           JLabel userlabel = new JLabel("UserName:");
           JLabel passlabel = new JLabel("PassWord:");
   
           //创建一个面板panel
           JPanel panel = new JPanel();
           //添加一个按钮
           JButton button = new JButton("Login");
   
           //创建一个文本框
           JTextField text = new JTextField(20);
   
           //复选框
           JCheckBox box1 = new JCheckBox("北京");
           JCheckBox box2 = new JCheckBox("上海");
           JCheckBox box3 = new JCheckBox("成都");
           //单选框
           JRadioButton r1 = new JRadioButton("男");
           JRadioButton r2 = new JRadioButton("女");
           ButtonGroup group = new ButtonGroup();
           group.add(r1);
           group.add(r2);
   
           //创建文本域
           JTextArea area = new JTextArea(5,20);
           //滚动条
           JScrollPane pane = new JScrollPane(area);
           //创建一个密码框
           JPasswordField pass = new JPasswordField(20);
   
           //菜单条  JMenuBar
           //菜单    JMenu
           //菜单项  JMenuItem
           JMenuBar bar = new JMenuBar();
           JMenu menu = new JMenu("File");
           JMenuItem newItem = new JMenuItem("New");
   
           menu.add(newItem);
           bar.add(menu);
   
   
           panel.add(userlabel);
           panel.add(text);
           panel.add(passlabel);
           panel.add(pass);
           panel.add(button);
           panel.add(r1);
           panel.add(r2);
           panel.add(pane);
   
           jFrame.setJMenuBar(bar);
           jFrame.add(panel);
   
       }
   }
   
   ```

2. 模板模式

   ```java
   package util;
   
   import javax.swing.*;
   import java.awt.*;
   
   public abstract class BaseFrame extends JFrame {
       //模板模式
       //属性
       public BaseFrame(){}
       public BaseFrame(String title){
           super(title);
       }
   
       protected void init(){
           this.setFontAndSoOn();
           this.addElement();
           this.addListener();
           this.setFrameSelf();
       }
   
       //1.设置字体 颜色 背景 布局等
       protected abstract void setFontAndSoOn();
       //2.将属性添加到窗体里
       protected abstract void addElement();
       //3.添加事件监听
       protected abstract void addListener();
       //4.设置窗体自身
       protected abstract void setFrameSelf();
   
   }
   
   ```

3. 登录功能

   MVC架构

   - V:View      视图层
   - C:Controller    控制层
   - M:Model     模型层（数据存储DAO， 数据读取，数据处理Service）

   生命周期托管实现单例

   ```java
   package util;
   
   import java.util.HashMap;
   
   public class MySpring {
       /*
       * 管理对象的产生
       * 对象的控制权交给当前类来负责
       * 使用了生命周期托管的方式实现了单例
       * */
   
       /*
       * 属性，存储所有被管理的对象
       *
       * */
       private static HashMap<String,Object> beanBox = new HashMap<>();
       //获取任何类的对象  返回值 泛型  参数(类名) String
       public static <T>T getBean(String className){  //<T>T 泛型的应用
           T obj = null;
           try {
               //
               obj = (T)beanBox.get(className);
               if (obj==null){
                   //通过类名字获取Class
                   Class clazz = Class.forName(className);
                   //通过反射产生一个对象
                   obj = (T)clazz.newInstance();
                   beanBox.put(className,obj);
               }
           } catch (Exception e) {
               e.printStackTrace();
           }
           return obj;
       }
   }
   
   ```

   

4. 