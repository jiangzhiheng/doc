from django.shortcuts import render,HttpResponse,redirect,reverse
from App.models import User  # 导入User模型类
from django.contrib.auth import authenticate,login,logout
from django.contrib.auth.decorators import login_required


# 我的模板的渲染
def mine(req):
    return render(req,'mine/mine.html')


# 注册
# 自己完成登录和注册的js/jq的验证
"""
验证步骤
获取用户名 密码 确认密码 邮箱的值（获取节点）
使用正则验证用户名 邮箱密码 格式是否正确 以及验证密码和确认密码是否正确
都格式正确则使用ajax 验证用户名和邮箱在数据库中是否存在 如果不存在则进行注册功能的操作
"""
def register(req):
    if req.method == 'POST':
        username = req.POST.get('username')
        userpass = req.POST.get('password')
        email = req.POST.get('email')
        # 正常来说 这个位置还要使用python正则验证（防止别人直接调用我们的接口  过滤掉js的验证 直接进行存储 这样有问题）
        User.objects.create_user(username,email,userpass).save()
        return redirect(reverse('App:login'))  # 如果没有问题直接重定向到登录模板
    return render(req,'mine/register.html')


# 登录
def Login(req):
    if req.method == 'POST':
        username = req.POST.get('username')
        userpass = req.POST.get('password')
        # 正常来说 这个位置还要使用python正则验证（防止别人直接调用我们的接口  过滤掉js的验证 直接进行存储 这样有问题）
        u = authenticate(username=username,password=userpass)
        if u:
            login(req,u)
            return redirect(reverse('App:mine'))
        return HttpResponse('请输入正确的用户名或密码')

    return render(req,'mine/login.html')


# 退出登录
def Logout(req):
    logout(req)
    return redirect(reverse('App:mine'))
