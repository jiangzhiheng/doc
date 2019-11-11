package dao;

import domain.User;
import util.UserFileReader;

public class UserDao {

    /*
    * 缓存--内存中---存储文件中的所有信息
    * */


    /*
    * 持久层  数据的持久化
    * 只复制数据的读写 不负责处理逻辑
    * 以后这个层次看到的内部代码都是JDBC
    * */

    /*
    * 负责查询一个人的信息
    * 参数 账号  返回值，User对象
    * */
    public User selectOne(String account){
        return UserFileReader.getUser(account);
    }

}
