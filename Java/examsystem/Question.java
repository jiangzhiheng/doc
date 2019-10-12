package examsystem;

public class Question {
    private String title;
    private String answer; //真实答案

    public Question(String title,String answer){
        this.title = title;
        this.answer = answer;
    }

    //重写方法，将默认比较题目对象的地址规则改编成比较题干
    public boolean equals(Object obj) {
        if (this==obj){
            return true;
        }
        if (obj instanceof Question){
            Question anotherQuestion = (Question)obj;
            if (this.title.equals(anotherQuestion)){
                return true;
            }
        }
        return false;
    }
    public int hashCode(){
        return this.title.hashCode();
    }

    public String getTitle(){
        return this.title;
    }
    public String getAnswer(){
        return this.answer;
    }

}

