package ioc;

import java.io.File;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Scanner;

public class MySpring {
    //设计一个方法 帮我控制对象的创建
    //参数 String   返回值Object对象
    public Object getBean(String className){
        Object obj = null;
        Scanner input = new Scanner(System.in);
        System.out.println("请给"+className+"类的对象赋值");
        try {
            //获取方法传递进来的参数对应的类
            Class clazz = Class.forName(className);
            //通过clazz创建一个对象
            obj = clazz.newInstance();
            //在这里做一个自动注入DI  对象中的所有属性值 set方法
            //找到每一个不同对象中的所有set方法  给属性赋值
            //自己通过拼接字符串处理名字
            //1.找寻类中的所有私有属性，获取每一个属性的名字  set属性
            Field[] fields = clazz.getDeclaredFields();
            for (Field field:fields){
                //获取属性名
                String fieldName = field.getName();
                //手动拼接属性对应的方法名
                String firstLetter = fieldName.substring(0,1).toUpperCase();  //属性首字母大写
                String otherLetters = fieldName.substring(1);  //除了首字母之外的其它字母
                StringBuilder setMethodName = new StringBuilder("set");
                setMethodName.append(firstLetter);
                setMethodName.append(otherLetters);
                //获取field对应的属性类型
                Class fieldClass = field.getType();
                //通过处理好的set方法名寻找set方法
                Method setMethod = clazz.getMethod(setMethodName.toString(),fieldClass);
                //找到的setMethod一执行，属性就赋值成功
                System.out.println("请给"+fieldName+"属性赋值");
                String value = input.nextLine();
                /*
                * 需要执行属性对应的set方法 给属性赋值 方法就结束
                * 属性现在接收过来的值都是String类型
                * 执行set方法时 方法需要的值不一定都是String类型
                * 如何将所有的String类型的值转化成属性类型对用的值
                * 八个包装类有七个都含有带String类型的构造方法
                * */
                Constructor constructor = fieldClass.getConstructor(String.class);
                setMethod.invoke(obj,constructor.newInstance(value));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return obj;
    }
}
