from flask import Blueprint,render_template,redirect,url_for,flash,request,current_app
from App.forms import UserInfo # 个人信息显示user模型类
from flask_login import current_user,login_required
from App.models import Posts
from App.extensions import db,file
from App.forms import SendPosts,Upload # 用户编辑博客,文件上传表单类
import os
from PIL import Image

owncenter = Blueprint('owncenter',__name__)

# 查看与修改个人信息
@owncenter.route('/user_info/',methods=['GET','POST'])
@login_required
def user_info():
    form = UserInfo()
    if form.validate_on_submit():
        #
        current_user.age = form.age.data
        current_user.sex = int(form.sex.data)
        current_user.save()
    # 给表单设置默认值
    form.username.data = current_user.username
    form.age.data = current_user.age
    form.sex.data = str(int(current_user.sex))
    form.email.data = current_user.email
    form.lastlogin.data = current_user.lastLogin
    form.register.data = current_user.registerTime
    return render_template('owncenter/user_info.html',form=form)



# 博客管理
# 任务：因为正常来说删除处理不会真正的执行删除，只是逻辑上标记为删除，
# 在posts的模型上添加一个字段，当执行了删除，那么更改字段状态 那么用户就查看不到
@owncenter.route('/posts_manager/')
@login_required
def posts_manager():
    # 查询当前用户发表的所有博客，pid为0证明是博客内容，而不是评论和回复，state=0是所有人可见，按照时间降序查询
    posts = current_user.posts.filter_by(pid=0,state=0).order_by(Posts.timestamp.desc())
    return render_template('owncenter/posts_manager.html',posts=posts)


# 博客删除
@owncenter.route('/del_posts/<int:pid>/')
@login_required
def del_posts(pid):
    # 查询博客
    p = Posts.query.get(pid)
    # 判断博客 是否存在
    if p:
        flash('删除成功')
        p.delete()  # 删除博客内容
        comment = Posts.query.filter(Posts.path.contains(str(pid)))
        # 删除评论和回复
        for post in comment:
            post.delete()
    else:
        flash('您要删除的博客不存在')
    return redirect(url_for('owncenter.posts_manager'))


# 博客编辑
@owncenter.route('/edit_posts/<int:pid>/',methods=['GET','POST'])
@login_required
def edit_posts(pid):
    form = SendPosts() # 实例化表单
    p = Posts.query.get(pid)  # 根据博客id查询博客
    if not p:
        flash('该博客不存在')
        return redirect(url_for('owncenter.posts_manager'))
    if form.validate_on_submit():
        # 更新数据的存储
        p.title = form.title.data
        p.article = form.article.data
        p.save()
        flash('博客更新成功')
        return redirect(url_for('owncenter.posts_manager'))
    form.title.data = p.title
    form.article.data = p.article
    return render_template('owncenter/edit_posts.html',form=form)


# 生成唯一的图片名
def random_filename(suffix,length=32):
    import string,random
    Str = string.ascii_letters+string.digits
    return ''.join(random.choice(Str) for i in range(length))+'.'+suffix


# 图片缩放处理
def image_zoom(path,prefix='s_',width=100,height=100):
    # 打开文件
    img = Image.open(path)
    # 重新设计尺寸
    img.thumbnail((width, height))
    # 拆分传递进来的图片的路径，拆分进行前缀的拼接
    pathSplit = os.path.split(path)
    path = os.path.join(pathSplit[0],prefix+pathSplit[1])
    # 保存缩放后的图片，保留原图片
    img.save(path)

# 头像上传
@owncenter.route('/upload/',methods=['GET','POST'])
@login_required
def upload():
    form = Upload()
    if form.validate_on_submit():
        # 获取上传对象
        icon = request.files.get('icon')
        # 获取后缀
        suffix = icon.filename.split('.')[-1]
        newName = random_filename(suffix)  # 获取新的图片名称

        # 保存图片
        file.save(icon,name=newName)
        delPath = current_app.config['UPLOADED_PHOTOS_DEST']
        # 删除之前上传过的图片
        if current_user.icon != 'default.jpg':
            os.remove(os.path.join(delPath, current_user.icon))
            os.remove(os.path.join(delPath, 'b_'+current_user.icon))
            os.remove(os.path.join(delPath, 'm_'+current_user.icon))
            os.remove(os.path.join(delPath, 's_'+current_user.icon))
        # 更改当前对象的图片名称，并更新到数据库中
        current_user.icon = newName
        db.session.add(current_user)
        db.session.commit()
        # 拼接图片路径
        path = os.path.join(delPath,newName)
        # 进行头像的多次缩放
        image_zoom(path)
        image_zoom(path,'m_',200,200)
        image_zoom(path,'b_',300,300)
    return render_template('owncenter/upload.html',form=form)



# 收藏管理
@owncenter.route('/my_favorite/')
@login_required
def my_favorite():
    # 查出用户所有收藏的博客
    posts = current_user.favorites.all()
    return render_template('owncenter/my_favorite.html',posts=posts)

# 取消收藏
@owncenter.route('/del_favorite/<int:pid>/')
@login_required
def del_favorite(pid):
    # 判断是否收藏了
    if current_user.is_favorite(pid):
        # 调用取消收藏
        current_user.delete_favorite(pid)
    flash('取消收藏成功')
    return redirect(url_for('owncenter.my_favorite'))













