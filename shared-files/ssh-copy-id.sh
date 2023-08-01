#!/bin/bash

cname=$1
cip=$(lxc list -c4 --format csv $cname | cut -d' ' -f1)
echo "ip for $cname is $cip"
ssh-copy-id -i /home/devops/.ssh/id_rsa.pub devops@$cip
