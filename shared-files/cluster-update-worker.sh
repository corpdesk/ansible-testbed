#!/bin/bash
# executed at the physical machine

operator="devops"
clusterMember="routed-93"
echo "."
echo "."
echo "."
echo "--------STARTING cluster-update-worker.sh"
echo "--------executing at the cluster member $clusterMember"
echo "--------setting up initial user for $clusterMember"
sh /home/devops/.cb/cluster-init-user.sh
if [ -d "/home/$operator/ansible-testbed" ] 
then
    echo "--------cloud-brix files for $clusterMember will be updated"
    cd /home/$operator/ansible-testbed
    git pull
    cd /home/$operator/
else
    echo "--------updating source files for $clusterMember"
    git clone https://github.com/corpdesk/ansible-testbed.git
fi

for i in {1..3}
do
    sudo lxc exec cd-db-0$i -- rm -f /home/devops/.cb/worker-init-user.sh
    sudo lxc exec cd-db-0$i -- rm -f /home/devops/.cb/mysql-shell-scripts/init_cluster.js
    sudo lxc exec cd-db-0$i -- rm -f /home/devops/.cb/mysql-shell-scripts/build_cluster.js
    echo "--------pushing shared-files/worker-pre-init-user.sh from $clusterMember to cd-db-0$i"
    lxc file push home/$operator/.cb/worker-pre-init-user.sh  cd-db-0$i/home/$operator/.cb/worker-pre-init-user.sh
    sudo lxc exec cd-db-0$i -- sh /tmp/.cb/worker-init-user.sh
    echo "--------pushing shared-files/p from $clusterMember to cd-db-0$i"
    lxc file push /home/$operator/.cb/p                        cd-db-0$i/home/$operator/.cb/p
    echo "--------pushing worker-init-user.sh from $clusterMember to cd-db-0$i"
    lxc file push /home/$operator/.cb/worker-init-user.sh      cd-db-0$i/home/$operator/.cb/worker-init-user.sh
    echo "--------setting up initial user at cd-db-0$i"
    sudo lxc exec cd-db-0$i -- sh /tmp/.cb/worker-init-user.sh
    echo "--------pushing init_cluster.js from $clusterMember to cd-db-0$i"
    sudo lxc file push /home/devops/.cb/mysql-shell-scripts/init_cluster.js             cd-db-0$i/home/devops/.cb/mysql-shell-scripts/init_cluster.js
    echo "--------pushing init_build_cluster.js from $clusterMember to cd-db-0$i"
    sudo lxc file push /home/devops/.cb/mysql-shell-scripts/build_cluster.js            cd-db-0$i/home/devops/.cb/mysql-shell-scripts/build_cluster.js
done