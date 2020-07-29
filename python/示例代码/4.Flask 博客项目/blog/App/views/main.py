from flask import Blueprint,render_template,request,current_app
from werkzeug.security import generate_password_hash,check_password_hash
from App.models import Posts

main = Blueprint('main',__name__)


# 首页视图
@main.route('/')
def index():
    try:
        page = int(request.args.get('page',1))
    except:
        page = 1
    # 查询pid为0并且所有人可见的博客  pid不为0 证明是评论和回复的内容  按照时间的降序显示
    pagination = Posts.query.filter(Posts.pid == 0,Posts.state == 0).order_by(Posts.timestamp.desc()).paginate(page,current_app.config['PAGE_NUM'],False)
    data = pagination.items # 返回page页面的数据
    return render_template('main/index.html',posts=data,pagination=pagination)


# 测试密码加密
@main.route('/test_hash/')
def test_hash():
    h = generate_password_hash('123456')
    check_password_hash(h,'123456')
    return 'xxx'

