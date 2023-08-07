#!/bin/bash

# script executed at a cluster member (ansible controller) assuming initial user(devops) has alreaydy been setup
echo "."
echo "."
echo "."
echo "--------STARTING cluster-init-user.sh"
echo "--------cluster-init-user.sh: executing at $(hostname)"
sudo -H -u devops bash -c '
echo "--------cluster-init-user.sh: executing at $(hostname)"
echo "--------cluster-init-user.sh: starting post initial user creation"
echo "--------cluster-init-user.sh: initial user: $USER, uid=$UID"

cd ~
if [ -f "/home/devops/.ssh/id_rsa" ] 
then
    echo "--------cluster-init-user.sh: ssh keys already exists"
else
    echo "--------cluster-init-user.sh: creating ssh keys"
    # ssh-keygen -t rsa -b 2048 -f /home/devops/.ssh/id_rsa -q -N ""
    sh /home/devops/.cb/ssh-key.sh devops
fi

for i in {1..3}
do
    sudo lxc exec cd-db-0$i -- rm -f /home/devops/.cb/worker-init-user.sh
    sudo lxc exec cd-db-0$i -- rm -f /home/devops/.cb/mysql-shell-scripts/init_cluster.js
    sudo lxc exec cd-db-0$i -- rm -f /home/devops/.cb/mysql-shell-scripts/build_cluster.js
    sudo lxc exec cd-db-0$i -- sh /tmp/.cb/worker-init-user.sh
    sudo lxc file push /home/devops/.cb/mysql-shell-scripts/init_cluster.js cd-db-0$i/home/devops/.cb/mysql-shell-scripts/init_cluster.js
    sudo lxc file push /home/devops/.cb/mysql-shell-scripts/build_cluster.js cd-db-0$i/home/devops/.cb/mysql-shell-scripts/build_cluster.js
    sh /home/devops/ansible-testbed/shared-files/ssh-copy-id.sh cd-db-0$i
done
rm -f /home/devops/.cb/p
'

