from flask import render_template,current_app
from threading import Thread
from flask_mail import Message
from App.extensions import mail


# 异步执行耗时的操作
def async_send_mail(app,msg):
    with app.app_context():
        mail.send(message=msg)

def send_mail(subject,to,tem='active',**kwargs):
    app = current_app._get_current_object()
    # 创建邮件对象
    msg = Message(subject=subject,recipients=[to],sender=app.config['MAIL_USERNAME'])
    # 邮件主体内容
    # msg.html = '<h4>用户验证邮件</h4>'
    msg.html = render_template('email/' + tem + '.html',**kwargs)
    # 发送邮件
    # 创建线程
    thr = Thread(target=async_send_mail,args=(app,msg,))
    # 启动线程
    thr.start()
    return '发送邮件'
