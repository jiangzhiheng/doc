from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.
# user模型
class User(AbstractUser):
    icon = models.CharField(max_length=70,default='default.jpg')
    class Meta:
        db_table = 'user'


# 定义一个抽象类  共有的父类  用子类集成实现
class Common(models.Model):
    img = models.CharField(max_length=100)
    name = models.CharField(max_length=30)
    trackid = models.CharField(max_length=10)
    class Meta:
        abstract = True


# 轮播图
class Wheel(Common):
    class Meta:
        db_table = 'axf_wheel'


# nav 每日必抢
class Nav(Common):
    class Meta:
        db_table = 'axf_nav'


# 必买
class MustBuy(Common):
    class Meta:
        db_table = 'axf_mustbuy'


# 便利店
class Shop(Common):
    class Meta:
        db_table = 'axf_shop'


# mainshow 主要卖品
class MainShow(models.Model):
    trackid = models.CharField(max_length=10)
    name = models.CharField(max_length=30)
    img = models.CharField(max_length=100)
    categoryid = models.CharField(max_length=10)
    brandname = models.CharField(max_length=10)
    img1  = models.CharField(max_length=100)
    childcid1 = models.CharField(max_length=10)
    productid1 = models.CharField(max_length=10)
    longname1 = models.CharField(max_length=100)
    price1 = models.CharField(max_length=10)
    marketprice1 = models.CharField(max_length=10)
    img2 = models.CharField(max_length=100)
    childcid2 = models.CharField(max_length=10)
    productid2 = models.CharField(max_length=10)
    longname2 = models.CharField(max_length=100)
    price2 = models.CharField(max_length=10)
    marketprice2 = models.CharField(max_length=10)
    img3 = models.CharField(max_length=100)
    childcid3 = models.CharField(max_length=10)
    productid3 = models.CharField(max_length=10)
    longname3 = models.CharField(max_length=100)
    price3 = models.CharField(max_length=10)
    marketprice3  = models.CharField(max_length=10)
    class Meta:
        db_table = 'axf_mainshow'


# 商品类别表
class FoodTypes(models.Model):
    typeid = models.CharField(max_length=10)
    typename = models.CharField(max_length=10)
    childtypenames = models.CharField(max_length=120)
    typesort = models.CharField(max_length=10)
    class Meta:
        db_table = 'axf_foodtypes'


# 商品数据
class Goods(models.Model):
    productid = models.CharField(max_length=10)
    productimg = models.CharField(max_length=100)
    productname = models.CharField(max_length=30)
    productlongname = models.CharField(max_length=100)
    isxf = models.CharField(max_length=10)
    pmdesc = models.CharField(max_length=10)
    specifics = models.CharField(max_length=10)
    price = models.CharField(max_length=10)
    marketprice = models.CharField(max_length=10)
    categoryid = models.CharField(max_length=10)
    childcid = models.CharField(max_length=10)
    childcidname = models.CharField(max_length=30)
    dealerid = models.CharField(max_length=10)
    storenums = models.CharField(max_length=10)
    productnum = models.CharField(max_length=10)
    class Meta:
        db_table = 'axf_goods'


# 购物车模型
class Car(models.Model):
    goods = models.ForeignKey(Goods)  # 商品的外键  用于动态查询商品的数据 一对多
    user = models.ForeignKey(User)  # 查询哪个用户的购物车数据
    num = models.IntegerField(default=1) # 商品在购物的数量
    isChoose = models.BooleanField(default=True)  # 当前商品是否被选中
    class Meta:
        db_table = 'axf_car'


# 地址模型
class Address(models.Model):
    user = models.ForeignKey(User)
    address = models.CharField(max_length=100)
    phone = models.CharField(max_length=11)
    name = models.CharField(max_length=10)
    state = models.BooleanField(default=False)  # 默认地址
    class Meta:
        db_table = 'axf_address'


# 订单模型
class Order(models.Model):
    user = models.ForeignKey(User)
    address = models.ForeignKey(Address)
    money = models.DecimalField(max_digits=8,decimal_places=2)
    message = models.CharField(max_length=100)
    createTime = models.DateTimeField(auto_now_add=True)
    orderId = models.CharField(max_length=32)
    status = models.IntegerField(default=0)  # 当前订单状态
    class Meta:
        db_table = 'axf_order'


# 订单详情
class OrderDetail(models.Model):
    order = models.ForeignKey(Order)
    goodsImg = models.CharField(max_length=100)
    goodsName = models.CharField(max_length=50)
    price = models.DecimalField(max_digits=8,decimal_places=2)
    num = models.IntegerField(default=1)
    total = models.DecimalField(max_digits=8,decimal_places=2)
    class Meta:
        db_table = 'axf_orderdetail'