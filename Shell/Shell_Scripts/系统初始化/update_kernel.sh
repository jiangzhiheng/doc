#!/bin/bash
# update Centos Kernel to latest
# 
KERNEL_VERSION=kernel-ml
KERNEL_VERSION=kernel-ml
#KERNEL_VERSION=kernel-lt   #long term

# Pre install
yum -y install wget

# Enable ELRepo
rpm  --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

# Install rpm source
wget https://mirrors.tuna.tsinghua.edu.cn/elrepo/kernel/el7/x86_64/RPMS/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
rpm -ivh elrepo-release-7.0-4.el7.elrepo.noarch.rpm

# List All Available Kernel
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available

# Install Kernel
yum  --enablerepo=elrepo-kernel -y  install  $KERNEL_VERSION

# Edit Grub config
sed -ri '/^GRUB_DEFAULT=/cGRUB_DEFAULT=0' /etc/default/grub

grub2-mkconfig  -o  /boot/grub2/grub.cfg

echo "************************************************"
echo "Install Complete,Please remove old Version"
rpm -qa | grep kernel*
echo "Please use yum remove..."
echo "If finished,Please reboot OS...."
