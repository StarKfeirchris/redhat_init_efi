#!/bin/bash

chkcinfig iptables off

sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

yum install -y epel-release

yum install -y vim net-tools wget screen

yum update -y

yum upgrade -y

mv /etc/bashrc /etc/bashrc.bak

\cp -f ./bashrc /etc/

source /etc/bashrc

# Update latest kernel
rpm -Uvh http://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

yum -y --enablerepo=elrepo-kernel install kernel-ml

grub2-set-default 0

init 6


