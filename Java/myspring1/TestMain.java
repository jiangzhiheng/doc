package myspring1;

public class TestMain {
    public static void main(String[] args) {
        //获取一个Person对象
        //对象的创建权力反转（IOC）赋值（DI）给别人处理
        MySpring mySpring = new MySpring();
        Person p = (Person) mySpring.getBean("myspring1.Person");
        System.out.println(p.getName()+"--"+p.getAge()+"--"+p.getSex());

    }
}
