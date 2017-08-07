#!/bin/bash

systemctl disable firewalld

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
echo "">> /etc/rc.d/rc.local && chmod +x /etc/rc.d/rc.local

echo "systemctl stop firewalld" >> /etc/rc.d/rc.local

sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

dnf install -y vim screen

dnf update -y

dnf upgrade -y

mv /etc/bashrc /etc/bashrc.bak

\cp -f bashrc /etc/

source /etc/bashrc

init 6

