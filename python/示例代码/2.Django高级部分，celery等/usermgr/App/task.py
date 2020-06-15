import time
from celery import task

# 任务
# 无参数
@task
def task1():
    print('耗时5秒钟的任务')
    time.sleep(5)
    print('耗时5秒钟的任务')

# 传递参数
@task
def task2(i):
    print('耗时任务',i)
    time.sleep(5)
    print('耗时任务',i)

# 定时任务
# 传递参数
@task
def task3(i):
    print('耗时任务',i)
