#!/bin/bash

# use this on physical machine to update files
bash -c '
# executed at the physical machine
echo "--------executing at the physical machine"
adminUser="emp-09"
operator="devops"
clusterMember="routed-93"
if [ -d "/home/$adminUser/ansible-testbed" ] 
then
    echo "--------cloud-brix files will be updated"
    cd /home/$adminUser/ansible-testbed
    git pull
    cd /home/$adminUser/
else
    echo "--------updating source files"
    git clone https://github.com/corpdesk/ansible-testbed.git
fi
echo "--------moving cluster-update-dirs.sh to controller machine"
lxc file push /home/$adminUser/ansible-testbed/shared-files/cluster-update-dirs.sh $clusterMember/home/$operator/.cb/cluster-update-dirs.sh
echo "--------updating cluser member directories"
lxc exec $clusterMember -- sh /home/$operator/.cb/cluster-update-dirs.sh
echo "--------pushing cluster-init-user.sh from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/cluster-init-user.sh    $clusterMember/home/$operator/.cb/cluster-init-user.sh
echo "--------pushing worker-init-user.sh from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/worker-init-user.sh     $clusterMember/home/$operator/.cb/worker-init-user.sh
echo "--------pushing shared-files/p from $adminUser to $clusterMember"
lxc file push /home/$adminUser/ansible-testbed/shared-files/p                       $clusterMember/home/$operator/.cb/p
'
