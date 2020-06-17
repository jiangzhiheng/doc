from django.http import JsonResponse
from django.shortcuts import render
from App.models import Car,Goods
from django.contrib.auth.decorators import login_required


# 购物车模板的展示
@login_required(login_url='/login/')
def cart(req):
    # 查询当前登录的用户在购车中的所有购物车对象
    cartData = req.user.car_set.all()
    money = 0  # 当前选中购物车商品的总价格
    for obj in cartData:
        if obj.isChoose:
            money += eval(obj.goods.price)*obj.num
    return render(req,'cart/cart.html',{'cartData':cartData,'money':'%.2f'%money})



# 购物车商品的+-操作
def doCar(req):
    # 判断当前的请求是否登录
    if not req.user.is_authenticated:
        return JsonResponse({'code':500})  # 如果code值为500 证明没登录
    # 接受ajax请求传递过来的 state和goodsid （state代表是添加还是减少 goodsid为商品的自增ID）
    state = int(req.GET.get('state'))
    goodsid = int(req.GET.get('goodsId'))
    # 获取到当前登录的user对象
    user = req.user
    # 查询商品对象
    goodsObj = Goods.objects.filter(id=goodsid).first()
    # 查询该商品在购物中的对象
    cartObj = Car.objects.filter(goods=goodsObj)
    # 初始化数量商品在购物车中的数量num
    totalnum = 0
    # 进行商品数量的+-操作
    # 0为减1
    if state == 0:
        # 判断该商品是否存在购物车中  不在则不进行任何操作
        if cartObj.exists():
            num = cartObj.first().num  # 取出该商品在购物车中的数量
            totalnum = num - 1  # 商品数量减1
            if totalnum > 0:  # 判断商品-1后的数量是否大于0
                cartObj.update(num=totalnum)  # 大于则进行存储
            else:
                cartObj.delete()  # 不大于0 证明为0 则进行删除

    # 1为加1
    if state == 1:
        # 判断该商品是否存在于购物车  存在则进行+1操作 不存在则进行添加操作
        if cartObj.exists():
            num = cartObj.first().num  # 取出该商品在购物车中的数量
            totalnum = num + 1  # 商品数量减1
            # 判断购物车商品数量是否大于库存量
            if totalnum > int(goodsObj.storenums):
                # 大于只能为库存量
                totalnum = int(goodsObj.storenums)
            # 将该商品在购物车中的数量进行更改
            cartObj.update(num=totalnum)
        else:
            # 添加到购物车表中
            Car(goods=goodsObj,user=user).save()
            totalnum = 1 # 把购物车中当前商品的数量设置为1

    # 2为更改选中和取消选中的状态
    Bool = True
    if state == 2:
        chooseObj = cartObj.first()  # 取出当前商品在购车的对象
        Bool = not chooseObj.isChoose # 对商品的状态进行取反 选中为取消 取消为选中
        chooseObj.isChoose = Bool
        chooseObj.save()  # 保存到数据库中
        totalnum = chooseObj.num

    # 更改钱
    money = 0  # 总金额初始化为0
    # 获取到当前用户所有选中的商品的对象
    carChooseObj = user.car_set.filter(isChoose=True)
    if carChooseObj.exists():
        for obj in carChooseObj:
            money += eval(obj.goods.price) * obj.num


    return JsonResponse({'code':200,'totalnum':totalnum,'Bool':Bool,'money':'%.2f'%money})


# 处理选好了下订单的选择的操作
def doOrder(req):
    # 判断当前的请求是否登录
    code = 200
    Bool = False
    if not req.user.is_authenticated:
        code = 500  # 如果code值为500 证明没登录
    # 查询该用户是否有选中商品
    Bool = req.user.car_set.filter(isChoose=True).exists()
    return JsonResponse({'code':code,'Bool':Bool})  # 如果code值为500 证明没登录
