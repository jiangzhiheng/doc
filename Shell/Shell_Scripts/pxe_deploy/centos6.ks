#platform=x86, AMD64, 或 Intel EM64T
#version=DEVEL
# Firewall configuration
firewall --disabled
# Install OS instead of upgrade
install
# Use FTP installation media
ftp --server=192.168.17.26 --dir=/centos6
# Root password
rootpw 123456
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use text mode install
text
# System keyboard
keyboard us
# System language
lang en_US
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# Installation logging level
logging --level=info

key --skip

# Reboot after installation
reboot
# System timezone
timezone  Asia/Shanghai
# Network information
network  --bootproto=dhcp --device=eth0 --onboot=on
# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel 
# Disk partitioning information
part swap --fstype="swap" --size=1024
part / --fstype="ext4" --grow --size=1

%packages
@base
@compat-libraries
@core
@debugging
@development
@server-policy
@workstation-policy
python-dmidecode
sgpio
device-mapper-persistent-data
systemtap-client
%end
