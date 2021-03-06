"""
Django settings for usermgr project.

Generated by 'django-admin startproject' using Django 1.11.4.

For more information on this file, see
https://docs.djangoproject.com/en/1.11/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.11/ref/settings/
"""

import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.11/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = ')y%%9fw_%#n+vfl$_$$a$$(r^yt9)z*d@95dos$akgrca(wi+g'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['*']


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'App',
    'bootstrap3',
    'tinymce',
    'djcelery',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'middleware.myApp.myMiddle.MyMiddle', # 添加自定义中间件

]

ROOT_URLCONF = 'usermgr.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR,'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'usermgr.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.11/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'usermgr',
        'USER': 'root',
        'PASSWORD': '123456',
        'HOST': '192.168.1.129',
        'PORT': '3306',
    }
}


# Password validation
# https://docs.djangoproject.com/en/1.11/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/1.11/topics/i18n/

LANGUAGE_CODE = 'zh-Hans'
TIME_ZONE = 'Asia/Shanghai'

USE_I18N = True

USE_L10N = True

USE_TZ = True



# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.11/howto/static-files/

STATIC_URL = '/static/'
STATICFILES_DIRS = [
    os.path.join(BASE_DIR,'static'),
]

# 文件上传存储路径
MEDIA_ROOT = os.path.join(BASE_DIR,'static/upload')

# 配置允许上传的文件类型
ALLOWED_EXTENSIONS = ['jpg','git','png','jpeg']



# 缓存配置
# 配置在数据库中
CACHES = {
    'default':{
        # 缓存位置
        'BACKEND':'django.core.cache.backends.db.DatabaseCache',
        # 缓存的表名
        'LOCATION':'my_cache_table',
        # 缓存最多条数
        'OPTIONS':{
            'MAX_ENTRIES':10,
        },
        # 前缀
        'KEY_PREFIX':'cache',
    }
}



# 配置发送邮件所需的配置
EMAIL_HOST = 'smtp.qq.com'
EMAIL_HOST_PASSWORD = ''
EMAIL_HOST_USER = '1689991551@qq.com'


# 全局设置login_require
LOGIN_URL='/login/'

# 更改自定义模型类
AUTH_USER_MODEL = 'App.User'

AUTHENTICATION_BACKENDS=(
    'App.auth.MyBackend',
)

# 添加富文本编辑器
TINYMCE_DEFAULT_CONFIG = { 'theme': 'advanced', 'width': 600, 'height': 400, }



"""

# 配置celery的代码
import djcelery
djcelery.setup_loader()
BROKER_URL = 'redis://192.168.1.129:6379/0'  # 选择0库,redis://:密码@host:port/0

# 导入任务task
CELERY_IMPORTS = {'App.task'}

# 定时任务
from datetime import timedelta
#
CELERYBEAT_SCHEDULE = {
    'schedule-test':{
        'task':'App.task.task3', # App下的task.py里面的task函数
        'schedule':timedelta(seconds=3),
        'args':(4,)
    }
}
"""

