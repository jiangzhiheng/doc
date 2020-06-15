from django.contrib import admin

# Register your models here.
from .models import User,Posts
# 配置富文本显示的站点配置
@admin.register(Posts)
class PostsAdmin(admin.ModelAdmin):
    list_display = ['title','article']


class UserAdmin(admin.ModelAdmin):
    list_display = ['pk','username','first_name','last_name','email']
    # 过滤字段
    list_filter = ['username']
    # 搜索字段
    search_fields = ['username']
    # 分页
    list_per_page = 3
admin.site.register(User,UserAdmin)





