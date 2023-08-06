#!/bin/bash

# script executed at a cluster member (ansible controller) assuming initial user(devops) has alreaydy been setup
sudo -H -u devops bash -c '

if [ -d "/home/devops/ansible-testbed" ] 
then
    echo "--------cloud-brix files will be updated"
    cd /home/devops/ansible-testbed
    git pull
    cd /home/devops/
else
    echo "--------updating source files"
    git clone https://github.com/corpdesk/ansible-testbed.git
fi

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

'
