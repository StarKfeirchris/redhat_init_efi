#!/bin/bash

# Setting the execution environment, always open.
set -xeo pipefail

# Disable SELinux.
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# Install redhat lsb pakage
yum install -y redhat-lsb --skip-broken

# Get system version.
redhat_release=$(lsb_release -irs)

# Backup bashrc file.
bashrc_backup=$(ls /etc | grep -E 'bashrc.bak|bashrc.original' || true)

case ${bashrc_backup} in
	'' )
		\cp -f /etc/bashrc /etc/bashrc.original
		;;
	'bashrc.'* )
		true
		;;
esac

# Execute command for different system versions.
# Disable iptables or firewall. (Default not disable)
# Backup & setup prompt config.
# Update system & install EPEL repo. (CentOS only)
# Upgrade kernel to mainline.
case ${redhat_release} in
	'CentOS 6.'* )
		# First run or not.
		first_run=$(cat /etc/bashrc | grep '0;94m' | cut -f13 -d'[' | cut -f1 -d'\' || true)
		case ${first_run} in
			'' )
				# If you need close iptables, remove comment.
				#chkconfig iptables off
				sed -i '36 s/  /  #/g' /etc/bashrc
				sed -i '36a [ "$PS1" = "\\\\\s-\\\\\/v\\\\\\$ " ] && PS1="\\[\\e[0;91m\\][\\[\\e[0m\\]\\[\\e[0;92m\\]\\u\\[\\e[0m\\]\\[\\e[0;94m\\]@\\h\\[\\e[0m\\] \\[\\e[0;93m\\]\\W/\\[\\e[0m\\]\\[\\e[0;91m\\]]\\[\\e[0m\\]\\[\\e[0;93m\\]\\\\\$\\[\\e[0m\\] "' /etc/bashrc
				sed -i '37 s/^/   /' /etc/bashrc
				sed -i '37 s/\/v/v/' /etc/bashrc
				yum install -y epel-release
				yum update -y
				yum upgrade -y
				rpm -Uvh http://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm || true
				rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org || true
				yum -y --enablerepo=elrepo-kernel install kernel-ml
				sed -i '11 s/default=1/default=0/' /boot/efi/EFI/redhat/grub.conf
				;;
			'0;94m' )
				true
				;;
		esac
		;;
	'CentOS 7.'* )
		# First run or not.
		first_run=$(cat /etc/bashrc | grep '0;94m' | cut -f13 -d'[' | cut -f1 -d'\' || true)
		case ${first_run} in
			'' )
				# If you need close firewall, remove comment.
				#systemctl disable firewalld
				sed -i '41 s/  /  #/g' /etc/bashrc
				sed -i '41a [ "$PS1" = "\\\\\s-\\\\\/v\\\\\\$ " ] && PS1="\\[\\e[0;91m\\][\\[\\e[0m\\]\\[\\e[0;92m\\]\\u\\[\\e[0m\\]\\[\\e[0;94m\\]@\\h\\[\\e[0m\\] \\[\\e[0;93m\\]\\W/\\[\\e[0m\\]\\[\\e[0;91m\\]]\\[\\e[0m\\]\\[\\e[0;93m\\]\\\\\$\\[\\e[0m\\] "' /etc/bashrc
				sed -i '42 s/^/   /' /etc/bashrc
				sed -i '42 s/\/v/v/' /etc/bashrc
				yum install -y epel-release
				yum update -y
				yum upgrade -y
				rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm || true
				rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org || true
				yum -y --enablerepo=elrepo-kernel install kernel-ml
				grub2-set-default 0
				;;
			'0;94m' )
				true
				;;
		esac
		;;
	'Fedora '* )
		# First run or not.
		first_run=$(cat /etc/bashrc | grep '0;94m' | cut -f13 -d'[' | cut -f1 -d'\' || true)
		case ${first_run} in
			'' )
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
			'0;94m' )
				true
				;;
		esac
		;;
esac

# Install pakage.
yum install -y vim bash-completion net-tools wget screen ntp ntp-doc

# Remove crontab time update configuration.
time_sync=$(cat /etc/crontab | grep 'stdtime' | cut -f5 -d'/' | cut -f2 -d'.' || true)

case ${time_sync} in
	'' )
		true
		;;
	'stdtime' )
		sed -i '/hwclock -w$/'d /etc/crontab
		;;
esac

# Add ntpd configuration.
ntpd_conf=$(cat /etc/ntp.conf | grep 'stdtime' | cut -f2 -d'.' | uniq -d || true)

case ${ntpd_conf} in
	'' )
		sed -i 's/pool /#pool /g' /etc/ntp.conf
		sed -i 's/^server \([0-3]\).centos/#\0.centos/' /etc/ntp.conf
		sed -i '24a server ntp2.ntu.edu.tw prefer' /etc/ntp.conf
		sed -i '24a server ntp.ntu.edu.tw prefer' /etc/ntp.conf
		sed -i '24a server clock.stdtime.gov.tw prefer' /etc/ntp.conf
		sed -i '24a server time.stdtime.gov.tw prefer' /etc/ntp.conf
		systemctl enable ntpd
		systemctl start ntpd
		;;
	'stdtime' )
		true
		;;
esac

# Add history time.
# Only the first run will be written, other not.
his_time_conf=$(cat /etc/bashrc | grep 'History Time' | cut -f2-3 -d' ' || true)

case ${his_time_conf} in
	'' )
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
		;;
	'History Time' )
		true
		;;
esac

# Add TCP BBR config
sysctl_backup=$(cat /etc/sysctl.conf | grep BBR | cut -f2 -d' ' || true)

case ${sysctl_backup} in
	'' )
		echo '
		
# BBR congestion control
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
		' >> /etc/sysctl.conf
		;;
	'BBR' )
		true
		;;
esac

# Reboot system.
set +x

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
