package system_tickets;

import java.nio.channels.FileLock;

public class Ticket {
    /*
    * 起始站
    * 终点站
    * 票价
    * 只包含一些基本属性 每个对象一个小容器
    * 一个对象包含很对属性，增强可读性  POJO  JavaBean
    * */
    private String start;
    private String end;
    private Float price;

    public Ticket(){}
    public Ticket(String start,String end,Float price){
        this.start = start;
        this.end = end;
        this.price = price;
    }

    public String toString(){
        StringBuilder stringBuilder = new StringBuilder("[");
        stringBuilder.append(this.start);
        stringBuilder.append("-->");
        stringBuilder.append(this.end);
        stringBuilder.append(":");
        stringBuilder.append(this.price);
        stringBuilder.append("]");
        return stringBuilder.toString();
    }

    public String getStart() {
        return start;
    }

    public String getEnd() {
        return end;
    }

    public Float getPrice() {
        return price;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

}
