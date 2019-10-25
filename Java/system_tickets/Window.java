package system_tickets;

public class Window extends Thread {
    private String windosName;//窗口名称

    public Window(String windosName){
        this.windosName = windosName;
    }

    public void run(){
        this.seleTicket();
    }

    public void seleTicket(){
        while (true){
            System12306 sys = System12306.getInstance();
            Ticket ticket = sys.getTicket();//Vector
            if (ticket==null){
                System.out.println(windosName+"已售完");
                break;
            }
            System.out.println(windosName+"售出一张票："+ticket);
        }
    }
}

