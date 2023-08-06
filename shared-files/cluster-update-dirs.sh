#!/bin/bash

# script executed at a cluster member (ansible controller) assuming initial user(devops) has alreaydy been setup
sudo -H -u devops bash -c '
host=$(echo $hostname)
if [ -d "/home/devops/ansible-testbed" ] 
then
    echo "--------cloud-brix files will be updated at $host"
    cd /home/devops/ansible-testbed
    git pull
    cd /home/devops/
else
    echo "--------updating source files at $host"
    git clone https://github.com/corpdesk/ansible-testbed.git
fi

if [ -d "/home/devops/.cb" ] 
then
    echo "--------$host: .cb dir exists"
else
    echo "--------$host: creating new .cb dir"
    mkdir .cb
fi


if [ -d "/home/devops/.cb/mysql-shell-scripts/" ] 
then
    echo "--------$host: /home/devops/.cb/mysql-shell-scripts/ dir exists"
else
    echo "--------$host: creating new .cb/mysql-shell-scriptsdir"
    mkdir -p /home/devops/.cb/mysql-shell-scripts/
fi

'
