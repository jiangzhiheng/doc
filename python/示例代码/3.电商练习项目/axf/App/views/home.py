from django.shortcuts import render
from App.models import Wheel,Nav,MustBuy,Shop,MainShow

# Create your views here.
def index(req):
    # 先获取轮播图片的数据
    wheel = Wheel.objects.all()
    # nav导航的数据
    nav = Nav.objects.all()
    # 必买品
    mustBuy = MustBuy.objects.all()
    # 主要卖品数据查询
    mainShow = MainShow.objects.all()
    return render(req,'home/home.html',{'wheelsList':wheel,'navList':nav,'mustbuyList':mustBuy,'mainList':mainShow})