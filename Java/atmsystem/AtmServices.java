package atmsystem;

import java.io.*;
import java.util.HashMap;
import java.util.Iterator;

/*
1.底层数据存储 文件.txt 每一行记录一个人的所有信息
    文件存储在一个固定的位置，当前工程的内部
* */
public class AtmServices {
    private AtmDao dao = new AtmDao();
    //只有业务逻辑，看不到数据操作

    //模拟网上银行
    //设计一个登录方法
    public String login(String aname,String apassword){
        User user = dao.selectOne(aname);
        if (user!=null && user.getApassword().equals(apassword)){
            return "Login Success!";
        }
        return "用户名或密码错误";
    }

    //设计查询余额方法
    public Float queryBalance(String aname){
        User user = dao.selectOne(aname);
        return user.getAbalance();
    }

    //设计存款方法   存款 修改某一行
    public void deposit(String aname,Float depositMoney){
        //先将map中的数据修改
        User user = dao.selectOne(aname);
        user.setAbalance(user.getAbalance()+depositMoney);
        dao.update(user);
        //将集合中的数据写入文件中，替换全部内容
        dao.commit(); //永久写入文件
    }

    //取款
    public void withdrawal(String aname,Float withdrawalMoney){
        //先将map中的数据修改
        User user = dao.selectOne(aname);
        if (user.getAbalance()>withdrawalMoney){
            user.setAbalance(user.getAbalance()-withdrawalMoney);
            dao.update(user);
            //将集合中的数据写入文件中，替换全部内容
            dao.commit(); //永久写入文件
        }else {
            System.out.println("账户余额不足");
        }
    }

    //转账
    public void transfer(String outName,String inName,Float transferMoney){
        User outUser = dao.selectOne(outName);
        if (outUser.getAbalance()>transferMoney) {
            User inUser = dao.selectOne(inName);
            if (inUser!=null){
                outUser.setAbalance(outUser.getAbalance()-transferMoney);
                inUser.setAbalance(inUser.getAbalance()+transferMoney);
                dao.update(inUser);
                dao.update(outUser);
                dao.commit();
            }else {
                System.out.println("转入账户不存在");
            }
        }else {
            System.out.println("余额不足");
        }

    }

}
