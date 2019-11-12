#!/bin/bash
# memory status for zabbix
MemTotal(){
	awk '/^MemTotal/{print $2}' /proc/meminfo
}

MemFree(){
	awk '/^MemFree/{print $2}' /proc/meminfo
}

Buffers(){
	awk '/^Buffers/{print $2}' /proc/meminfo
}

Dirty(){
	awk '/^Dirty/{print $2}' /proc/meminfo
}

Cached(){
	awk '/^Cached/{print $2}' /proc/meminfo
}

SwapTotal(){
	awk '/^SwapTotal/{print $2}' /proc/meminfo
}

$1
