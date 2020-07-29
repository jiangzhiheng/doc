from flask import Blueprint,render_template,flash,redirect,url_for
# 导入表单注册类
from App.forms import Register,Login,AgainActive
from App.models import User  # 导入User模型类
from App.email import send_mail # 导入发送邮件的函数
from flask_login import login_required,login_user,logout_user,current_user
from datetime import datetime


user = Blueprint('user',__name__)

"""
注册步骤
1. 创建模型类
2. 加载flask-migrate扩展库
3. 在视图函数中导入模型类
4. 验证用户名是否存在
5. 获取模板前台传递过来的数据
6. 存储
7. 明文密码加密存储
8. 配置发送邮件扩展库和功能
9. 发送邮件
10. 消息闪现（发送成功，前去激活）
"""



@user.route('/register/',methods=['GET','POST'])
def register():
    # 实例化注册表单类
    form = Register()
    if form.validate_on_submit():
        # 实例化注册表单数据
        u = User(username=form.username.data,password=form.userpass.data,email=form.email.data)
        u.save()
        token = u.generate_token()
        # 发送邮件激活
        send_mail('账户激活',form.email.data,username=form.username.data,token=token)
        flash('注册成功，前去邮箱进行激活')
        # 成功，去登录
        return redirect(url_for('user.login'))
    return render_template('user/register.html',form=form)

# 进行账户激活的视图
@user.route('/active/<token>')
def active(token):
    if User.check_token(token):
        flash('激活成功，请前去登录')
        # 激活成功，跳转到登录
        return redirect(url_for('user.login'))
    else:
        flash('激活失败，请重新激活')
        return redirect(url_for(''))




# class ="media-object" src="{{ url_for('static',filename='upload/s_'+p.user.icon) }}" alt="..." width="100px" >


# 再次激活的视图
@user.route('/again_active/',methods=['GET','POST'])
def again_active():
    form = AgainActive()
    if form.validate_on_submit():
        u = User.query.filter(User.username == form.username.data).first()
        if not u:
            flash('请输入正确的用户名或密码')
        elif not u.check_password(form.userpass.data):
            flash('请输入正确的用户名或密码')
        elif not u.confirm:
            token = u.generate_token()
            # 发送邮件激活
            send_mail('账户激活', u.email, username=form.username.data, token=token)
            flash('激活邮件发送成功，请前往激活')
        else:
            flash('该账户已经激活，请前去登录')
    return render_template('user/again_active.html',form=form)


"""
登录步骤
1. 接收表单传递过来的数据
2. 查询用户名的对象
3. 判断用户名密码（错误的话给出提示）,激活状态
4. 登陆成功进行处理
5. 登陆失败给出提示
"""


# 登录的视图
@user.route('/login/',methods=['GET','POST'])
def login():
    form = Login()
    if form.validate_on_submit():
        u = User.query.filter(User.username == form.username.data).first()
        if not u:
            flash('请输入正确的用户名和密码')
        elif not u.confirm:
            flash('还未激活该账户，请前往激活')
            return redirect(url_for('user.again_active'))
        elif not u.check_password(form.userpass.data):
            flash('请输入正确的用户名或密码')
        else:
            flash('登录成功')
            # 修改上次登录时间
            u.lastLogin = datetime.utcnow()
            u.save()
            login_user(u,remember=form.remember.data) # 使用第三方扩展卡处理登陆状态的维持
            return redirect(url_for('main.index'))
    return render_template('user/login.html',form=form)



# 退出登录
@user.route('/logout/')
def logout():
    logout_user()
    flash('退出成功')
    return redirect(url_for('main.index'))



# 测试login_required
@user.route('/test/')
@login_required
def test():
    return '必须登录才能访问'


"""
登陆成功后 在跳转到上次过来的路由地址
"""