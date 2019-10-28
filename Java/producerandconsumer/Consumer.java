package producerandconsumer;

public class Consumer extends Thread {

    private Warehorse warehorse;
    public Consumer(Warehorse warehorse){
        this.warehorse = warehorse;
    }
    //消费者的方法，一直拿元素
    public void run(){
        while (true){
            warehorse.get();
            System.out.println("消费者获取了一个元素");
            try {
                Thread.sleep(300);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
