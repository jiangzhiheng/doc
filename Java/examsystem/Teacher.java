package examsystem;

import javax.swing.table.TableRowSorter;
import java.util.ArrayList;

public class Teacher {
    //批卷子
    //参数 学生作答的选项 真实的试卷
    //返回值 int
    public int checkPaper(ArrayList<Question> paper,String[] answers){
        System.out.println("老师正在批阅，请等待");
        try {
            Thread.sleep(5000);
        }catch (Exception e){
            e.printStackTrace();
        }
        int score = 0;
        for (int i =0;i<paper.size();i++){
            Question question = paper.get(i);
            if (question.getAnswer().equalsIgnoreCase(answers[i])){
                score+=(100/paper.size());
            }
        }
        return score;
    }
}
