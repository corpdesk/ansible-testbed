#!/bin/bash

echo "."
echo "."
echo "."
echo "--------$(hostname)/STARTING ssh-copy-id.sh"
echo "--------$(hostname)/cluster-init-user.sh: whoami: $(whoami)"
cname=$1
echo "--------$(hostname)/ssh-copy-id.sh: ssh-copy-id for $cname"
cip=$(sudo lxc list -c4 --format csv $cname | cut -d' ' -f1)
# cip=$(sudo lxc list "a1" -c 4 | awk '!/IPV4/{ if ( $2 != "" ) print $2}')
echo "--------$(hostname)/ssh-copy-id.sh: $cname ip address is $cip"
export CIP=$cip
# echo "ip for $cname is $cip"
# ssh-copy-id -i /home/devops/.ssh/id_rsa.pub devops@$cip
echo "--------$(hostname)/ssh-copy-id.sh: current directory $(pwd)"
sudo -H -u devops bash -c '

if [ -f "/home/devops/.ssh/id_rsa" ] 
then
    echo "--------cluster-init-user.sh: ssh keys already exists"
else
    echo "--------cluster-init-user.sh: creating ssh keys"
    # ssh-keygen -t rsa -b 2048 -f /home/devops/.ssh/id_rsa -q -N ""
    sh /home/devops/.cb/ssh-key.sh devops
fi
echo "cmd: sshpass -f /home/devops/.cb/p ssh-copy-id -i /home/devops/.ssh/id_rsa.pub devops@$CIP"
sshpass -f "/home/devops/.cb/p" ssh-copy-id -i /home/devops/.ssh/id_rsa.pub devops@$CIP
'


