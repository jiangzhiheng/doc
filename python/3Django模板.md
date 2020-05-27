一、概述

1. 模板用于向用户响应和展示结果的`HTML`页面

2. 模板有两部分组成

   - `HTML`代码
   - 逻辑控制代码

3. 作用：

   快速生成`HTML`页面

4. 优点

   - 模板的设计实现了业务逻辑和显示内容的分离
   - 试图可以使用任何模板

二、模板的渲染

1. `render`

   导入：

   ```python
   from django.shortcuts import render,HttpResponse
   ```

   参数：

   - `request`：请求对象
   - `template_name`：模板名称
   - `context`：模板渲染的内容（传递参数）

   实例

   ```python
   def index(req):
       # return HttpResponse('index')
       return render(req,'index.html', {'name': 'martin', 'facevalue': '很高'})
   ```

   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <title>Title</title>
   </head>
   <body>
   <h4>首页</h4>
   <dl>
       <dt>名字</dt>
       <dd>{{ name }}</dd>
       <dt>颜值</dt>
       <dd>{{ facevalue }}</dd>
   </dl>
   </body>
   </html>
   ```

2. `loader`渲染模板

   导入

   ```python
   from django.shortcuts import loader
   ```

   实例

   ```python
   def index(req):
       # 获取渲染模板
       tem = loader.get_template('index.html')
       # 渲染传参
       res = tem.render({'name': 'martin', 'facevalue': '很高'})
       return HttpResponse(res)
   ```

三、模板中的变量

1. 格式

   `{{ 变量名 }}`

   视图向模板传递的数据，变量名称就是字典中的`key`，值就是`key`对应的`value`值

   如果模板渲染的变量不存在，则插入空白字符，不会报错

   模板中使用语法：

   - 字典查询
   - 属性或方法
   - 数字索引

2. 系统变量

   - `{{ request.user }}`：获取当前用户

     ```html
     <h4>获取当前的用户：{{ request.user }}</h4>
     <h4>判断当前是否登陆状态(login)：{{ request.user.is_authenticated }}</h4>
     ```

   - 获取当前的网址：`{{ request.path }}`

   - 获取当前`get`参数：`{{ request.GET.urlencode }}`

   - 组合使用：

     `<h5><a href="{{ request.path }}?{{ request.GET.urlcode }}">当前网址参数</a></h5>`

四、模板中标签

1. 格式

   `{% 标签名称 %}`

2. 作用：

   - 在输出中创建文本
   - 控制逻辑和循环

3. `if/elif/else/endif`标签

   - 语法格式

     ```django
     {% if ... %}
     ...
     {% elif ... %}
     ...
     {% else %}
     ...
     {% endif %}
     ```

     可用的运算符

     `> < >= <= == ! and or not in not in`

     实例

     ```django
     <h3>if 分支的使用</h3>
     {% if grade > 80 %}
         <h5>成绩大于80</h5>
     {% elif grade > 70 %}
         <h5>成绩大于70</h5>
     {% else %}
         <h5>成绩小于等于70</h5>
     {% endif %}
     ```

4. `for`标签

   语法格式

   ```django
   {% for xx in xx %}
   ...
   {% endfor %}
   ```

   实例

   ```django
   <ul>
       {% for i in List %}
           <li>{{ i }}</li>
       {% endfor %}
   </ul>
   ```

   迭代可选参数：`reversed`反向迭代

   注意：

   - 反向迭代只能针对列表，不能对字段进行反向迭代
   - 搭配`empty`使用，不可以搭配`else`使用（在`python`搭配的是`else`），只有当迭代不存在的变量的时候才会执行`empty`

5. 迭代字典的实例

   ```django
   <h5>迭代字典</h5>
   <ul>
       {% for k,v in info.items %}
           <li>{{ k }}: {{ v }}</li>
       {% endfor %}
   </ul>
   ```

6. 获取`for`迭代的状态

   |         变量          |             描述             |
   | :-------------------: | :--------------------------: |
   |   `forloop.counter`   |      迭代的索引从1开始       |
   |   `forloop.counter`   |      迭代的索引从0开始       |
   | `forloop.revcounter`  |  迭代索引从最大长度递减到1   |
   | `forloop.revcounter0` |  迭代索引从最大长度递减到0   |
   |    `forloop.first`    |       是否为第一次迭代       |
   |    `forloop.last`     |      是否为最后一次迭代      |
   | `forloop.parentloop`  | 获取迭代嵌套的上一层迭代对象 |

7. 注释

   - 单行注释：

     `{# 注释的内容 #}`

   - 多行注释：

     `{% comment %}`

     `...`

     `{% endcomment %}`

8. `ifequal`标签

   说明：判断两个值是否相等，相等则为`True`

   实例：

   ```django
   <h5>ifequal标签</h5>
   {% ifequal grade 80 %}
       相等
   {% else %}
       不相等
   {% endifequal %}
   ```

9. `ifnotequal`标签

   说明：判断两个值是否不相等，不相等则为`True`

五、模板的导入

1. 格式

   ```django
   {% include 路径/模板名称.html %}
   ```

   实例：

   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <title>Title</title>
   </head>
   <body>
   {% include 'common/header.html' %}
   {% include 'common/footer.html' %}
   </body>
   </html>
   ```

   `common/header`

   ```html
   <header>
       <nav>导航</nav>
   </header>
   ```

   `common/footer`

   ```html
   <footer>底部栏</footer>
   ```

   注意：使用`include`的时候会将导入页面里的所有代码都引入到当前页面，所以要将有用的代码部分放入导入的文件中。

2. 

