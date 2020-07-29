from flask_bootstrap import Bootstrap
from flask_sqlalchemy import SQLAlchemy # ORM模型扩展库
from flask_migrate import Migrate
from flask_mail import Mail,Message # 邮件发送扩展库
from flask_login import LoginManager  # pip install flask-login处理用户登录的第三方扩展库
from flask_moment import Moment # 时间显示
# 导入头像上传
from flask_uploads import IMAGES,UploadSet,configure_uploads,patch_request_class


# 实例化
bootstrap = Bootstrap()  # Bootstrap扩展库实例化
db = SQLAlchemy()    # ORM模型
migrate = Migrate()  # 模型迁移
mail = Mail() # 邮件发送
login_manager = LoginManager() # 处理登录
moment = Moment()  # 格式化时间显示
file = UploadSet('photos',IMAGES)

# 加载app
def init_app(app):
    bootstrap.init_app(app)
    db.init_app(app)
    migrate.init_app(app=app,db=db)
    mail.init_app(app)
    moment.init_app(app)

    login_manager.init_app(app)
    login_manager.login_view = 'user.login'  # 当你没有登录访问了需要登录的路由的时候，进行登陆的端点
    login_manager.login_message = '您还没有登录，请先登录在访问'
    login_manager.session_protection = 'strong' # 设置session的保护级别

    # 配置文件上传
    configure_uploads(app,file)
    patch_request_class(app,size=None)


