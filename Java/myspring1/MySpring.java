package myspring1;

import java.io.FileWriter;
import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class MySpring {
    //设计一个方法，给一个类名字 返回一个对象，对象内属性值存在
    public Object getBean(String className){
        Object obj = null;
        try {
            //1.通过传递的className来获取对应的class
            Class clazz = Class.forName(className);
            //2.通过clazz创建一个空的对象
            Constructor con = clazz.getConstructor();  //无参数构造方法
            obj = con.newInstance();
            //3.创建对象以后，将对象内的所有属性自动赋值DI
            //值--存入文件（代码包装起来不能修改 文件还可以修改，不好处在于源代码和配置文件不在一起，读取/修改比较麻烦），
            //值--利用注解（好处在于源代码和注解在一起，不好在于代码包装起来后 注解内携带的信息不能修改）
            //4.获取属性的值-->类的无参数构造方法
            Annotation a = con.getAnnotation(MyAnnotation.class);
            //5.获取a注解对象内携带的信息--->person对象所有的属性值
            Class aclazz = a.getClass();
            Method amethod = aclazz.getMethod("value");
            String[] values = (String[]) amethod.invoke(a);
            //6.将values中的每一个值 对应的赋值给属性（找寻属性的set方法）
            Field[] fields = clazz.getDeclaredFields();
            for (int i=0;i<fields.length;i++){
                //找寻属性的名字
                String fieldName = fields[i].getName();
                String firstLetter = fieldName.substring(0,1).toUpperCase();  //属性首字母大写
                String otherLetters = fieldName.substring(1);  //除了首字母之外的其它字母
                StringBuilder setMethodName = new StringBuilder("set");
                setMethodName.append(firstLetter);
                setMethodName.append(otherLetters);
                //获取field对应的属性类型
                Class fieldType = fields[i].getType();
                //通过处理好的set方法名寻找set方法
                Method setMethod = clazz.getMethod(setMethodName.toString(),fieldType);
                //执行找到的set方法，并赋值
                //需要将注解内读到的
                 setMethod.invoke(obj,fieldType.getConstructor(String.class).newInstance(values[i]));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return obj;
    }
}
