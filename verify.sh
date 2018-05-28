#!/bin/bash

echo System infomation:
cat /etc/system-release
echo
uname -snr
echo
date
echo
ip a | grep -E "eth0|eth1|enp|ens|em1|em2"
echo

fw_status=$(lsb_release -irs)

echo Firewall status:
echo "(Default active.)"

# Execute command for different system versions. 
# show firewall status.
case ${fw_status} in
	'CentOS 6.'* )
		chkconfig | grep iptables
		service iptables status
		echo
		;;
	'CentOS 7.'*|'Fedora '* )
		systemctl status firewalld | grep -B2 "Active:"
		echo
		;;

esac

echo Check SELinux:
sestatus | grep "SELinux status:"
sestatus | grep "Current mode:"
echo

echo Check crontab:
tail -n1 /etc/crontab
echo

echo Check EPEL repo:
echo "(Fedora is null.)"
rpm -qa | grep epel
echo

echo Check bash-completion
rpm -qa | grep bash-completion
echo

echo Check VIM:
rpm -qa | grep vim
echo

echo Check wget:
rpm -qa | grep wget
echo

echo Check screen:
rpm -qa | grep screen
echo

echo Check net-tools:
rpm -qa | grep net-tools
echo

echo Check ntpdate:
rpm -qa | grep ntpdate
echo

echo Check history time config:
tail -n15 /etc/bashrc
echo

echo Check TCP BBR config:
bbr_1=$(sysctl -n net.ipv4.tcp_congestion_control)
bbr_2=$(lsmod | grep bbr)
echo '1. '$bbr_1 '(print screen message should be "bbr")'
echo '2. '$bbr_2 '(print screen  message like "tcp_bbr 20480 5")'
echo
