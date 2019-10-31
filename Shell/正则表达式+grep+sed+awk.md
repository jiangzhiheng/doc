### **正则表达式**

1. 概述

   正则表达式（Regular Expression）是一种字符模式，用于在查找过程中匹配指定的字符。

   在大多数程序里，正则表达式都被置于两个斜杠之间；例如`/l[oO]ve/`就是由正则斜杠界定的正则表达式

   - 匹配数字 ： `^[0-9]+$`
   - 匹配Mail：`[a-z0-9_]+@[a-z0-9]+\.[a-z]+`
   - 匹配IP：`[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}`

2. 元字符

   定义：元字符是这样一类字符，它们表达的是不同于字面本身的含义

   - 正则表达式元字符

     1. 基本正则表达式元字符

        |   元字符   |           功能           |               示例                |
        | :--------: | :----------------------: | :-------------------------------: |
        |     ^      |        行首定位符        |                                   |
        |     $      |        行尾定位符        |                                   |
        |     .      |       匹配单个字符       |                                   |
        |     *      |    匹配前导符0到多次     |                                   |
        |     .*     |       任意多个字符       |                                   |
        |     []     | 匹配指定范围内的一个字符 |                                   |
        |   [ - ]    | 匹配指定范围内的一个字符 |                                   |
        |     \      |          转义符          |                                   |
        |    \\<     |        词首定位符        |                                   |
        |    \\>     |        词尾定位符        |                                   |
        |  \\(..\\)  | 匹配稍后使用的字符的标签 | :3,9 s/\\(.*\\)/#\1/   注释3到9行 |
        |  x\\{m\\}  |       字符x重复m次       |                                   |
        | x\\{m,\\}  |     字符x出现m次以上     |                                   |
        | x\\{m,n\\} |    字符x出现m次到n次     |                                   |

     2. 扩展正则表达式元字符

        |    元字符    |          功能          | 示例 |
        | :----------: | :--------------------: | :--: |
        |      +       | 匹配一个或多个前导字符 |      |
        |      ？      | 匹配0个或一个前导字符  |      |
        |     a\|b     |       匹配a或者b       |      |
        |      ()      |         组字符         |      |
        | (..)(..)\1\2 |      标签匹配字符      |      |
        |     x{m}     |      字符x重复m次      |      |
        |    x{m,}     |    字符x重复至少m次    |      |
        |    x{m,n}    |    字符x重复m到n次     |      |

     3. `POSIX`字符类

        | 表达式      | 功能                             | 示例              |
        | ----------- | -------------------------------- | ----------------- |
        | `[:alnum:]` | 字母与数字字符                   | `[[:alnum:]]+`    |
        | `[:alpha:]` | 字母字符（包括大小写）           |                   |
        | `[:blank:]` | 空格与制表符                     |                   |
        | `[:digit:]` | 数字                             | `[[:digit:]]?`    |
        | `[:lower:]` | 小写字母                         | `[[:lower:]]{5,}` |
        | `[:upper:]` | 大写字母                         |                   |
        | `[:punct:]` | 标点符号                         |                   |
        | `[:space:]` | 包括换行符，回车等在内的所有空白 | `[[:space:]]+`    |

3. 正则表达式示例

   /^$/   空行

   /^#/	注释行

   .....

### **`grep`家族**

- `grep`：在文件中全局查找指定的正则表达式，并打印所有包含该表达式的行
- `egrep`：扩展的`egrep`，支持更多的表达式元字符
- `fgrep`：固定`grep(fixed grep)`,有时也被称为快速`(fast grep)`，它按字面意思解释所有的字符

1. `grep`命令格式

   `grep [options]  PATTERN filename filename....`

   `grep`程序的输入可以来自标准输入或管道，而不仅仅是文件

2. `grep`使用的元字符

   `grep`  :  使用基本的元字符  ^  $  .   *   [ ]  \[^]  \\<  \\>   \\(\\)   \\{\\}  \\+  \\|  

   `egrep` :  使用扩展的元字符  ? +  { }  |   ()

   \w  :    所有字母与数字，称为字符`[a-zA-Z0-9]` 

   \W  :   所有字母与数字之外的字符，称为非字符

   \b    :   词边界   `  '\\<love\\> '     '\blove\b'  `

3. `grep`示例

   `grep -E  或egrep`

4. `grep`选项

   - -i     忽略大小写

   - -q    静默显示

   - -v    反向查找，只显示不匹配的行

   - -c    --count  显示成功匹配的行

     `grep  --help | grep  '\-v'`

   - -r     递归整个目录

   - -o     只显示匹配道德内容

     `   egrep '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'  /etc/hosts `  匹配IP地址
     
     `egrep '([0-9]{1,3}).{3}\.[0-9]{1,3}'  /etc/hosts`    匹配IP地址

