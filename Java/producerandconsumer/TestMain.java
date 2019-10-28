package producerandconsumer;

public class TestMain {
    public static void main(String[] args) {
        Warehorse warehorse = new Warehorse();//里面有一个ArrayList

        Producer p = new Producer(warehorse);
        //设置线程的优先级别1-10
        p.setPriority(10);
        Consumer c1 = new Consumer(warehorse);
        Consumer c2 = new Consumer(warehorse);
        p.start();
        c1.start();
        c2.start();
    }
}
