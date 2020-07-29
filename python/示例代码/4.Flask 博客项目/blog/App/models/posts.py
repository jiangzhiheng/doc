from App.extensions import db
from .db_base import DB_Base
from datetime import datetime

# 博客模型

class Posts(DB_Base,db.Model):
    __tablename__ = 'posts'
    id = db.Column(db.Integer,primary_key=True)
    title = db.Column(db.String(30),index=True)   # 标题
    article = db.Column(db.Text)   # 博客内容
    pid = db.Column(db.Integer,default=0)  # 父id
    path = db.Column(db.Text,default='0,') # 路径
    visit = db.Column(db.Integer,default=0)  # 访问量
    timestamp = db.Column(db.DateTime,default=datetime.utcnow)  # 发表时间
    # 设置一对多外键
    uid = db.Column(db.Integer,db.ForeignKey('user.id'))  # 设置外键，关联主表user的自增id
    state = db.Column(db.Integer,default=0)  # 是否所有人可见






