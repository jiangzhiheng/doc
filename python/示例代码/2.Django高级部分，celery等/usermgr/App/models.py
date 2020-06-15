from django.db import models
from django.contrib.auth.models import AbstractUser # 导入user抽象类
# Create your models here.

class User(AbstractUser):
    phone = models.CharField(max_length=11)
    icon = models.CharField(max_length=50,default='default.jpg')


from tinymce.models import HTMLField
# 配置富文本编辑器使用的模型类
class Posts(models.Model):
    title = models.CharField(max_length=20,default='标题')
    article = HTMLField(verbose_name="文章")