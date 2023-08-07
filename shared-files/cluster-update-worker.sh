#!/bin/bash
# executed at the physical machine

operator="devops"
clusterMember="routed-93"
echo "."
echo "."
echo "."
echo "--------$(hostname)/STARTING cluster-update-worker.sh"
echo "--------$(hostname)/cluster-update-worker.sh: executing at the cluster member $clusterMember"
echo "--------$(hostname)/cluster-update-worker.sh: setting up initial user for $clusterMember"
echo "--------$(hostname)/cluster-update-worker.sh: check if cluster-init-user.sh is avilable"
ls -la /home/devops/.cb/
git config --global --add safe.directory /home/devops/ansible-testbed
sh /home/devops/.cb/cluster-init-user.sh
if [ -d "/home/$operator/ansible-testbed" ] 
then
    echo "--------$(hostname)/cluster-update-worker.sh: cloud-brix files for $clusterMember will be updated"
    cd /home/$operator/ansible-testbed
    git fetch --all
    cd /home/$operator/
else
    echo "--------$(hostname)/cluster-update-worker.sh: updating source files for $clusterMember"
    cd /home/$operator/
    git clone https://github.com/corpdesk/ansible-testbed.git
fi

# for i in {1..3}
count=3
i=0;
while [ "$i" -lt $count ]
do
    j=$(($i + 1))
    sudo lxc exec cd-db-0$j -- rm -f /home/devops/.cb/worker-init-user.sh
    sudo lxc exec cd-db-0$j -- rm -f /home/devops/.cb/mysql-shell-scripts/init_cluster.js
    sudo lxc exec cd-db-0$j -- rm -f /home/devops/.cb/mysql-shell-scripts/build_cluster.js
    echo "--------$(hostname)/cluster-update-worker.sh: pushing shared-files/worker-pre-init-user.sh from $clusterMember to cd-db-0$j"
    lxc file push home/$operator/.cb/worker-pre-init-user.sh  cd-db-0$j/home/$operator/.cb/worker-pre-init-user.sh
    sudo lxc exec cd-db-0$j -- sh /tmp/.cb/worker-init-user.sh
    echo "--------$(hostname)/cluster-update-worker.sh: pushing shared-files/p from $clusterMember to cd-db-0$j"
    lxc file push /home/$operator/.cb/p                        cd-db-0$j/home/$operator/.cb/p
    echo "--------$(hostname)/cluster-update-worker.sh: pushing worker-init-user.sh from $clusterMember to cd-db-0$j"
    lxc file push /home/$operator/.cb/worker-init-user.sh      cd-db-0$j/home/$operator/.cb/worker-init-user.sh
    echo "--------$(hostname)/cluster-update-worker.sh: setting up initial user at cd-db-0$j"
    sudo lxc exec cd-db-0$j -- sh /tmp/.cb/worker-init-user.sh
    echo "--------$(hostname)/cluster-update-worker.sh: pushing init_cluster.js from $clusterMember to cd-db-0$j"
    sudo lxc file push /home/devops/.cb/mysql-shell-scripts/init_cluster.js             cd-db-0$j/home/devops/.cb/mysql-shell-scripts/init_cluster.js
    echo "--------$(hostname)/cluster-update-worker.sh: pushing init_build_cluster.js from $clusterMember to cd-db-0$j"
    sudo lxc file push /home/devops/.cb/mysql-shell-scripts/build_cluster.js            cd-db-0$j/home/devops/.cb/mysql-shell-scripts/build_cluster.js
    i=$(($i + 1))
done