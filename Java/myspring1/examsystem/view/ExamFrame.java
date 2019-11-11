package view;

import util.BaseFrame;

import javax.swing.*;
import java.awt.*;

public class ExamFrame extends BaseFrame {

    public ExamFrame(){
        this.init();
    }
    public ExamFrame(String title){
        super(title);
        this.init();
    }


    //添加三个pannel 区域分割
    private JPanel mainPannel = new JPanel();
    private JPanel messagePanel = new JPanel();
    private JPanel buttonPanel = new JPanel();

    //添加组件
    private JTextArea examArea = new JTextArea();//考试文本域
    private JScrollPane scrollPane = new JScrollPane(examArea);

    //右侧信息组件
    private JLabel pictureLabel = new JLabel();//图片
    private JLabel nowNumLabel = new JLabel("当前题号:");
    private JLabel totalCountLabel = new JLabel("题目总数:");
    private JLabel answerCountLabel = new JLabel("已答题数:");
    private JLabel unanswerCountLabel = new JLabel("未答题数:");
    private JTextField nowNumField = new JTextField("0");
    private JTextField totalCountField = new JTextField("0");
    private JTextField answerCountField = new JTextField("0");
    private JTextField unanswerCountField = new JTextField("0");
    private JLabel timeLabel = new JLabel("剩余答题时间");
    private JLabel realTimeLabel = new JLabel("00:00:00");

    //底部按钮组件
    private JButton aButton = new JButton("A");
    private JButton bButton = new JButton("B");
    private JButton cButton = new JButton("C");
    private JButton dButton = new JButton("D");

    private JButton prevButton = new JButton("Prev");
    private JButton nextButton = new JButton("Next");
    private JButton submitButton = new JButton("Submit");


    protected void setFontAndSoOn() {
        //设置pannel布局管理
        mainPannel.setLayout(null);
        messagePanel.setLayout(null);
        buttonPanel.setLayout(null);
        //手动设置每一个组件的位置，字体，背景色
        mainPannel.setBackground(Color.LIGHT_GRAY);
        scrollPane.setBounds(16,10,650,450);
        examArea.setFont(new Font("黑体",Font.BOLD,34));
        examArea.setEnabled(false); //不可编辑

        messagePanel.setBounds(680,10,300,550);
        messagePanel.setBorder(BorderFactory.createLineBorder(Color.GRAY));

        buttonPanel.setBounds(16,470,650,90);
        buttonPanel.setBorder(BorderFactory.createLineBorder(Color.GRAY));

        //message区域中的每一个组件位置
        pictureLabel.setBounds(10,10,280,230);
        pictureLabel.setBorder(BorderFactory.createLineBorder(Color.GRAY));
        pictureLabel.setIcon(null);//展示图片信息

        nowNumLabel.setBounds(40,270,100,30);
        nowNumLabel.setFont(new Font("黑体",Font.PLAIN,20));
        nowNumField.setBounds(150,270,100,30);
        nowNumField.setFont(new Font("黑体",Font.BOLD,20));
        nowNumField.setBorder(BorderFactory.createLineBorder(Color.GRAY));
        nowNumField.setEnabled(false);
        nowNumField.setHorizontalAlignment(JTextField.CENTER);

        totalCountLabel.setBounds(40,310,100,30);
        totalCountLabel.setFont(new Font("黑体",Font.PLAIN,20));
        totalCountField.setBounds(150,310,100,30);
        totalCountField.setFont(new Font("黑体",Font.BOLD,20));
        totalCountField.setBorder(BorderFactory.createLineBorder(Color.GRAY));
        totalCountField.setEnabled(false);
        totalCountField.setHorizontalAlignment(JTextField.CENTER);

        answerCountLabel.setBounds(40,350,100,30);
        answerCountLabel.setFont(new Font("黑体",Font.PLAIN,20));
        answerCountField.setBounds(150,350,100,30);
        answerCountField.setFont(new Font("黑体",Font.BOLD,20));
        answerCountField.setBorder(BorderFactory.createLineBorder(Color.GRAY));
        answerCountField.setEnabled(false);
        answerCountField.setHorizontalAlignment(JTextField.CENTER);

        unanswerCountLabel.setBounds(40,390,100,30);
        unanswerCountLabel.setFont(new Font("黑体",Font.PLAIN,20));
        unanswerCountField.setBounds(150,390,100,30);
        unanswerCountField.setFont(new Font("黑体",Font.BOLD,20));
        unanswerCountField.setBorder(BorderFactory.createLineBorder(Color.GRAY));
        unanswerCountField.setEnabled(false);
        unanswerCountField.setHorizontalAlignment(JTextField.CENTER);

        timeLabel.setBounds(90,460,150,30);
        timeLabel.setFont(new Font("黑体",Font.PLAIN,20));
        timeLabel.setForeground(Color.BLUE);
        realTimeLabel.setBounds(108,490,150,30);
        realTimeLabel.setFont(new Font("黑体",Font.BOLD,20));
        timeLabel.setForeground(Color.BLUE);

        aButton.setBounds(40,10,120,30);
        bButton.setBounds(190,10,120,30);
        cButton.setBounds(340,10,120,30);
        dButton.setBounds(490,10,120,30);

        prevButton.setBounds(40,50,100,30);
        nextButton.setBounds(510,50,100,30);
        submitButton.setBounds(275,50,100,30);
        submitButton.setForeground(Color.RED);
        submitButton.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
    }

    @Override
    protected void addElement() {
        messagePanel.add(pictureLabel);
        messagePanel.add(nowNumLabel);
        messagePanel.add(nowNumField);

        messagePanel.add(totalCountLabel);
        messagePanel.add(totalCountField);

        messagePanel.add(answerCountLabel);
        messagePanel.add(answerCountField);

        messagePanel.add(unanswerCountLabel);
        messagePanel.add(unanswerCountField);

        messagePanel.add(timeLabel);
        messagePanel.add(realTimeLabel);

        buttonPanel.add(aButton);
        buttonPanel.add(bButton);
        buttonPanel.add(cButton);
        buttonPanel.add(dButton);
        buttonPanel.add(prevButton);
        buttonPanel.add(nextButton);
        buttonPanel.add(submitButton);

        mainPannel.add(scrollPane);
        mainPannel.add(messagePanel);
        mainPannel.add(buttonPanel);
        this.add(mainPannel);
    }

    @Override
    protected void addListener() {

    }

    @Override
    protected void setFrameSelf() {
        this.setBounds(260,130,1000,600);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setResizable(false); //禁止拖拽
        this.setVisible(true);
    }

}
