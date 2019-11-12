#!/bin/bash
#Tengine install

tengine_install(){

yum -y install gcc openssl-devel pcre-devel
useradd nginx
cd $soft_dir
tar -xf $tengine_version
cd ${tengine_version%.tar.gz}
./configure && make -j $cpus && make install

echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.local
chmod a+x /etc/rc.d/rc.local
echo "export PATH=$PATH:/usr/local/nginx/sbin" >> /etc/profile
source /etc/profile


}
