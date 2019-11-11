package dao;

import domain.Question;
import util.MySpring;
import util.QuestionFileReader;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Random;

public class QuestionDao {

    private QuestionFileReader reader = MySpring.getBean("util.QuestionFileReader");
    //将缓存中的集合改为List集合，Set集合无索引
    private ArrayList<Question> questionsBank = new ArrayList<>(reader.getQuestionsBox());
    /*
    * 负责读取题目 随机生成一套试卷
    * 生成的试卷为5个题
    * 返回值？----Question   ArrayList<Question>
    * 参数？-----题库数量 5
    *
    * */
    public ArrayList<Question> getPaper(int count){
        HashSet<Question> paper = new HashSet<>(); //存储最终的试卷
        while (paper.size()!=count){
            Random r = new Random();
            int index = r.nextInt(this.questionsBank.size()); //[0,10)
           paper.add(this.questionsBank.get(index)) ;
        }
        return new ArrayList<Question>(paper);
    }
}
