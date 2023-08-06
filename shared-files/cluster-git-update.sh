#!/bin/bash

# sudo -H -u devops bash -c '
# if [ -d "/home/devops/ansible-testbed" ] 
# then
#     echo "--------cloud-brix files will be updated"
#     cd /home/devops/ansible-testbed
#     git pull
#     cd /home/devops/
# else
#     echo "--------seting up initial user cb work space"
#     git clone https://github.com/corpdesk/ansible-testbed.git
# fi

# cp -f /home/devops/ansible-testbed/shared-files/cluster-update-files.sh /home/devops/.cb/cluster-update-files.sh
# '



bash -c '
# emp-09@192.168.0.9
if [ -d "/home/emp-09/ansible-testbed" ] 
then
    echo "--------cloud-brix files will be updated"
    cd /home/emp-09/ansible-testbed
    git pull
    cd /home/emp-09/
else
    echo "--------updating source files"
    git clone https://github.com/corpdesk/ansible-testbed.git
fi

lxc file push /home/devops/ansible-testbed/shared-files/cluster-update-files.sh routed-93/home/devops/.cb/cluster-update-files.sh
'


