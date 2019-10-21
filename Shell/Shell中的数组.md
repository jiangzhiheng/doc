Shell数组变量

- 普通数组：只能使用整数做为数组索引

  `books=(linux shell awk openstack docker)`

  `echo ${books[3]}`

- 关联数组：可以使用字符串做为数组索引（可以理解为java中的map）

  `declare -A info`  声明一个关联数组

  `info=([name]=Martin [sex]=male [age]=36 [height]=170 )`

  `echo ${info[age]}`



1. 定义数组

   方法一：一次赋一个值

   数组名[下标]=变量值

   方法二：一次赋多个值

   - `array=(tom jack alice)`
   - `array1=(${cat /etc/passwd})`  希望是将该文件中的每一行做为一个元素赋值给数组
   - `colors=($red $yellow $blue)`

2. 查看数组

   `delcare -a`

3. 访问数组元素

   `echo ${array[0]}`  访问数组中的第一个元素

   `echo ${array[@]}`  访问数组中的所有元素

   `echo ${#array[@]}`  统计数组元素的个数

   `echo ${!array[@]}`  获取数组元素的索引

   `echo ${array[1]:1}`    从数组下标1开始

   `echo ${array[1]:1:2}`    从数组下标1开始,访问两个元素

4. 遍历数组

   通过数组元素的索引进行遍历

   ```shell
   #!/bin/bash
   # 数组的遍历1：while array
   while read line
   do
           hosts[++i]=$line
   done </etc/hosts
   
   echo "hosts first:${hosts[1]}"
   
   for i in ${!hosts[@]}
   do
           echo "$i: ${hosts[i]}"
   done
   
   ######################################
   #数组的遍历2：for array
   OLD_IFS=$IFS  #保存旧的分隔符
   IFS=$'\n'   #重新赋值分隔符
   for line in `cat /etc/hosts`
   do
           hosts[++j]=$line
   done
   
   for i in ${!hosts[@]}
   do
           echo "$i: ${hosts[i]}"
   done
   
   IFS=$OLD_IFS  #切换回原来的分隔符
   ```

5. array示例：关联数组实现性别统计

   ```shell
   #!/bin/bash
   #
   #count sex
   declare -A sex
   while read line
   do
           type=`echo $line |awk '{print $2}'`
           let sex[$type]++
   
   done <sex.txt
   
   for i in ${!sex[@]}
   do
           echo "$i :${sex[$i]}"
   done
   #把要统计的对象做为数组的索引
   ```

6. 统计shell使用情况

   ```shell
   #!/bin/bash
   #count shell
   
   declare -A shells
   while read line
   do
           type=`echo $line |awk -F":" '{print $NF}'`
           let shells[$type]++
   done </etc/passwd
   
   for i in ${!shells[@]}
   do
           echo "$i: ${shells[$i]}"
   done
   #一行awk命令即可搞定
   #[root@martin ~]# awk -F":" '{print $NF}' /etc/passwd |sort |uniq -c
   ```

7. array统计TCP链接状态数量

   ```shell
   #!/bin/bash
   # count tcp conn staus
   
   declare -A status
   stat=`ss -an|grep :80|awk '{print $2}'`
   
   for i in $stat
   do
           let status[$i]++
   done
   
   for j in ${!status[@]}
   do      
           echo "$j:${status[$i]}"
   done
   
   ```

   

   
