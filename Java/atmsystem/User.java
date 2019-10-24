package atmsystem;

import java.io.Serializable;

public class User implements Serializable {
    //只是为了记录数据库中的三个对象 账户 密码 余额
    //建议类实现一个序列号接口，添加序列化版本号
    private static final long serialVersionUID = -1145728943854353036L;
    private String aname;
    private String apassword;
    private Float abalance;
    public User(){};
    public User(String aname,String apassword,Float abalance){
        this.aname = aname;
        this.apassword = apassword;
        this.abalance = abalance;
    }

    public String getAname(){
        return this.aname;
    }
    public String getApassword(){
        return this.apassword;
    }
    public Float getAbalance(){
        return this.abalance;
    }
    public void setAname(String aname){
        this.aname = aname;
    }
    public void setApassword(String apassword){
        this.apassword = apassword;
    }
    public void setAbalance(Float abalance){
        this.abalance = abalance;
    }
}
