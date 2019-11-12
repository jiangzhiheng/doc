#!/bin/bash
#
config(){
\cp $config_dir/nginx.conf $nginx_prefix/conf/nginx.conf
\cp $config_dir/index.php $nginx_prefix/html/index.php
$nginx_prefix/sbin/nginx



\cp $config_dir/php.conf $php_prefix/conf/php.ini

}
