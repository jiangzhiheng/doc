#!/bin/bash
#This Scripts is used by install docker-ce 
# 使用 yum list docker-ce.x86_64 --showduplicates | sort -r 查看支持的版本
DOCKER_VERSION=18.06.0.ce-3.el7

# Pre install
cd /etc/yum.repos.d/
mkdir /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak
curl http://mirrors.163.com/.help/CentOS7-Base-163.repo > base.repo
yum install -y wget 
yum install -y yum-utils device-mapper-persistent-data lvm2

# Install Docker-CE
cd /etc/yum.repos.d/
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo &>/dev/null
yum -y install docker-ce-${DOCKER_VERSION}
# Docker-ce Version
# yum list docker-ce.x86_64 --showduplicates | sort -r
# 参考文档
# https://developer.aliyun.com/mirror/docker-ce?spm=a2c6h.13651102.0.0.3e221b11nOtc6w
# 配置镜像加速
mkdir /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://pync0a1m.mirror.aliyuncs.com"]
}
EOF

# Tips
cat >> /etc/sysctl.conf <<-'EOF'
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

modprobe br_netfilter
sysctl -p

systemctl start docker.service
systemctl enable docker.service
