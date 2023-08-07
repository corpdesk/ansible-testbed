#!/bin/bash

echo "."
echo "."
echo "."
echo "--------$(hostname)/STARTING ssh-copy-id.sh"
cname=$1
echo "--------$(hostname)/ssh-copy-id.sh: ssh-copy-id for $cname"
cip=$(sudo lxc list -c4 --format csv $cname | cut -d' ' -f1)
# cip=$(sudo lxc list "a1" -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')
echo "--------$(hostname)/ssh-copy-id.sh: $cname ip address is $cip"
# echo "ip for $cname is $cip"
# ssh-copy-id -i /home/devops/.ssh/id_rsa.pub devops@$cip
echo "--------$(hostname)/ssh-copy-id.sh: current directory $(pwd)"
sshpass -f "/home/devops/.cb/p" ssh-copy-id -i /home/devops/.ssh/id_rsa.pub devops@$cip


