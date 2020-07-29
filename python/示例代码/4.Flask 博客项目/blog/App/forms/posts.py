from flask_wtf import FlaskForm
from wtforms import StringField,TextAreaField,SubmitField
from wtforms.validators import Length,DataRequired


# 发表博客的表单类
class SendPosts(FlaskForm):
    title = StringField('标题',validators=[DataRequired('标题内容不能为空'),Length(min=3,max=30,message='标题长度在3-20字之间')],render_kw={'placeholder':'请输入标题'})
    article = TextAreaField('博客内容',validators=[DataRequired('博客内容不能为空'),Length(min=20,max=1000,message='博客内容在20-1000字之间')],render_kw={'placeholder':'请输入博客内容'})
    submit = SubmitField('发表')

# 发表评论和回复的表单类
class Comment(FlaskForm):
    article = TextAreaField('评论内容',validators=[DataRequired('评论内容不能为空'),Length(min=20,max=1000,message='评论内容在5-100字之间')])
    submit = SubmitField('发表')



