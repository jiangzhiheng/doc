#!/bin/bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
yum makecache
yum -y install wget
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum -y install net-tools nc vim iftop iotop dstat tcpdump

> /etc/security/limits.conf
cat >> /etc/security/limits.conf <<EOF
* soft nproc 65535
* hard nporc 65535
* soft nofile 65535
* hard nofile 65535
EOF

test -f /etc/localtime && rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sed -ri 's@LANG=.*$@LANG="en_US.UTF-8"@g' /etc/locale.conf

yum -y install chrony
> /etc/chrony.conf

cat > /etc/chrony.conf << EOF
server ntp.aliyun.com iburst
stratumweight 0
driftfile /var/lib/chrony/drift
rtcsync
makestep 10 3
bindcmdaddress 127.0.0.1
bindcmdaddress ::1
keyfile /etc/chrony.keys
commandkey 1
generatecommandkey
logchange 0.5
logdir /var/log/chrony
EOF

systemctl restart chronyd
systemctl enable chronyd

systemctl stop firewalld
systemctl disable firewalld

setenforce 0
sed -ri '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config

> /etc/resolv.conf
cat >> /etc/resolv.conf << EOF
nameserver 8.8.4.4
nameserver 8.8.8.8
EOF


