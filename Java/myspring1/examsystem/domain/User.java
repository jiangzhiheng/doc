package domain;

public class User {

    /*
    * dbfile存储文件中的一行记录
    * 文件名---类名
    * 文件中一行的值--对象的属性对应
    * */
    //Domain实体对象
    private String account;
    private String password;
    public User(){}

    public User(String account, String password) {
        this.account = account;
        this.password = password;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
