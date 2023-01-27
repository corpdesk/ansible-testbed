#!/bin/bash

# variables:
nfsSharePath="/var/nfs/share"
osPath="~/os/bento-VAGRANTSLASH-ubuntu-22.04"
# inventory array or subnet specification nfs, shared dir: /var/nfs/share
sudo apt update
sudo apt install nfs-kernel-server -y
# create directory if it does not exits
if [ -d $nfsSharePath ] 
then
    echo "Directory $nfsSharePath exists. Moving on..." 
else
    echo "Creating nfs server share directory: $nfsSharePath"
    sudo mkdir $nfsSharePath -p
    sudo chown nobody:nogroup $nfsSharePath
    # check if ubuntu-box exists, if not download
    if [ -d "/path/to/dir" ] 
    then
        echo "check vlidity of file" 
        echo "check vlidity of file"
    else
        echo "Download the file."
        sudo mkdir -p ~/os
        # wget -O ~/os/  https://app.vagrantup.com/bento/boxes/ubuntu-22.04/versions/202206.03.0/providers/virtualbox.box
    fi

fi


# nfs config
# NB: replace 192.168.1.0/24 with valid ip or subnet based on target inventory

b=$(sudo grep -c '/var/nfs/share 192.168.1.0/24(rw,sync,no_subtree_check)' /etc/exports)
if [ "$b" -gt 0 ]
then
    echo "nfs config already exits"
else
    echo "entering new nfs config"
    sudo echo '/var/nfs/share 192.168.1.0/24(rw,sync,no_subtree_check)' >> /etc/exports
fi
sudo systemctl restart nfs-kernel-server
# firewall setting
# NB: replace 192.168.1.0/24 with valid ip or subnet based on target inventory
sudo ufw allow from 192.168.1.0/24 to any port nfs


