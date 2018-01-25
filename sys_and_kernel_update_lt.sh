#!/bin/bash

yum update -y

yum upgrade -y

# Update longterm kernel
yum -y --enablerepo=elrepo-kernel install kernel-lt

grub2-set-default 0

init 6

