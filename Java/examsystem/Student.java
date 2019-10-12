package examsystem;

import java.security.PublicKey;
import java.util.ArrayList;
import java.util.Scanner;

public class Student {
    //属性
    private String username;
    private String password;
    public Student(String username,String password){
        this.username = username;
        this.password = password;
    }
    public String getUsername(){
        return this.username;
    }
    public String getPassword(){
        return this.password;
    }

    //考试方法
    //参数是一套试卷  返回值 学生的所有选项String[]
    public String[] exam(ArrayList<Question> paper){
        String[] answers = new String[paper.size()];
        for (int i=0;i<paper.size();i++){
            Scanner input  = new Scanner(System.in);
            Question question = paper.get(i);
            System.out.println((i+1)+"."+question.getTitle());
            System.out.println("请输入您认为正确的选项？");
            answers[i] = input.nextLine();
        }
        return answers;
    }

}
