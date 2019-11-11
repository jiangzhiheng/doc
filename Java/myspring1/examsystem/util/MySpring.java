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
