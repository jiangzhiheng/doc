from django.contrib import messages
from django.core.mail import EmailMultiAlternatives
from django.db.models import Q
from django.shortcuts import render,HttpResponse,reverse,redirect
from App.models import User
from django.template import loader
from django.conf import settings

def register(req):

    # 判断请求的方式
    if req.method == 'POST':
        # 进行数据处理
        u = User.objects.filter(Q(username=req.POST.get('username'))|Q(email = req.POST.get('email')))
        if u.exists():
            messages.error(req, '用户名或邮箱地址已存在，请重新输入')
        else:
            try:
                u = User()
                u.username = req.POST.get('username')
                u.password = req.POST.get('userpass')
                u.email = req.POST.get('email')
                u.save()
            except:
                messages.error(req,'服务器繁忙，请稍后再试')
            else:
                # 进行token生成 发送邮件激活码
                token = u.generate_token()
                # 生成激活链接地址
                href = 'http://'+req.get_host()+reverse('App:active',args=[token])
                # 发送邮件处理
                html_content = loader.get_template('user/active.html').render({'href':href,'username':u.username})
                subject, from_email, to = '邮件激活', settings.EMAIL_HOST_USER, u.email
                text_content = ''
                html_content = html_content
                msg = EmailMultiAlternatives(subject, text_content, from_email, [to])
                msg.attach_alternative(html_content, "text/html")
                msg.send()
                messages.success(req,'注册成功,已发送激活邮件，请前往激活')
    # return HttpResponse('注册')
    return render(req, 'user/register.html')



# 激活的视图函数
def active(req,token):
    if User.check_token(token):
        messages.success(req,'账户激活成功！请前往登陆')
        return redirect(reverse('App:login'))
    else:
        messages.error(req,'账户激活失败，请重新激活')
    return redirect(reverse('App:register'))


# 登陆视图函数

def login(req):
    if req.method == 'POST':
        query_u = User.objects.filter(Q(username=req.POST.get('username'))|Q(email = req.POST.get('email')))
        u = query_u.first()
        if not query_u.exists():
            # 验证用户是否存在
            messages.error(req,'请输入正确的用户名')
            return render(req, 'user/login.html')
        # 验证密码
        elif not u.check_password(req.POST.get('userpass')):
            messages.error(req,'请输入正确的用户名或密码')
        # 验证激活状态
        elif not u.confirm:
            messages.error(req,'账户未激活')
        else:
            # 证明用户存在，密码正确，激活状态
            # 处理当前用户的状态保持
            req.session['uid'] = u.id
            req.session['username'] = u.username
            messages.success(req,'登陆成功')
            return redirect(reverse('App:index'))
    return render(req,'user/login.html')

