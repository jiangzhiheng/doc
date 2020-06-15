from django.contrib import messages
from django.shortcuts import render, HttpResponse,redirect,reverse
# from django.contrib.auth.models import User  # 系统内置的模型
from App.models import User # 自定义的用户模型
from django.conf import settings
from django.contrib.auth import authenticate,login as Login,logout as Logout
from django.contrib.auth.decorators import login_required # 必须登录才能访问


# 注册功能

# 注册功能

def register(req):
    if req.method == 'POST':
        try:
            # 获取传递过来的数据
            username = req.POST.get('username')
            userpass = req.POST.get('userpass')
            email = req.POST.get('email')
            # 将用户数据保存在数据库中
            u = User.objects.create_user(username, email, userpass,phone='17688709485')
            u.save()
            # 配置发送邮件进行激活
            # u.email_user('账户激活', '', settings.EMAIL_HOST_USER, html_message="<a href="">激活</a>")
            # messages.success(req, '注册成功,激活邮件已发送，请前往激活')
            return redirect(reverse("App:login"))
        except:
            messages.error(req,'服务器繁忙，稍后再试')
    return render(req, 'user/register.html')

# 用户认证
def login(req):
    if req.method == 'POST':
        # 获取传递过来的数据
        username = req.POST.get('username')
        userpass = req.POST.get('userpass')
        u = authenticate(username=username,password=userpass)
        # print(u)
        if not u:
            messages.error(req,'当前用户登陆失败，请检查用户名密码或激活状态')
            return redirect(reverse('App:login'))
        # 处理登陆
        Login(req,u)
        messages.success(req,'登陆成功')
        return redirect(reverse('App:index'))
    return render(req,'user/login.html')




# 修改密码
def update_password(req):
    if req.method == 'POST':
        # 获取传递过来的数据
        username = req.POST.get('username')
        userpass = req.POST.get('userpass')
        newuserpass = req.POST.get('newuserpass')
        u = authenticate(username=username, password=userpass)
        if not u:
            messages.error(req,'当前用户认证失败')
            return redirect(reverse('App:update_password'))
        u.set_password(newuserpass)
        u.save()
        messages.success(req,'密码修改成功！')
        return redirect(reverse('App:login'))
    return render(req,'user/update_password.html')


# 退出登陆
def logout(req):
    Logout(req)
    messages.success(req,'退出成功')
    return redirect(reverse('App:index'))

# 在视图函数中获取登录用户的数据
# 必须登陆才能访问该视图
@login_required(login_url='/login/')
def test(req):
    if req.user.is_authenticated():
        print(req.user.username)
    return HttpResponse('测试在视图函数中获取登陆对象')

