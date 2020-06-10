from django.conf.urls import url,include
from App.views import main
from App.views import user
urlpatterns = [
    url(r'^$', main.index, name='index'),
    url(r'^test_hash/$', main.test_hash, name='test_hash'),

    # 以下路由地址为注册登陆
    url(r'^register/$',user.register,name='register'),
    url(r'^active/(\w+)/$', user.active, name='active'),
    url(r'^login/$', user.login, name='login'),

]