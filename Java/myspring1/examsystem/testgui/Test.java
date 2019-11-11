package testgui;

import domain.Question;
import service.QuestionService;
import service.UserService;
import util.MySpring;
import view.LoginFrame;

import java.util.ArrayList;

public class Test {
    public static void main(String[] args) {
        //new LoginFrame("登录窗口");
        //一个题目 题干+答案
        //
        //String question = "以下哪个是Java的基本数据类型？\n\tA.String\n\tB.Integer\n\tC.Boolean\n\tD.Math";
        QuestionService service = MySpring.getBean("service.QuestionService");
        ArrayList<Question> paper = service.getPaper(5);
        for (Question question:paper){
            String title = question.getTitle().replace("<br>","\n   ");
            System.out.println(title);
        }

    }
}
