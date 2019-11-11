package service;

import dao.QuestionDao;
import domain.Question;
import util.MySpring;

import java.util.ArrayList;

public class QuestionService {
    //在service需要底层dao支持
    private QuestionDao dao = MySpring.getBean("dao.QuestionDao");

    public ArrayList<Question> getPaper(int count){
        return dao.getPaper(count);
    }
}
