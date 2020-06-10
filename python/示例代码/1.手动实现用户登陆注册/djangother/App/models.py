from django.contrib.auth.hashers import make_password,check_password
from django.db import models
from django.core.cache import cache
import uuid,hashlib

# Create your models here.
class User(models.Model):
    username = models.CharField(db_index=True,max_length=20,unique=True,verbose_name='用户名')
    password_hash = models.CharField(max_length=140,verbose_name='密码')
    sex = models.BooleanField(default=True,verbose_name='性别')
    age = models.IntegerField(default=18,verbose_name='年龄')
    email = models.CharField(max_length=50,unique=True,verbose_name='邮箱')
    info = models.CharField(max_length=20, default='Martin is NB',verbose_name='简介')
    createtime = models.DateTimeField(auto_now_add=True,verbose_name='加入时间')
    confirm = models.BooleanField(default=False,verbose_name='激活状态')

    class Meta:
        db_table = 'user'

    def __str__(self):
        return self.username
    # 密码加密处理的类装饰器
    @property
    def password(self):
        raise AttributeError
    @password.setter
    def password(self,password):
        # 密码加密处理
        self.password_hash = make_password(password)
    # 验证密码
    def check_password(self,password):
        return check_password(password,self.password_hash)

    # 生成token方法
    def generate_token(self):
        # 拿到唯一的uuid字符串并进行编码
        u = uuid.uuid4()
        Str = str(u).encode('utf-8')
        md5 = hashlib.md5()
        md5.update(Str)
        token = md5.hexdigest()
        # 设置缓存，用户进行请求的字符串为生成的唯一字符串作为缓存的key，一小时内有效
        cache.set(token,{'id':self.id},3600)
        return token

    # 验证邮件激活
    @staticmethod
    def check_token(token):
        try:
            # 根据缓存的key去除id
            id = cache.get(token)['id']
            u = User.objects.get(pk=id)
            u.confirm = True
            u.save()
            return True
        except:
            return False
