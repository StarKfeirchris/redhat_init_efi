#!/bin/bash

echo System infomation:
cat /etc/system-release
echo
uname -snr
echo
ip a | grep -E "eth0|eth1|enp|ens|em1|em2"
echo

echo Firewall status:
systemctl status firewalld | grep -B2 "Active:"
echo

echo Check SELinux:
sestatus | grep "SELinux status:"
sestatus | grep "Current mode:"
echo

echo Check EPEL repo:
echo "(Fedora is null.)"
rpm -qa | grep epel
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

