package system_tickets;

public class TestMain {
    public static void main(String[] args) {
        Window w1 = new Window("北京");
        Window w2 = new Window("北京西");
        Window w3 = new Window("北京南");
        w1.start();
        w2.start();
        w3.start();
    }
}
