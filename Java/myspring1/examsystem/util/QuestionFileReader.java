package util;

import domain.Question;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;

public class QuestionFileReader {
    /*
    * 程序执行时，将文件中的所有题目一次性都读取出来
    * */

    private HashSet<Question> questionsBox = new HashSet<>();

    {
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader("src//dbfile//Question.txt"));
            String message = reader.readLine();
            while (message!= null){
                String[] values = message.split("#");
                questionsBox.add(new Question(values[0],values[1]));
                message = reader.readLine();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            if (reader!= null){
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public HashSet<Question> getQuestionsBox(){
        return questionsBox;
    }
}
