#!/bin/bash

yum update -y

yum upgrade -y

# Update mainline kernel
yum -y --enablerepo=elrepo-kernel install kernel-ml

grub2-set-default 0

init 6

