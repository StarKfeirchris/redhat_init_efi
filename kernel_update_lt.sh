#!/bin/bash

yum --exclude=kernel update -y

yum --exclude=kernel upgrade -y

# Update longterm kernel
yum -y --enablerepo=elrepo-kernel install kernel-lt

grub2-set-default 0

# Reboot system.
read -p "Longterm kernel update succeed, do you want to reboot?(yes or no) " reboot

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

