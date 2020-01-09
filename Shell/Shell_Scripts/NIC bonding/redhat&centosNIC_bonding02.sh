#!/bin/bash
#check bonding.conf
bondname=$1
bondvar=${bondname:0:4}
member1=$2
member1var=${member1:0:3}
member2=$3
member2var=${member2:0:3}
ip=$4
mask=$5
gw=$6
case $bondvar in
    bond)
    case $member1var in
        eth)
        case $member2var in
            eth)
            if test -e /etc/modprobe.d/bonding.conf
            then
                echo "The bonding.conf is exists" && exit 0
            else
                echo "alias $bondname bonding" > /etc/modprobe.d/bonding.conf
            fi
            if test -e /etc/sysconfig/network-scripts/ifcfg-"$member1"
            then
                echo "ifcfg-$member1 is exists backup to ifcfg-$member1.bak"
                mv /etc/sysconfig/network-scripts/ifcfg-"$member1" /etc/sysconfig/network-scripts/ifcfg-"$member1".bak
                echo "writing config to new ifcfg-$member1"
(
cat <<EOF
DEVICE=$member1
BOOTPROTO=none
ONBOOT=yes
MASTER=$bondname
SLAVE=yes
USERCTL=no
EOF
) > /etc/sysconfig/network-scripts/ifcfg-"$member1"
                echo "create ifcfg-$member1 success"
            else
                echo "ifcfg-$member1 is not exists,check it please!!" && exit 0
            fi
            if test -e /etc/sysconfig/network-scripts/ifcfg-"$member2"
            then
                echo "ifcfg-$member2 is exists backup to ifcfg-$member2.bak"
                mv /etc/sysconfig/network-scripts/ifcfg-"$member2" /etc/sysconfig/network-scripts/ifcfg-"$member2".bak
                echo "writing config to new ifcfg-$member2"
(
cat <<EOF
DEVICE=$member2
BOOTPROTO=none
ONBOOT=yes
MASTER=$bondname
SLAVE=yes
USERCTL=no
EOF
) > /etc/sysconfig/network-scripts/ifcfg-"$member2"
                echo "create ifcfg-$member2 success"
            else
                echo "ifcfg-$member2 is not exists,check it please!!" && exit 0
            fi              
            if test -e /etc/sysconfig/network-scripts/ifcfg-"$bondname"
            then
                echo "ifcfg-$bondname is exists,check it please!!" && exit 0
            else
                echo "writing config to new ifcfg-$bondname"
(
cat <<EOF
DEVICE=$bondname
IPADDR=$ip
NETMASK=$mask
ONBOOT=yes
BOOTPROTO=none
USERCTL=no
BONDING_OPTS='mode=1 miimon=100'
GATEWAY=$gw
EOF
) > /etc/sysconfig/network-scripts/ifcfg-$bondname
                echo "create ifcfg-$bondname sccess"
            fi  
            ;;
            *)
            echo "createbonding useage：<bond nic name> <member1> <member2> [IP address] [netmask] [gateway]" && exit 1
            ;;
        esac
        ;;
        *)
        echo "createbonding useage：<bond nic name> <member1> <member2> [IP address] [netmask] [gateway]" && exit 1
        ;;
    esac
    ;;
    *)
    echo "createbonding useage：<bond nic name> <member1> <member2> [IP address] [netmask] [gateway]" && exit 1
    ;;
esac
service NetworkManager stop
chkconfig NetworkManager off
service network restart
#end of script
