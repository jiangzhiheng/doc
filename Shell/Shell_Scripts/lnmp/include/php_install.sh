#!/bin/bash
#install php

php_install(){

yum -y install libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel \
libxml2 libxml2-devel libcurl libcurl-devel libxslt-devel openssl-devel
cd $soft_dir
tar -xf $php_version
cd ${php_version%.tar.gz}
./configure \
--prefix=$php_prefix
#具体安装参数请自行配置
make -j $cpus && make install


}



