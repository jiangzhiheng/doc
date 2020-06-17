from django.shortcuts import render,HttpResponse,redirect,reverse
from App.models import User,Order,OrderDetail
from django.contrib.auth.decorators import login_required
import time

# 订单展示页面
@login_required(login_url='/login/')
def order(req):
    # 把所有选中的商品在页面展示出来
    cartData = req.user.car_set.filter(isChoose=True)
    money = 0  # 当前选中购物车商品的总价格
    for obj in cartData:
        if obj.isChoose:
            money += eval(obj.goods.price) * obj.num
    # 查询当前用户的默认地址
    address = req.user.address_set.filter(state=True).first()

    return render(req,'order/order.html',{'cartData':cartData,'money':'%.2f'%money,'address':address})


# 处理订单功能的视图函数
def gererateOrder(req):
    if req.method == 'POST':
        # 获取用户的留言
        message = req.POST.get('message')
        # 保存生成订单
        orderObj = Order(user=req.user,address=req.user.address_set.filter(state=True).first(),money=req.POST.get('money'),message=message,orderId=time.strftime('%y%m%d%H%M%s'))
        orderObj.save()
        # 保存订单详情
        # 获取购物车中购买的商品
        carData = req.user.car_set.filter(isChoose=True)
        for car in carData:
            # 将商品存入订单详情中
            OrderDetail(order=orderObj,goodsImg=car.goods.productimg,goodsName=car.goods.productname,price=car.goods.price,num=car.num,total=car.num*eval(car.goods.price)).save()
        # 正常应该跳转到订单详情里  但是没有页面 那就跳转到购物车中
        return redirect(reverse('App:cart'))
    return HttpResponse('请求错误')