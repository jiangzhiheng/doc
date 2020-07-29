from flask import Flask
# 导入views注册蓝本对象的方法
from App.views import register_blueprint
# 导入配置类的字典
from .config import configDict
# 导入初始化扩展库的init_app方法
from .extensions import init_app
from App.models import Posts


# 加载整个App项目并返回App对象
def create_app(configName='default'):
    app = Flask(__name__)
    # 加载配置类
    app.config.from_object(configDict[configName])
    # 注册蓝本
    register_blueprint(app)
    # 初始化扩展库
    init_app(app)
    # 添加自定义模板过滤器
    addTemFilter(app)
    return app




# 自定义模板过滤器
def addTemFilter(app):
    # 内容超过给定的长度显示...
    def showEllipsis(Str,length=30):
        if len(Str) > length:
            Str = Str[0:length]+'...'
        return Str

    # 获取博客评论回复人的过滤器
    def replayName(pid):
        username = Posts.query.get(int(pid)).user.username
        return username
    app.add_template_filter(showEllipsis)
    app.add_template_filter(replayName)

