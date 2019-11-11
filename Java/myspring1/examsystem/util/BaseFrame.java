package util;

import javax.swing.*;
import java.awt.*;

public abstract class BaseFrame extends JFrame {
    //模板模式
    //属性
    public BaseFrame(){}
    public BaseFrame(String title){
        super(title);
    }

    protected void init(){
        this.setFontAndSoOn();
        this.addElement();
        this.addListener();
        this.setFrameSelf();
    }

    //1.设置字体 颜色 背景 布局等
    protected abstract void setFontAndSoOn();
    //2.将属性添加到窗体里
    protected abstract void addElement();
    //3.添加事件监听
    protected abstract void addListener();
    //4.设置窗体自身
    protected abstract void setFrameSelf();

}
