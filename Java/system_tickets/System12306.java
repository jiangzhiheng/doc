package system_tickets;

import java.util.Vector;

public class System12306 {
    /*
    * 属性 集合 ArrayList  Vector Stack
    * Vector线程安全
    * */
    private Vector<Ticket> tickets = new Vector<>();

    //单例模式
    private System12306(){}
    private static System12306 sys = new System12306();
    public static System12306 getInstance(){
        return sys;
    }

    //当前系统创建后给tickets集合赋值
    {
        for (int i=10;i<100;i++){
            tickets.add(new Ticket("beijing"+i,"shenzhen"+i,(i%5+5)*25F));
        }
    }
    //设计一个方法从几何中获取一张票
    public Ticket getTicket(){
        try {
            return tickets.remove(0);
        }catch (Exception e){
            return null;
        }

    }
}
