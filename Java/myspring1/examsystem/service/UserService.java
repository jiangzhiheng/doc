package service;

import dao.UserDao;
import domain.User;
import sun.util.resources.ms.CalendarData_ms_MY;
import util.MySpring;

/*
* 业务层，负责处理读到的数据 或业务产生的新数据
* */
public class UserService {
    //登录方法

    //包含一个dao对象作为属性+生命周期托管方式
    private UserDao dao = MySpring.getBean("dao.UserDao");

    public String login(String account,String password){
        User user = dao.selectOne(account);
        if (user!=null){
            if (user.getPassword().equals(password)){
                return "登录成功";
            }
        }
        return "用户名或密码错误";
    }
}
