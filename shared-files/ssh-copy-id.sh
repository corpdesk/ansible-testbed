#!/bin/bash

cname=$1
cip=$(sudo lxc list -c4 --format csv $cname | cut -d' ' -f1)
# cip=$(sudo lxc list "a1" -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')
echo "ip for $cname is $cip"
# ssh-copy-id -i /home/devops/.ssh/id_rsa.pub devops@$cip
echo "this host $(hostname)"
echo "current directory $(pwd)"
sshpass -f "/tmp/p" ssh-copy-id -i /home/devops/.ssh/id_rsa.pub devops@$cip


