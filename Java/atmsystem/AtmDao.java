package atmsystem;

import java.io.*;
import java.util.HashMap;
import java.util.Iterator;

public class AtmDao {
    //DAO（Data Access Object）作为一个层次---持久层 操作数据

    //1.每次登录都需要创建文件流管道，创建一个map集合作为缓存
    //一行记录创建一个对象存起来
    //2.还能用来做为记录的修改
    private HashMap<String,User> userBox = new HashMap<>();
    {
        //在对象创建之前，给集合进行赋值操作
        //创建一个输入流 读取文件
        FileReader fileReader = null;
        BufferedReader bufferedReader =null;
        try {
            fileReader = new FileReader("src\\atmsystem\\user.txt");
            bufferedReader = new BufferedReader(fileReader);
            String value = bufferedReader.readLine();
            while (value!=null){
                //value信息拆分为三段 构建一个user对象 三个属性刚好存储 对象存入集合
                String[] userValue = value.split("-");
                User user = new User(userValue[0],userValue[1],Float.parseFloat(userValue[2]));
                userBox.put(userValue[0],user);
            }
        } catch (java.io.IOException e) {
            e.printStackTrace();
        }finally {
            try {
                if (fileReader!=null){
                    fileReader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (bufferedReader!=null){
                    bufferedReader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


    }

    //设计一个方法，为所有业务服务
    //有参数，账号名 返回值 一个对象
    public User selectOne(String aname){
        return userBox.get(aname);
    }
    //将修改完毕的对象存入集合
    public void update(User user){
        userBox.put(user.getAname(),user);
    }
    //将集合内的所有数据写入文件
    public void commit(){  //事物处理
        FileWriter fileWriter = null;
        BufferedWriter bufferedWriter = null;
        try {
            fileWriter = new FileWriter("src\\atmsystem\\user.txt");
            bufferedWriter = new BufferedWriter(fileWriter);
            Iterator<String> names = userBox.keySet().iterator();
            while (names.hasNext()){
                String name = names.next(); //集合内获取某一个人
                User user = userBox.get(name);
                //拼接字符串
                StringBuilder stringBuilder = new StringBuilder(user.getAname());
                stringBuilder.append("-");
                stringBuilder.append(user.getApassword());
                stringBuilder.append("-");
                stringBuilder.append(user.getAbalance());
                //字符型文件输出流写入文件
                bufferedWriter.write(stringBuilder.toString());
                bufferedWriter.newLine();
                bufferedWriter.flush();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            try {
                if (fileWriter!=null) {
                    fileWriter.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if (bufferedWriter!=null){
                    bufferedWriter.close();
                }
            }catch (IOException e){
                e.printStackTrace();
            }
        }
    }
}
