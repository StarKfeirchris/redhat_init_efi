#!/bin/bash

chkconfig iptables off

# Disable SELinux.
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# Backup bashrc file.
\cp -f /etc/bashrc /etc/bashrc.original

# Mark original prompt config.
sed -i '36 s/  /  #/g' /etc/bashrc

# Add new prompt config.
sed -i '36a [ "$PS1" = "\\\\\s-\\\\\/v\\\\\\$ " ] && PS1="\\[\\e[0;91m\\][\\[\\e[0m\\]\\[\\e[0;92m\\]\\u\\[\\e[0m\\]\\[\\e[0;94m\\]@\\h\\[\\e[0m\\] \\[\\e[0;93m\\]\\W/\\[\\e[0m\\]\\[\\e[0;91m\\]]\\[\\e[0m\\]\\[\\e[0;93m\\]\\\\\$\\[\\e[0m\\] "' /etc/bashrc

sed -i '37 s/^/   /' /etc/bashrc

sed -i '37 s/\/v/v/' /etc/bashrc

# Add history time.
echo "" >> /etc/bashrc
sed -i '$a\######################## History Time ########################' /etc/bashrc
sed -i '$a\# History time' /etc/bashrc
sed -i '$a\# (%m=month %d=day %y=year %H=hour,00..23 %M=minute,00..59 %S=second,00..60)' /etc/bashrc
sed -i '$a\# (%a=weekday name,e.g.fri %w=day for week,0..6, 0 is sunday)' /etc/bashrc
sed -i '$a\export HISTTIMEFORMAT="%m/%d/%y %a %H:%M:%S -> "' /etc/bashrc
sed -i '$a\#export HISTTIMEFORMAT="%m/%d/%y %w %H:%M:%S -> "' /etc/bashrc
echo "" >> /etc/bashrc
sed -i '$a\# History file size' /etc/bashrc
sed -i '$a\#export HISTFILESIZE=1000000' /etc/bashrc
echo "" >> /etc/bashrc
sed -i '$a\# History saved commad line' /etc/bashrc
sed -i '$a\export HISTSIZE=20000' /etc/bashrc
sed -i '$a\##############################################################' /etc/bashrc

source /etc/bashrc

yum install -y epel-release

yum install -y vim bash-completion net-tools wget screen

yum update -y

yum upgrade -y

# Update latest kernel
rpm -Uvh http://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

yum -y --enablerepo=elrepo-kernel install kernel-ml

sed -i '11 s/default=1/default=0/' /boot/efi/EFI/redhat/grub.conf

init 6


