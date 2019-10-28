package producerandconsumer;

import java.util.ArrayList;

public class Warehorse {
    //创库里面的集合
    private ArrayList<String> arrayList = new ArrayList<>();

    //向集合内添加元素
    public synchronized void add(){
        if (arrayList.size()<20){
            arrayList.add("a");
        }else {
            //return; //让方法执行到这里结束
            try {
                this.notifyAll();
                this.wait();   //不是仓库wait，而是访问仓库的线程wait，生产者
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    //取元素
    public synchronized void get(){
        if (arrayList.size()>0){
            arrayList.remove(0);
        }else {
            //return;
            try {
                this.notifyAll();
                this.wait();  //不是仓库wait，而是访问仓库的线程wait，消费者
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
