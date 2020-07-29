import os

BASE_DIR = os.path.abspath(os.path.dirname(__file__))

# 配置类的基类
class Config:
    SECRET_KEY = 'SECRETKEY'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    BOOTSTRAP_SERVE_LOCAL = True # 加载本地静态资源文件
    # 邮箱配置
    MAIL_SERVER = 'smtp.qq.com'
    MAIL_USERNAME = '1689991551@qq.com'
    MAIL_PASSWORD = 'afbpijbqunjsdici'
    # 分页每页显示数据条数
    PAGE_NUM = 3
    # 文件上传配置
    UPLOADED_PHOTOS_DEST = os.path.join(BASE_DIR,'static/upload')
    MAX_CONTENT_LENGTH = 1024*1024*64

# 开发环境
class DevelopmentConfig(Config):
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:123456@192.168.1.129:3306/testdb'
    DEBUG = True
    TESTING = False

# 测试环境
class TestingConfig(Config):
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:123456@192.168.1.129:3306/testdb'
    DEBUG = False
    TESTING = True

# 生产环境
class ProductionConfig(Config):
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:123456@192.168.1.129:3306/blog'
    DEBUG = False
    TESTING = False


# 配置类的字典
configDict = {
    'default':DevelopmentConfig,
    'dev':DevelopmentConfig,
    'test':TestingConfig,
    'production':ProductionConfig,
}
