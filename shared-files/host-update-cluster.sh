#!/bin/bash

# use this on physical machine to update files
bash -c '
# executed at the physical machine
echo "."
echo "."
echo "."
echo "--------STARTING host-update-cluster.sh"
echo "--------host-update-cluster.sh: executing at the physical machine"
adminUser="emp-09"
operator="devops"
clusterMember="routed-93"
if [ -d "/home/$adminUser/ansible-testbed" ] 
then
    echo "--------host-update-cluster.sh: cloud-brix files for $adminUser will be updated"
    cd /home/$adminUser/ansible-testbed
    git pull
    cd /home/$adminUser/
else
    echo "--------host-update-cluster.sh: updating source files for $adminUser"
    git clone https://github.com/corpdesk/ansible-testbed.git
fi


echo "--------host-update-cluster.sh: pushing shared-files/worker-pre-init-user.sh from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/worker-pre-init-user.sh  $clusterMember/home/$operator/.cb/worker-pre-init-user.sh
echo "--------host-update-cluster.sh: pushing shared-files/cluster-init-user.sh from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/cluster-init-user.sh   $clusterMember/home/$operator/.cb/cluster-init-user.sh 
echo "--------host-update-cluster.sh: pushing shared-files/p from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/p                        $clusterMember/home/$operator/.cb/p
echo "--------host-update-cluster.sh: pushing shared-files/cluster-update-worker.sh from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/cluster-update-worker.sh $clusterMember/home/$operator/.cb/cluster-update-worker.sh
echo "--------host-update-cluster.sh: moving cluster-update-dirs.sh to controller machine"
lxc file push /home/$adminUser/ansible-testbed/shared-files/cluster-update-dirs.sh   $clusterMember/home/$operator/.cb/cluster-update-dirs.sh
echo "--------host-update-cluster.sh: updating $clusterMember directories"

sh /home/$adminUser/ansible-testbed/shared-files/cluster-update-dirs.sh

echo "--------host-update-cluster.sh: pushing init_cluster.js from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/init_cluster.js     cd-db-0$i/home/devops/.cb/mysql-shell-scripts/init_cluster.js
echo "--------host-update-cluster.sh: pushing init_build_cluster.js from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/build_cluster.js    cd-db-0$i/home/devops/.cb/mysql-shell-scripts/build_cluster.js
echo "--------host-update-cluster.sh: pushing worker-init-user.sh from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/worker-init-user.sh      $clusterMember/home/$operator/.cb/worker-init-user.sh
lxc exec $clusterMember -- sh /home/$operator/.cb/cluster-update-worker.sh
'
