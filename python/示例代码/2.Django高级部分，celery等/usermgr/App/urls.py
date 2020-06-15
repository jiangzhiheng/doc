from django.conf.urls import url,include
from App.views import main
from App.views import user
from App.views import upload


urlpatterns = [
    url(r'^$', main.index, name='index'),

    url(r'^register/$', user.register, name='register'),
    # url(r'^active/(\w+)/$', user.active, name='active'),
    url(r'^login/$', user.login, name='login'),
    url(r'^logout/$', user.logout, name='logout'),
    url(r'^update_password/$', user.update_password, name='update_password'),
    url(r'^test/$', user.test, name='test'),

    url(r'^upload/$', upload.upload, name='upload'),
    url(r'^mybug/$', main.mybug, name='mybug'),

    url(r'^rich_text/$', main.rich_text, name='rich_text'),
    url(r'^celery/$', main.celery, name='celery'),

]