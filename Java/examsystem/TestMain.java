package examsystem;

import java.util.ArrayList;
import java.util.Scanner;

public class TestMain {
    public static void main(String[] args) {
        ExamMach examMach = new ExamMach();//创建考试机

        //创建学生对象
        Scanner input = new Scanner(System.in);
        System.out.println("请输入用户名");
        String username = input.nextLine();
        System.out.println("请输入密码");
        String password = input.nextLine();
        Student student = new Student(username,password);
        String result = examMach.login(student.getUsername(),student.getPassword());
        if (result.equals("Login succ")){
            System.out.println("登陆成功，开始考试");
            ArrayList<Question> paper = examMach.getPaper(); //获取试卷
            String[] answers = student.exam(paper);  //考试
            Teacher teacher = new Teacher();
            int score = teacher.checkPaper(paper,answers);
            System.out.println(student.getUsername()+"最终的成绩是"+score);
        }


    }
}
