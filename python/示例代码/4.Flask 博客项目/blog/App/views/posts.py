from flask import Blueprint, render_template, flash, redirect, url_for, current_app, request, jsonify
from App.forms import SendPosts, Comment  # 导入发表博客与评论回复表单类
from App.models import Posts  # 导入博客模型类
from flask_login import login_required, current_user
from sqlalchemy import or_  # 导入或查询

posts = Blueprint('posts', __name__)


# 发表博客
@posts.route('/send_posts/', methods=['GET', 'POST'])
# @login_required
def send_posts():
    form = SendPosts()
    # 判断登录后在进行发表
    if not current_user.is_authenticated:
        flash('您还没有登录  请登录后在发表')
    elif form.validate_on_submit():
        # 保存发表博客的数据
        Posts(title=form.title.data, article=form.article.data, user=current_user).save()
        flash('博客发表成功')
        return redirect(url_for('main.index'))
    return render_template('posts/send_posts.html', form=form)


# 博客搜索
@posts.route('/search/', methods=['GET', 'POST'])
def search():
    try:
        page = int(request.args.get('page', 1))
    except:
        page = 1
    # 获取搜索的关键字
    if request.method == 'POST':
        keyword = request.form.get('keyword', '')
    else:
        keyword = request.args.get('keyword', '')
    # 查询pid为0并且所有人可见的博客  pid不为0 证明是评论和回复的内容  按照时间的降序显示
    pagination = Posts.query.filter(or_(Posts.title.contains(keyword), Posts.article.contains(keyword)), Posts.pid == 0,
                                    Posts.state == 0).order_by(Posts.timestamp.desc()).paginate(page,
                                                                                                current_app.config[
                                                                                                    'PAGE_NUM'], False)
    data = pagination.items  # 获取page页面的数据
    return render_template('posts/search_detail.html', pagination=pagination, posts=data, keyword=keyword)


# 博客详情
@posts.route('/posts_detail/<int:pid>/')
def posts_detail(pid):
    # 查询当前博客的内容 pid为博客的自增id 并不是博客模型字段的pid
    p = Posts.query.get(pid)
    p.visit += 1  # 博客的访问量
    p.save()
    form = Comment()  # 发表评论和回复的表单类
    # 查询出博客的评论内容和回复 按照博客内容和回复在一起的排序顺序  过滤条件为博客的path宏包含博客id 的 这样就将博客的内容过滤了出去  只查询评论和回复的内容
    comment = Posts.query.filter(Posts.path.contains(str(pid))).order_by(Posts.path.concat(Posts.id))
    return render_template('posts/posts_detail.html', posts=p, form=form, comment=comment)


# 评论和回复
@posts.route('/comment/', methods=['GET', 'POST'])
@login_required
def comment():
    pid = request.form.get('pid')
    rid = request.form.get('rid')
    # 判断当前是评论还是回复 如果为评论则为假 否则为真
    if rid:
        id = rid
    else:
        id = pid
    p = Posts.query.get(int(id))
    Posts(article=request.form.get('article'), pid=id, path=p.path + id + ',', user=current_user).save()
    return redirect(url_for('posts.posts_detail', pid=pid))


# 处理博客收藏与取消收藏的操作
@posts.route('/do_favorite/')
def do_favorite():
    try:
        # 获取ajax传递过来的pid
        pid = int(request.args.get('pid'))
        # 判断是否收藏了
        if current_user.is_favorite(pid):
            # 调用取消收藏
            current_user.delete_favorite(pid)
            print('取消')
        else:
            # 调用执行收藏
            current_user.add_favorite(pid)
            # print('收藏')

        return jsonify({'res': 200})
    except:
        return jsonify({'res': 500})