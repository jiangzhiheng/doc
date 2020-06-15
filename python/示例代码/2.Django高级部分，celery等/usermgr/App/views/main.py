from django.core.paginator import Paginator
from django.shortcuts import render,HttpResponse
from App.models import User
# Create your views here.

# 首页视图函数 显示用户数据
def index(req):
    # 查询所有用户数据
    data = User.objects.all()
    pag = Paginator(data,2)
    # 判断接收页码的值是否正确
    try:
        nowPage = int(req.GET.get('page',1))
    except:
        nowPage = 1
    # 判断页码是否大于最大页码数,大于则为最大页码
    if nowPage >= pag.num_pages:
        nowPage = pag.num_pages
    print(pag.num_pages)
    # 创建page对象
    page = pag.page(nowPage)
    return render(req,'main/index.html',{'data':page})


import random
# 测试中间件遇到视图函数bug
def mybug(req):
    v = 1/random.randrange(3)
    return HttpResponse('测试mybug:{}'.format(v))


import time
def rich_text(req):
    # time.sleep(5)
    return render(req,'main/rich_text.html')





# 测试celery
from App.task import task1,task2

def celery(req):
    task2.delay(3) # 添加到celery中执行 不会阻塞
    return HttpResponse('测试celery')




