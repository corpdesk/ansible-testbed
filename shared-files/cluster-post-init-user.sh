#!/bin/bash

# script executed at a cluster member (ansible controller) assuming initial user(devops) has alreaydy been setup
sudo -H -u devops bash -c '
echo " ...starting post initial user creation"
echo " initial user: $USER, uid=$UID"

cd ~
if [ -f "/home/devops/.ssh/id_rsa" ] 
then
    echo "--------ssh keys already exists"
else
    echo "--------creating ssh keys"
    ssh-keygen -t rsa -b 2048 -f /home/devops/.ssh/id_rsa -q -N ""
fi'