### **`Sed`流编辑器**

1. `sed`工作流程

   `sed`是一种在线的，非交互式的编辑器，它一次处理一行内容，处理时，把当前处理的存储在临时缓冲区中，称为"模式空间(Pattern space)"，接着用`sed`命令处理缓冲区中的内容，处理完成后，把缓冲区中的内容送往屏幕，接着处理下一行，直到文件末尾。文件内容并没有改变，此非食用重定向存储输出。

2. 命令格式

   `sed [options]  'command'   file(s)`

   `sed [options]  -f scriptsfile file(s)`

   Tips :  `sed`和`grep` 不一样，不管是否找到指定的格式，它的退出状态都是0

3.  支持正则表达式

   - 使用基本元字符集
   - 使用扩展的元字符集  `sed -r`

4. `sed`基本用法

   `# sed -r 's/root/alice/gi' /etc/passwd     g代表全局，i忽略大小写`  查找替换 

   .......

5. `sed`扩展

   1. 地址

      地址用于决定对哪些进行编辑。地址形式可以是数字，正则表达式或二者的集合，如果没指定则默认处理所有行

      `sed -r 'd' /etc/passwd`

      `sed -r '3d' /etc/passwd`  

      `sed -r '1,3d' /etc/passwd`

      `sed -r '/root/d' /etc/passwd`

      `sed -r '/root/,5d' /etc/passwd` 从匹配到的行开始删掉5行

      `sed -r 's/root/alice/g' /etc/passwd`

      `sed -r '/root/!d' /etc/passwd`

      `sed -r '1~2d' /etc/passwd`  删掉所有的奇数行

      `sed -r '0~2d' /etc/passwd`  删掉所有的偶数行

   2. `sed`命令

      `sed`命令告诉`sed`对指定行进行何种操作，包括打印，删除，修改等

      | 命令 |                      功能                      |
      | :--: | :--------------------------------------------: |
      |  a   |            在当前行后添加一行或多行            |
      |  c   |       用新文本修改（替换）当前行中的文本       |
      |  d   |                     删除行                     |
      |  i   |              在当前行之前插入文本              |
      |  p   |                     打印行                     |
      |  !   |          对所选行以外的所有行应用命令          |
      |  s   | 用一个字符串替换另一个  g全局替换，i忽略大小写 |
      |  r   |                   从文件中读                   |
      |  w   |                  将行写入文件                  |

   3. `sed` 选项

      -e    允许多项编辑

      -f     指定`sed`脚本文件名

      -n	取消默认的输出

      -i     `inplace`，就地编辑，直接修改源文件

      -r	支持扩展元字符

6. `sed`命令示例

   删除命令：d

   - `sed -r '3d' /etc/passwd`     删除第三行
   - `sed -r '3{d;}' /etc/passwd`     删除第三行
   - `sed -r '3{d}' /etc/passwd`     删除第三行
   - `sed -r '$d' /etc/passwd`       删除最后一行

   替换命令：s

   - `sed -r 's/west/north/g' datafile`
   - `sed -r 's/[0-9][0-9]$/&.5/' datafile`  #&表示在查找串中匹配到的内容

   读文件命令：r

   - `sed -r '2r' /etc/hosts a.txt`   第二行的时候读入文件
   - `sed -r /2/r /etc/hosts a.txt`    匹配到带有2的行

   写文件命令：w   写入到新文件

   - `sed -r '/root/w /tmp/newfile'datafile`
   - `sed -r '3,$w /tmp/newfile' datafile`

   追加命令：a

   插入命令：i

   获取下一行命令：n

   暂存和去用命令：h	H	g	G(小写字母覆盖，大写字母追加)

   - `sed -r '1h;$G' /etc/hosts`     将第一行内容放到暂存空间，并追加到最后一行后面
   - `sed -r '1{h;d};$G' /etc/hosts`    将第一行内容移到暂存空间后删除，然后将暂存空间放到最后一行
   - `sed -r '1h;2,$g' /etc/hosts`    
   - `sed -r '1h;2,3H;$G' /etc/hosts`

   暂存空间和模式空间呼唤命令：x

   多重编辑选项：-e

