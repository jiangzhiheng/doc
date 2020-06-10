from django.shortcuts import render,HttpResponse

# Create your views here.


def index(req):

    return render(req, 'main/index.html',{'username':req.session.get('username')})


from django.contrib.auth.hashers import make_password,check_password
def test_hash(req):
    password_hash = make_password('123456')
    print(check_password('123456',password_hash))
    return HttpResponse('测试hash加密')

















