package domain;

public class Question {

    /*
    * 题目实体
    * */
    private String title;
    private String answer;

    public Question(){}

    public Question(String title, String answer) {
        this.title = title;
        this.answer = answer;
    }

    /*
    * 重写equals,hashCode方法
    *
    * */
    public boolean equals(Object obj){
        if (this==obj){
            return true;
        }
        if (obj instanceof Question){
            Question anotherQuestion = (Question)obj;
            String thisTitle = this.title.substring(0,this.title.indexOf("<br>"));
            String anotherTitle = anotherQuestion.title.substring(0,this.title.indexOf("<br>"));
            if (thisTitle.equals(anotherTitle)){
                return true;
            }
        }
        return false;
    }
    @Override
    public int hashCode(){
        String thisTitle = this.title.substring(0,this.title.indexOf("<br>"));
        return thisTitle.hashCode();
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
}
