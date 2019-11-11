package util;

import domain.User;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

public class UserFileReader {
    /*
    * 增加一个缓存机制
    * 程序启动的时候将User.txt中的所有信息一次性读出来
    * 提高读取性能
    * */
    //创建一个集合HashMap
    private static HashMap<String, User> userBox = new HashMap<>();
    static  {
        //当前类加载的时候先执行
        BufferedReader reader =null;
        try {
            reader = new BufferedReader(new FileReader("src//dbfile//User.txt"));
            String message = reader.readLine();
            while (message!=null){
                String[] values = message.split("-");
                userBox.put(values[0],new User(values[0],values[1]));
                message = reader.readLine();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            if (reader!=null){
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    public static User getUser(String account){
        return userBox.get(account);
    }
}
