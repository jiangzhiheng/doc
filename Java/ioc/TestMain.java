package ioc;


public class TestMain {
    public static void main(String[] args) {
        //创建一个Quetion对象 对象控制权交由别人处理 IOC
        MySpring mySpring = new MySpring();
        Question question = (Question)mySpring.getBean("ioc.Question");
        System.out.println(question);
    }
}
