from django.contrib import messages
from django.shortcuts import render,HttpResponse,redirect,reverse
from django.conf import settings
import os,random,string,uuid,hashlib
from PIL import Image

# 生成随机图片名称的方法
def random_name(suffix):
    """
    返回新的图片名称
    :param suffix:后缀
    :return:返回新的图片名称
    """
    u = uuid.uuid4()
    Str = str(u).encode('utf-8')
    md5 = hashlib.md5()
    md5.update(Str)
    name = md5.hexdigest()
    return name+'.'+suffix


# 图片缩放
def img_zoom(path,prefix='s_',width=100,height=100):
    """
    进行图片的缩放处理
    :param path: 图片路径
    :param prefix: 缩放前缀
    :param width: 缩放宽度
    :param height: 缩放高度
    :return: None
    """
    # 打开图片
    img = Image.open(path)
    img.thumbnail((width,height))
    # 拆分路径和名称
    pathTuple = os.path.split(path)
    newPath = os.path.join(pathTuple[0],prefix+pathTuple[1])
    img.save(newPath)

def upload(req):
    if req.method == 'POST':
        # 获取上传文件对象
        f = req.FILES.get('file')
        # 获取后缀
        suffix = f.name.split('.')[-1]
        # 判断文件类型是否允许上传
        if suffix not in settings.ALLOWED_EXTENSIONS:
            messages.error(req,'请上传正确的文件类型')
            return redirect(reverse('App:upload'))
        # 生成文件名称
        newName = random_name(suffix)
        print(newName)
        # 配置文件存储路径
        try:
            filePath = os.path.join(settings.MEDIA_ROOT,newName)
            # print(filePath)
            # 进行文件上传

            with open(filePath,'wb') as fp:
                # 判断何种方式写入
                if f.multiple_chunks():
                    for img in f.chunks():
                        fp.write(img)
                else:
                    fp.write(f.read())
        except:
            messages.error('服务繁忙，稍后再试')
            return redirect(reverse('App:upload'))
        else:
            img_zoom(filePath)
            messages.success(req,'上传成功')
        # 进行缩放处理

    return render(req, 'upload/upload_img.html')



"""
# 文件上传
# 完成了简单的上传
def upload(req):
    if req.method == 'POST':
        # 获取上传文件对象
        f = req.FILES.get('file')
        # 配置文件存储路径
        filePath = os.path.join(settings.MEDIA_ROOT,f.name)
        # print(filePath)
        # 进行文件上传
        with open(filePath,'wb') as fp:
            # 判断何种方式写入
            if f.multiple_chunks():
                for img in f.chunks():
                    fp.write(img)
            else:
                fp.write(f.read())
    return render(req, 'upload/upload_img.html')
"""




