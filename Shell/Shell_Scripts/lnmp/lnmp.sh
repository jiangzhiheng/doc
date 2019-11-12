#!/bin/bash
#lnmp install
#v1.0 By Jiangzhiheng

. installrc
. include/init.sh
. include/php_install.sh
. include/tengine_install.sh
. include/config.sh

soft_dir=`pwd`/src
cpus=`lscpu |awk '/^CPU\(s\)/{print $2}'`
config_dir=`pwd`/src/config

init_os
tengine_instal
php_install
config
