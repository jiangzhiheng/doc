from django.utils.deprecation import MiddlewareMixin
from django.shortcuts import HttpResponse,redirect,reverse

class MyMiddle(MiddlewareMixin):

    def process_request(self,request):
        # print(request.method)
        # print(request.GET.get('page'))
        # 黑名单功能 拿到客户端IP地址，进行数据查询 如果存在则禁止访问
        # if request.META['REMOTE_ADDR'] == '127.0.0.1':
        #     return HttpResponse('目前繁忙')
        pass

    def process_exception(self,request,exception):
        print(exception)
        return redirect(reverse('App:index'))