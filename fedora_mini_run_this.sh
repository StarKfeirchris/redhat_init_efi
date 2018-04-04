#!/bin/bash

#Setting the execution environment.
set -xeo pipefail

# If you need close firewall, remove mark.
#systemctl disable firewalld

echo "#!/bin/bash" >> /etc/rc.d/rc.local
echo "# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES" >> /etc/rc.d/rc.local
echo "#" >> /etc/rc.d/rc.local
echo "# It is highly advisable to create own systemd services or udev rules" >> /etc/rc.d/rc.local
echo "# to run scripts during boot instead of using this file." >> /etc/rc.d/rc.local
echo "#" >> /etc/rc.d/rc.local
echo "# In contrast to previous versions due to parallel execution during boot" >> /etc/rc.d/rc.local
echo "# this script will NOT be run after all other services." >> /etc/rc.d/rc.local
echo "#" >> /etc/rc.d/rc.local
echo "# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure" >> /etc/rc.d/rc.local
echo "# that this script will be executed during boot." >> /etc/rc.d/rc.local
echo "">> /etc/rc.d/rc.local

# If you need close firewall, remove comment.
#chmod +x /etc/rc.d/rc.local
#echo "systemctl stop firewalld" >> /etc/rc.d/rc.local

# Disable SELinux.
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# Backup bashrc file.
\cp -f /etc/bashrc /etc/bashrc.original

# Comment original prompt config.
sed -i '45 s/  /   #/g' /etc/bashrc

# Add new prompt config.
sed -i '45a [ "$PS1" = "\\\\\s-\\\\\/v\\\\\\$ " ] && PS1="\\[\\e[0;91m\\][\\[\\e[0m\\]\\[\\e[0;92m\\]\\u\\[\\e[0m\\]\\[\\e[0;94m\\]@\\h\\[\\e[0m\\] \\[\\e[0;93m\\]\\W/\\[\\e[0m\\]\\[\\e[0;91m\\]]\\[\\e[0m\\]\\[\\e[0;93m\\]\\\\\$\\[\\e[0m\\] "' /etc/bashrc

sed -i '46 s/^/    /' /etc/bashrc

sed -i '46 s/\/v/v/' /etc/bashrc

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

dnf install -y vim screen bash-completion net-tools wget

dnf update -y

dnf upgrade -y

init 6

