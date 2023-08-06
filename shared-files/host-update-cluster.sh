#!/bin/bash

bash -c '
# executed at the physical machine
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

lxc file push /home/$adminUser/ansible-testbed/shared-files/cluster-update-files.sh $clusterMember/home/$operator/.cb/cluster-update-files.sh
'