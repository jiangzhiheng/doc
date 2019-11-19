#!/bin/bash
# This scripts used by Initaization Centos7/Centos6

# get os version
RELEASEVER=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))

# configure yum source
cd /etc/yum.repos.d/
mkdir /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak
if [ $RELEASEVER == 6 ];then
	curl http://mirrors.163.com/.help/CentOS6-Base-163.repo > base.repo
fi
if [ $RELEASEVER == 7 ];then
	curl http://mirrors.163.com/.help/CentOS7-Base-163.repo > base.repo
fi
yum clean all
yum check-update

# install base rpm package
yum -y install epel-release
yum -y install nc vim iftop iotop dstat tcpdump
yum -y install ipmitool bind-libs bind-utils net-tools
yum -y install libselinux-python ntpdate

# update rpm package include kernel
yum -y update
rm -rf /etc/yum.repos.d/CentOS*

#update ulimit configure
if [ $RELEASEVER == 6 ];then
	test -f /etc/security/limits.d/90-nproc.conf && rm -rf /etc/security/limits.d/90-nproc.conf && touch /etc/security/limits.d/90-nproc.conf
fi
if [ $RELEASEVER == 7 ];then
	test -f /etc/security/limits.d/20-nproc.conf && rm -rf /etc/security/limits.d/20-nproc.conf && touch /etc/security/limits.d/20-nproc.conf
fi

> /etc/security/limits.conf
cat >> /etc/security/limits.conf <<EOF
* soft nproc 65535
* hard nporc 65535
* soft nofile 65535
* hard nofile 65535
EOF

# set timezone
test -f /etc/localtime && rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# set LANG
if [ $RELEASEVER == 6 ];then
	sed -ri 's@LANG=.*$@LANG="en_US.UTF-8"@g' /etc/sysconfig/i18n
fi
if [ $RELEASEVER == 7 ];then
	sed -ri 's@LANG=.*$@LANG="en_US.UTF-8"@g' /etc/locale.conf
fi

# update time
if [ $RELEASEVER == 6 ];then
	/usr/sbin/ntpdate -b pool.ntp.org
	grep -q ntpdate /var/spool/cron/root
	if [ $? -eq 0 ];then
		echo '* * * * * /usr/sbin/ntpdate pool.ntp.org > /dev/null 2>&1' >> /var/spool/cron/root;chmod 600 /var/spool/cron/root
	fi
	/etc/init.d/crond restart
fi

if [ $RELEASEVER == 7 ];then
	yum -y install chrony
	> /etc/chrony.conf
cat > /etc/chrony.conf << EOF
server pool.ntp.org iburst
statumweight 0
driftfile /var/lib/chrony/drift
makestep 10 3
rtcsync
bindcmdaddress 127.0.0.1
bindcmdaddress ::1
commandkey 1
generatecommandkey
noclientlog
logchange 0.5
allow 192.168.0.0/16
keyfile /etc/chrony.keys
logdir /var/log/chrony
EOF

	systemctl restart chronyd
	systemctl enable chronyd	
fi

# clean iptables default rules

if [ $RELEASEVER == 6 ];then
	/sbin/iptables -F
	service iptables save
	chkconfig iptables off
fi
if [ $RELEASEVER == 7 ];then
	systemctl disable firewalld
fi

# disable unused service
if [ $RELEASEVER == 6 ];then
	chkconfig auditd off
fi
if [ $RELEASEVER == 7 ];then
	systemctl disable auditd.service
fi

# disable ipv6
cd /etc/modprobe.d/ && touch ipv6.conf
> /etc/modprobe.d/ipv6.conf
cat >> /etc/modprobe.d/ipv6.conf << EOF
alias net-pf-10 off
alias ipv6 off
EOF

# disable iptable nat moudule
cd /etc/modprobe.d/ && touch connectiontracking.conf
> /etc/modprobe.d/connectiontracking.conf
cat >> /etc/modprobe.d/connectiontracking.conf <<EOF
install nf_nat /bin/true
install xt_state /bin/true
install iptable_nat /bin/true
install nf_conntrack /bin/true
install nf_defrag_ipv4 /bin/true
install nf_conntrack_ipv4 /bin/true
install nf_conntrack_ipv6 /bin/true
EOF

# disable SELINUX
setenforce 0
sed -ri 's/^SELINUX=.*$/SELINUX=disabled' /etc/selinux/config
 
# update record command
sed -ri 's/^HISTSIZE=.*$/HISTSIZE=100000/' /etc/profile
grep -q 'HISTTIMEFORMAT' /etc/profile
if [[ $? -eq 0 ]];then
	sed -ri 's/HISTTIMEFORMAT=.*$/HISTTIMEFORMAT="%F %T"/' /etc/profile
else
	echo 'HISTTIMEFORMAT="%F %T"' >> /etc/profile
fi
# install dnsmasq and update configure（本地DNS缓存）
yum -y install 
> /etc/dnsmasq.conf
cat >> /etc/dnsmasq.conf <<EOF
listen-address=127.0.0.1
no-dhcp-interface=lo
log-queries
log-facility=/var/log/dnsmasq.log
all-servers
no-negcache
cache-size=1024
dns-forward-max=512
EOF

if [ $RELEASEVER == 6 ];then
	/etc/init.d/dnsmasq restart
fi
if [ $RELEASEVER == 7 ];then
	systemctl restart dnsmasq
	systemctl enable dnsmasq
fi

# update /etc/resolv.conf
> /etc/resolv.conf
cat >> /etc/resolv.conf << EOF
options timeout:1
nameserver 127.0.0.1
nameserver 8.8.8.8
EOF

# update /etc/sysctl.conf
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_syncookies=1
kernel.core_uses_pid=1
kernel.core_pattern=/tmp/core-%e-%p
fs.suid_dumpable=2
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_tw_recycle=0
net.ipv4.tcp_timestamps=1
EOF

sysctl -p


