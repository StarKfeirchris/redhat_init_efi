#!/bin/bash

# Setting the execution environment, only test.
#set -xeo pipefail

# Disable SELinux.
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# Install ntpdate pakage.
yum install -y ntpdate

# Update time.
ntpdate time.stdtime.gov.tw && hwclock -w

# Auto update time.
echo "* */12 * * * root /usr/sbin/ntpdate time.stdtime.gov.tw && /sbin/hwclock -w" >> /etc/crontab

# Install redhat lsb pakage
yum install -y redhat-lsb

# Get system version.
redhat_release=$(lsb_release -irs)

# Backup bashrc file.
\cp -f /etc/bashrc /etc/bashrc.original

# Execute command for different system versions.
# Disable iptables or firewall. (Default not disable)
# Backup & setup prompt config.
# Update system & install EPEL repo. (CentOS only)
# Upgrade kernel to mainline.
case ${redhat_release} in
	'CentOS 6.'* )
		# If you need close iptables, remove comment.
		#chkconfig iptables off
		sed -i '36 s/  /  #/g' /etc/bashrc
		sed -i '36a [ "$PS1" = "\\\\\s-\\\\\/v\\\\\\$ " ] && PS1="\\[\\e[0;91m\\][\\[\\e[0m\\]\\[\\e[0;92m\\]\\u\\[\\e[0m\\]\\[\\e[0;94m\\]@\\h\\[\\e[0m\\] \\[\\e[0;93m\\]\\W/\\[\\e[0m\\]\\[\\e[0;91m\\]]\\[\\e[0m\\]\\[\\e[0;93m\\]\\\\\$\\[\\e[0m\\] "' /etc/bashrc
		sed -i '37 s/^/   /' /etc/bashrc
		sed -i '37 s/\/v/v/' /etc/bashrc
		yum install -y epel-release
		yum update -y
		yum upgrade -y
		rpm -Uvh http://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm
		rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
		yum -y --enablerepo=elrepo-kernel install kernel-ml
		sed -i '11 s/default=1/default=0/' /boot/efi/EFI/redhat/grub.conf
		;;
	'CentOS 7.'* )
		# If you need close firewall, remove comment.
		#systemctl disable firewalld
		sed -i '41 s/  /  #/g' /etc/bashrc
		sed -i '41a [ "$PS1" = "\\\\\s-\\\\\/v\\\\\\$ " ] && PS1="\\[\\e[0;91m\\][\\[\\e[0m\\]\\[\\e[0;92m\\]\\u\\[\\e[0m\\]\\[\\e[0;94m\\]@\\h\\[\\e[0m\\] \\[\\e[0;93m\\]\\W/\\[\\e[0m\\]\\[\\e[0;91m\\]]\\[\\e[0m\\]\\[\\e[0;93m\\]\\\\\$\\[\\e[0m\\] "' /etc/bashrc
		sed -i '42 s/^/   /' /etc/bashrc
		sed -i '42 s/\/v/v/' /etc/bashrc
		yum install -y epel-release
		yum update -y
		yum upgrade -y
		rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
		rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
		yum -y --enablerepo=elrepo-kernel install kernel-ml
		grub2-set-default 0
		;;
	'Fedora '* )
		sed -i '45 s/  /   #/g' /etc/bashrc
		sed -i '45a [ "$PS1" = "\\\\\s-\\\\\/v\\\\\\$ " ] && PS1="\\[\\e[0;91m\\][\\[\\e[0m\\]\\[\\e[0;92m\\]\\u\\[\\e[0m\\]\\[\\e[0;94m\\]@\\h\\[\\e[0m\\] \\[\\e[0;93m\\]\\W/\\[\\e[0m\\]\\[\\e[0;91m\\]]\\[\\e[0m\\]\\[\\e[0;93m\\]\\\\\$\\[\\e[0m\\] "' /etc/bashrc
		sed -i '46 s/^/    /' /etc/bashrc
		sed -i '46 s/\/v/v/' /etc/bashrc
		echo '
		#!/bin/bash
		# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
		#
		# It is highly advisable to create own systemd services or udev rules
		# to run scripts during boot instead of using this file.
		#
		# In contrast to previous versions due to parallel execution during boot
		# this script will NOT be run after all other services.
		#
		# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
		# that this script will be executed during boot.
		
		' >> /etc/rc.d/rc.local
		# If you need close firewall, remove comment.
		#systemctl disable firewalld
		#chmod +x /etc/rc.d/rc.local
		#echo "systemctl stop firewalld" >> /etc/rc.d/rc.local
		dnf update -y
		dnf upgrade -y
		;;
esac

# Install pakage.
yum install -y vim bash-completion net-tools wget screen

# Add history time.
echo '

######################## History Time ########################
# History time
#(%m=month %d=day %y=year %H=hour,00..23 %M=minute,00..59 %S=second,00..60)
#(%a=weekday name,e.g.fri %w=day for week,0..6, 0 is sunday)
export HISTTIMEFORMAT="%m/%d/%y %a %H:%M:%S -> "
#export HISTTIMEFORMAT="%m/%d/%y %w %H:%M:%S -> "

#History file size
#export HISTFILESIZE=1000000

#History saved commad line
export HISTSIZE=20000
##############################################################
' >> /etc/bashrc

# Effective bashrc.
source /etc/bashrc

# Reboot system.
read -p "Script execution succeed, do you want to reboot?(yes or no) " reboot

case ${reboot} in
	yes|y|Y|Yes|yEs|yeS|YEs|yES|YES|YeS )
		init 6
		;;
	no|n|N|NO|nO|No )
		echo 'Will not reboot system.'
		;;
	* )
		echo 'Entered a character other than yes or no, script will be stop now.'
		;;
		
esac

