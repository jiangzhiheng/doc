from .main import main # 导入main蓝本对象
from .user import user
from .posts import posts  # 导入posts博客处理的蓝本对象
from .owncenter import owncenter # 个人中心蓝本对象
# 循环迭代的蓝本配置
bluepring_config = [
    (main,''),
    (user,''),
    (posts, ''),
    (owncenter, ''),
]


# 注册蓝本对象
def register_blueprint(app):
    # 循环迭代注册蓝本
    for blueprint,prefix in bluepring_config:
        app.register_blueprint(blueprint,url_prefix=prefix)








