#kickstart Configurator for CentOS 7  #命令段
install   #告知安装程序，这是一次全新安装，而不是升级
url --url="ftp://192.168.1.128/centos7/"  #通过ftp下载安装镜像
text     #以文本格式安装
lang en_US.UTF-8   #设置字符集格式
keyboard us  #设置键盘类型
skipx
zerombr   #清除mbr引导
bootloader --location=mbr --driveorder=sda --append="net.ifnames=0 biosdevname=0 crashkernel=auto rhgb quiet"    #指定引导记录被写入的位置
network --bootproto=dhcp --device=eth1 --onboot=yes --noipv6 --hostname=CentOS7
timezone --utc Asia/Shanghai  #可以使用dhcp方式设置网络
authconfig --enableshadow --passalgo=sha512  #设置密码格式
rootpw  --iscrypted $6$P0RRkp7l/Eob0EFj$8rbLxL.DRkIviA7g6be88llbY80LAXVd4w8rIm5eVU32CdLQVTAYL0jm1zrscxnrChdKUgi41qVXicuVAipTv0
clearpart --all --initlabel  #清空分区
part /boot --fstype xfs --size 1024   #/boot分区
part swap --size 1024                    #swap分区
part / --fstype xfs --size 1 --grow   #/分区
firstboot --disable       #负责协助配置redhat一些重要的信息
selinux --disabled        #关闭selinux
firewall --disabled       #关闭防火墙
logging --level=info      #设置日志级别
reboot                       #安装完成重启

%packages #包组段   @表示包组
@^minimal
@debugging
@development
tree
lrzsz
dos2unix
vim
bash-completion
%end

%post #脚本段，可以放脚本或命令
systemctl disable postfix.service   #关闭邮件服务开机自启动
%end
