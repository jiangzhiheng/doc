from django.shortcuts import render,HttpResponse
from App.models import FoodTypes,Goods  # 导入商品类别与商品模型


# 闪送超市
def market(req,categoryid=104749,childcid=0,orderby=0):
    # 查询超市左侧的类别名称的显示
    foodTypes = FoodTypes.objects.all()

    goodsData = Goods.objects.filter(categoryid=categoryid)
    # 查询子类别对应的数据
    if int(childcid):
        goodsData = goodsData.filter(childcid=childcid)

    # 处理商品的排序
    orderby = int(orderby)
    if orderby == 1:
        # 按照销量排序
        goodsData = goodsData.order_by('-productnum')
    elif orderby == 2:
        goodsData = goodsData.order_by('price')
    elif orderby == 3:
        goodsData = goodsData.order_by('-price')

    # 查询大类别下的所有子类别
    childtypenames = FoodTypes.objects.filter(typeid=categoryid).first().childtypenames
    childTypeList = childtypenames.split('#')
    typeList = []  # 存储所有子类别名称和id的数据
    for child in childTypeList:
        typeList.append(child.split(':'))
    return render(req,'market/market.html',{'leftSlider':foodTypes,'productList':goodsData,'typeList':typeList,'categoryid':categoryid,'childcid':childcid})


"""
全部分类:0#酸奶乳酸菌:103537#牛奶豆浆:103538#面包蛋糕:103540
"""
"""
小伙伴 完成登录注册功能
"""
