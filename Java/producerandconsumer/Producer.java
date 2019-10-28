package producerandconsumer;

public class Producer extends Thread{

    //为了保证生产者和消费者使用同一个仓库对象，添加一个属性
    private Warehorse warehorse;
    public Producer(Warehorse warehorse){
        this.warehorse = warehorse;
    }

    //生产者中的run方法
    public  void run(){
        while (true){
            warehorse.add();
            System.out.println("生产者存入一个元素");
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
