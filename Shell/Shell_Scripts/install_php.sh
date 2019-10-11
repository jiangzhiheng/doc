#!/bin/bash
#
####################################
# Install PhP                      #
# v0.1 by jiangzhiheng 2019.10.11  #
####################################

install_php56(){
	echo "install php5.6..."
}

install_php70(){
	echo "install php7.0..."
}

install_php71(){
	echo "install php7.1..."
}
menu(){
	clear
	echo "###################################"
	echo -e "\t1. php-5.6"
	echo -e "\t2. php-7.0"
	echo -e "\t3. php-7.1"
	echo -e "\t4. quit"
	echo -e "\t5. help"
	echo "###################################"
}

menu

while true
do
	read -p "version[1-3]" version
	case "$version" in
	1)
		install_php56
		;;
	2)
		install_php70
		;;
	3)	
		install_php71
		;;
	4)
		exit
		;;
	5)
		menu
		;;
	*)
		echo "Input Error!"
	esac
done
