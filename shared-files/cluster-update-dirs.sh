#!/bin/bash

# script executed at a cluster member (ansible controller) assuming initial user(devops) has alreaydy been setup
clusterMember="routed-93"
lxc exec $clusterMember -- sudo -H -u devops bash -c '
clusterMember="routed-93"
echo "."
echo "."
echo "."
echo "--------STARTING cluster-update-dirs.sh"
echo "--------executing at $(hostname)"
echo "--------cluster-update-dirs.sh: executing at the cluster member $clusterMember"
if [ -d "/home/devops/ansible-testbed" ] 
then
    echo "--------cluster-update-dirs.sh: cloud-brix files will be updated at $(hostname)"
    cd /home/devops/ansible-testbed
    git pull
    cd /home/devops/
else
    echo "--------cluster-update-dirs.sh: updating source files at $(hostname)"
    cd /home/devops/
    git clone https://github.com/corpdesk/ansible-testbed.git
fi

if [ -d "/home/devops/.cb" ] 
then
    echo "--------cluster-update-dirs.sh: $(hostname): .cb dir exists"
else
    echo "--------cluster-update-dirs.sh: $(hostname): creating new .cb dir"
    mkdir .cb
fi


if [ -d "/home/devops/.cb/mysql-shell-scripts/" ] 
then
    echo "--------cluster-update-dirs.sh: $(hostname): /home/devops/.cb/mysql-shell-scripts/ dir exists"
else
    echo "--------cluster-update-dirs.sh: $(hostname): creating new .cb/mysql-shell-scriptsdir"
    mkdir -p /home/devops/.cb/mysql-shell-scripts/
fi

'
