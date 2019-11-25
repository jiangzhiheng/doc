#version=RHEL7
# System authorization information
auth --useshadow --enablemd5
# Install OS instead of upgrade
install
# Reboot after installation
reboot
# Use FTP installation media
url --url="ftp://192.168.1.128/centos7/"
# Firewall configuration
firewall --disabled
firstboot --disable
ignoredisk --only-use=sda
# Keyboard layouts
# old format: keyboard us
# new format:
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp
network  --hostname=localhost.localdomain
# Root password
rootpw --iscrypted $1$DZECR00C$11JDdkgsPxBhzlPTO6ho.0
# System services
services --enabled="chronyd"
# System timezone
timezone --utc Asia/Shanghai
# X Window System configuration information
xconfig  --startxonboot
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel 
# Disk partitioning information
part pv.11 --fstype="lvmpv" --ondisk=sda --size=17008
part /boot --fstype="xfs" --ondisk=sda --size=1000
volgroup centos --pesize=4096 pv.11
logvol /home  --fstype="xfs" --size=10000 --name=home --vgname=centos
logvol /  --fstype="xfs" --size=5000 --name=root --vgname=centos
logvol swap  --fstype="swap" --size=2000 --name=swap --vgname=centos


%post
/bin/echo done
%end

%packages
@base
@core
@desktop-debugging
@dial-up
@directory-client
@fonts
@gnome-desktop
@guest-desktop-agents
@input-methods
@internet-browser
@multimedia
@network-file-system-client
@print-client
@x11
binutils
chrony
ftp
gcc
kernel-devel
make
patch
python

%end