7. `sed`常见操作

   - 删除配置文件中#号注释行

     `sed -ri '/^#/d' file.conf`

     `sed -ri '/^[ \t]*#/d' file.conf`   #号之前有空格或\t

   - 删除//注释的行

     `sed -ri '\#^[ \t]*//#d' file.conf`

   - 删除空行

     `sed -ri '/^[ \t]*$/d' file.conf`

   - 修改文件

     `sed -ri '$a\chroot_local_user=YES' /etc/vsftpd/vsftpd.conf`  最后一行追加`chroot_local_user=YES`

     `sed -ri '/^SELINUX=/cSELINUX=disable' /etc/selinu/config`     #找到以`SELINUX`开头的行，整行替换为`SELINUX=disable`

   - 给文件行添加注释

     `sed -r '2,6s/^/#/' a.txt`

     `sed -r '2,6s/(.*)/#\1/' a.txt`

     `sed -r '2,6s/.*/#&/' a.txt`

     `sed -r '2,6s/^#*/#/' a.txt`   将行首的0到多个#替换为一个#

   - `sed`中使用外部变量

     `var1=123456`

     `sed -ri '3a$var1' /etc/hosts `  第三行后追加`$var1`的内容

     `sed -ri '$a'"$var1" /etc/hosts`    最后一行追加变量中的内容


### **`awk`文本处理**

1. `awk`简介

   `awk`是一种编程语言，用于在Linux/Unix下对文本和数据进行处理。数据可以来自标准输入、一个或多个文件，或其他命令的输出。它支持用户自定义函数和动态正则表达式等先进功能，是Linux下一个强大编程工具。

   `awk`通过逐行扫描文件，从第一行到最后一行，寻找匹配的特定模式的行，并在这些行上进行你想要的操作。

2. `awk`的两种新式的语法格式

   `awk [options] 'commands' filenames`

   `awk [options] -f awk-script-file filenames`

   - options:

     -F  定义输入字段分隔符，默认的分隔符是空格或者\t制表符

   - command:

     `BEGIN{}`   行处理前

     `{}`			  行处理

     `END{}`	  行处理后

     `# awk 'BEGIN{print 1/2}{print "ok"}END{pring "-----"}' /etc/hosts`

     `# awk 'BEGIN{FS=":"}{print $1}' /etc/passwd`

     `# awk 'BEGIN{FS=":";OFS="---"}{print $1,$2}' /etc/passwd`  #FS输入分隔符，OFS输出分隔符

   - `awk`命令格式

     `awk 'pattern' filename`     

     `awk '{action}' filename`

     `awk 'pattern{action}' filename`

     `COMMAND |awk 'pattern{action}'`

3. `awk`工作原理

   `awk -F: '{print $1,$3}' /etc/passwd`

   1. `awk`使用一行作为输入，并将这一行赋值给内部变量$0,每一行也可称为一个记录，以换行符结束
   2. 然后行被：(默认为空格或制表符)分解成字段（或域），每个字段存储在已编号的变量中，从$1开始，最多100个字段
   3. `awk`如何知道用空格来分割字段呢？因为有一个内部变量`FS`来确定字段分隔符。初始时，`FS`赋为空格
   4. `awk`打印字段时，将已设置的方法使用print函数打印，`awk`在打印的字段间加上空格，因为$1,$3之间有一个逗号，逗号比较特殊，它映射为另一个内部变量，称为输出字段分隔符`OFS，OFS`默认为空格。
   5. `awk`输出之后，将从文件中获取另一行，并将其存在$0中，覆盖原来的内容，然后将新的字符串分割成字段并进行处理。

4. 记录与字段相关的内部变量

   - `$0`   `awk`变量$0保存当前记录的内容  `awk -F":" '{print $0}' /etc/passwd`

   - `NR`：  所有输入文件行号 `awk -F":" '{print NR,$0}' /etc/passwd /etc/hosts`   多个文件

   - `FNR`：  当前输入文件行号  `awk -F":" '{print FNR,$0}' /etc/passwd /etc/hosts`   多个文件

   - `NF`：保存记录的字段数    每一行按照分隔符有几个字段

   - `FS`：输入字段分隔符`field separator` 

   - `OFS`：输出字段分隔符

   - `RS`： 记录分隔符`record separator`  默认为换行符

   - `ORS`：输出记录分隔符

     `awk 'BEGIN{ORS=""}{print $0}' /etc/passwd`  将文件每一行合并为一行

5. 格式化输出

   - `print`函数

     `date | awk '{print "Month:"$2 "\nYear:" $NF}'`

     `awk -F":" '{print "username is " $1 "\tuid is "$3}' /etc/passwd`

   - `printf`函数

     `awk -F":" '{printf "%-15s %-10s %-15s\n",$1,$2,$3}' /etc/passwd`

     `awk -F":" '{printf "|%-15s|%-10s|%-15s|\n",$1,$2,$3}' /etc/passwd`

   - Tips

     `%s`字符类型

     `%d`数值类型

     `%f`浮点类型

     占15字符

     -表示左对齐，默认是右对齐

     `printf`默认不会在行尾自动换行，需要加\n

