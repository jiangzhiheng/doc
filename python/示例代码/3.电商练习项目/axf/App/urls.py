from django.conf.urls import url
from App.views import home,market,mine,order,cart
urlpatterns = [
    # home路由地址
    url(r'^home/$',home.index,name='home'),
    url(r'^$',home.index,name='index'),
    # 闪送超市路由地址
    url(r'^market/$',market.market,name='market'),
    url(r'^market/(\d+)/(\d+)/(\d+)/$',market.market,name='market2'),
    # 我的 路由地址
    url(r'^mine/$',mine.mine,name='mine'),
    # 登录注册
    url(r'^login/$',mine.Login,name='login'),
    url(r'^register/$',mine.register,name='register'),
    url(r'^logout/$',mine.Logout,name='logout'),
    # 购物商品数量的操作的路由地址
    url(r'^doCar/$',cart.doCar,name='doCar'),
    url(r'^cart/$',cart.cart,name='cart'),
    url(r'^doOrder/$',cart.doOrder,name='doOrder'),
    # 以下为订单路由地址
    url(r'^order/$',order.order,name='order'),
    url(r'^gererateOrder/$',order.gererateOrder,name='gererateOrder'),
]
