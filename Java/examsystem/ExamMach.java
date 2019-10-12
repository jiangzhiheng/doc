package examsystem;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Random;
import java.util.HashMap;

public class ExamMach {
    //属性  题库 Question对象
    //Set集合，自动
    private HashSet<Question> questionBank = new HashSet<>();
    {
        //利用块初始化hashSet集合内的题目对象
        questionBank.add(new Question("如下A哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","A"));
        questionBank.add(new Question("如下C哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","C"));
        questionBank.add(new Question("如下D哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","D"));
        questionBank.add(new Question("如下B哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","B"));
        questionBank.add(new Question("如下C哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","C"));
        questionBank.add(new Question("如下D哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","D"));
        questionBank.add(new Question("如下A哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","A"));
        questionBank.add(new Question("如下B哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","B"));
        questionBank.add(new Question("如下B哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","B"));
        questionBank.add(new Question("如下A哪个选项不是Java的基本数据类型？\n\tA.String\n\tB.Char\n\tC.Boolean\n\tD.int","A"));
    }

    private HashMap<String,String> userBox = new HashMap<>();
    {
        userBox.put("martin","111");
        userBox.put("jerry","222");
        userBox.put("tony","333");
    }

    //登陆认证
    public String login(String name,String password){
        String readPassword = this.userBox.get(name);
        if (readPassword!=null && readPassword.equals(password)){
            return "Login succ";
        }
        return "username or password error";
    }


    //设计方法 随机产生试卷
    //参数  确定试卷5道题  不用  返回值 试卷ArrayList<Question>
    public ArrayList<Question> getPaper(){
        //随机抽取试卷的时候 试卷题目应该不充分 Set存 --->ArrayList
        HashSet<Question> paper = new HashSet<>(); //试卷
        //产生一个随机序号 去寻找题目 题库是Set无序号
        ArrayList<Question> questionBank = new ArrayList<>(this.questionBank);
        //随机抽取题目
        while (paper.size()!=5){
            int index = new Random().nextInt(this.questionBank.size());
            paper.add(questionBank.get(index));
        }
        return new ArrayList<Question>(paper);
    }
}