6. `awk`模式和动作

   任何`awk`语句都由模式和动作组成。模式部分决定动作语句何时触发事件。处理既对数据进行操作。如果省略模式部分，动作将时刻保持执行状态。模式可以是任何条件语句或复合语句或正则表达式。模式包括两个特殊字段BEGIN和END。使用BEGIN语句设置计数和打印头，BEGIN语句使用在任何文本浏览动作之前，之后文本浏览动作依据输入文本开始执行，END语句用来在`awk`完成文本浏览动作后打印输出文本总数和皆为状态

   模式可以是：

   - 正则表达式

     1. 匹配记录（整行）

        `awk '/^alice/' /etc/passwd`

        `awk '!/^alice/' /etc/passwd`

     2. 匹配字段：(~   !~)

        `awk -F":" '$1 ~ /^alice/' /etc/passwd`

        `awk -F":" '$NF !~ /bash$/' /etc/passwd`   匹配最后一列以bash结尾的行

   - 比较表达式

     比较表达式采用对文本进行比较，只有当条件为真，才执行指定的动作。比较表达式使用关系运算符，用于比较数字与字符串

     关系运算符：`<  <=   ==  !=  >=  >`

     `awk -F: '$NF == "/bin/bash"' /etc/passwd`

     `df -P |grep '/' |awk '$4>25000'`

   - 条件表达式

     `awk -F: '{if($3>300){print $3} else{print $1}}' /etc/passwd`

     `awk -F: '{if($3>300) {print $0}}' /etc/passwd`

   - 算术运算 ：`+ - * / %(取模) ^(幂2^3)`

     可以在模式中执行计算，`awk`都按浮点数方式执行算术运算

     `awk -F: '{if($3*10>500){print $0}}' /etc/passwd`

   - 逻辑操作符和复合模式

     `&&     ||    !`

     `awk -F: '$1~/root/ && $3<=15' /etc/passwd`

     `awk -F: '!($1~/root || $3<=15)' /etc/passwd`

   - 范围模式

     `awk '/Tom/,/Suzanne/' filename`

7. `awk`流程控制

   - 条件判断

     格式：{ if(表达式){语句1；语句2；......} }

     `awk -F: '{ if($3==0){print $1 " is administrator."} }' /etc/passwd`

     `awk -F: '{ if($3>0 && $3<1000){count++}} END{print count }' /etc/passwd`   //统计系统用户数

   - if...else语句

     `awk -F: '{ if($3==0){print $1} else{print $7} }' /etc/passwd`

     `awk -F: '{ if($3==0){count++}else{i++} }END{print"管理员个数： "count;print"系..用户数： "i}' /etc/passwd`

   - if...else if...else语句

   - 循环

     1. while

        `awk 'BEGIN{ i=1;while(i<=10){ print i;i++ } }'`

        `awk -F: '{i=1;while(i<=10){print $0; i++}}' /etc/passwd`  //每行打印10次

        `awk '{i=1;while(i<=NF){print $i;i++}}'  a.txt` //分别打印每行的每列

     2. for

        `awk 'BEGIN{ for(i=1;i<=5;i++){print i} }'`

        `awk '{for(i=1,i<=NF;i++){print $i}}' a.txt`   //分别打印每行的每列

8. `awk`数组

   1. 数组定义

      `awk -F: '{username[++i]=$1}END{print username[1]}' /etc/passwd`

      `awk -F: '{username[i++]=$1}END{print username[0]}' /etc/passwd`

   2. 数组遍历

      `awk -F: '{ username[j++]=$1 }END{ for(i in username){print i,username[i]} }' /etc/passwd`

      `awk -F: '{ username[++j]=$1 }END{ for(i in username){print i,username[i]} }' /etc/passwd`

   3. 示例

      - 统计当前系统中各shell的数量

        `awk -F: '{shells[$NF]++} END{ for( i in shells){print i,shells[i]} }' /etc/passwd`

      - 统计网站访问状态<当前实时状态 `netstat -ant`>

        `netstat -ant|grep ':80' |awk '{status[$NF]++}END{ for(i in status){print i,status[i]} }'`

        `netstat -ant|grep ':80' |awk '{status[$NF]++}END{ for(i in status){print i,status[i]} }'|sort -k2 -n|head`  从小到大排序

        `ss -an|grep ':80' |awk '{status[$2]++}END{ for(i in status){print i,status[i]} }'|sort -k2 -n|head`

      - 

9. 