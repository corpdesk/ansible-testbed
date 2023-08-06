#!/bin/bash

# script executed at a cluster member (ansible controller) assuming initial user(devops) has alreaydy been setup
sudo -H -u devops bash -c '

if [ -d "/home/devops/.cb" ] 
then
    echo "--------.cb dir exists"
else
    echo "--------creating new .cb dir"
    mkdir .cb
fi


if [ -d "/home/devops/.cb/mysql-shell-scripts/" ] 
then
    echo "--------/home/devops/.cb/mysql-shell-scripts/ dir exists"
else
    echo "--------creating new .cb/mysql-shell-scriptsdir"
    mkdir -p /home/devops/.cb/mysql-shell-scripts/
fi

cp -f /home/devops/ansible-testbed/shared-files/cluster-init-user.sh /home/devops/.cb/cluster-init-user.sh
cp -f /home/devops/ansible-testbed/shared-files/worker-init-user.sh /home/devops/.cb/worker-init-user.sh
cp -f /home/devops/ansible-testbed/shared-files/build_cluster.js /home/devops/.cb/mysql-shell-scripts/build_cluster.js
cp -f /home/devops/ansible-testbed/shared-files/init_cluster.js /home/devops/.cb/mysql-shell-scripts/init_cluster.js
cp -f /home/devops/ansible-testbed/shared-files/p /home/devops/.cb/p

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
