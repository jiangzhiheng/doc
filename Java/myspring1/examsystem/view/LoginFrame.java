package view;

import service.UserService;
import sun.util.resources.ms.CalendarData_ms_MY;
import util.BaseFrame;
import util.MySpring;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class LoginFrame extends BaseFrame {

    public LoginFrame(String title){
        super(title);
        this.init();
    }

    public LoginFrame(){
        this.init();
    }

    private JPanel mainPanel = new JPanel();
    private JLabel titleLabel = new JLabel("在 线 考 试 系 统");
    private JLabel accountLabel = new JLabel("账户");
    private JLabel passwordLabel = new JLabel("密码");
    //两个文本框
    private JTextField accountField = new JTextField();
    private JPasswordField passwordField = new JPasswordField();
    //两个按钮
    private JButton loginButton = new JButton("登 录");
    private JButton exitButton = new JButton("退 出");

    protected void setFontAndSoOn(){
        //设置组件的位置--布局管理
        mainPanel.setLayout(null);  //设置为自定义
        mainPanel.setBackground(Color.WHITE);
        //设置每一个组件的位置
        titleLabel.setBounds(120,40,340,35);
        titleLabel.setFont(new Font("黑体",Font.BOLD,34));
        accountLabel.setBounds(94,124,90,30);
        accountLabel.setFont(new Font("黑体",Font.BOLD,24));
        accountField.setBounds(204,124,260,30);
        accountField.setFont(new Font("黑体",Font.BOLD,24));

        passwordLabel.setBounds(94,174,90,30);
        passwordLabel.setFont(new Font("黑体",Font.BOLD,24));
        passwordField.setBounds(204,174,260,30);
        passwordField.setFont(new Font("黑体",Font.BOLD,24));

        loginButton.setBounds(154,232,100,30);
        loginButton.setFont(new Font("黑体",Font.BOLD,22));
        exitButton.setBounds(304,232,100,30);
        exitButton.setFont(new Font("黑体",Font.BOLD,22));
    }
    //将所有组件添加到窗体
    protected void  addElement(){
        //将所有组件添加至窗体上
        mainPanel.add(titleLabel);
        mainPanel.add(accountLabel);
        mainPanel.add(passwordLabel);
        mainPanel.add(accountField);
        mainPanel.add(passwordField);
        mainPanel.add(loginButton);
        mainPanel.add(exitButton);
        this.add(mainPanel);
    }

    protected void addListener(){
        //绑定事件监听器
        ActionListener listener = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                //获取用户登录的账号和密码  文本框 密码框
                String account = accountField.getText();
                String password = new String(passwordField.getPassword());
                //调用之前的登录方法
                UserService service= MySpring.getBean("service.UserService");
                String result = service.login(account,password);
                if (result.equals("登录成功")){
                    LoginFrame.this.setVisible(false);
                    //弹出新的考试界面
                    new ExamFrame();
                    //System.out.println(result);
                }else {
                    //弹出警告窗口，登录失败
                    JOptionPane.showMessageDialog(LoginFrame.this,result);
                    //设置文本框值为空
                    accountField.setText("");
                    passwordField.setText("");
                }
            }
        };
        loginButton.addActionListener(listener);
    }

    protected void setFrameSelf(){
        //设置窗体起始位置和大小
        this.setBounds(600,280,560,340);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setResizable(false); //设置不可拖拽
        this.setVisible(true);
    }

}
