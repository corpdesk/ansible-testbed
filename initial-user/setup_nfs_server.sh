#!/bin/bash

# variables:
# inventory array or subnet specification nfs, shared dir: /var/nfs/p_key
sudo apt update
sudo apt install nfs-kernel-server -y
sudo mkdir /var/nfs/p_key -p
sudo chown nobody:nogroup /var/nfs/p_key
# nfs config
# NB: replace 192.168.1.0/24 with valid ip or subnet based on target inventory

b=$(sudo grep -c '/var/nfs/p_key 192.168.1.0/24(rw,sync,no_subtree_check)' /etc/exports)
if [ "$b" -gt 0 ]
then
    echo "nfs config already exits"
else
    echo "entering new nfs config"
    sudo echo '/var/nfs/p_key 192.168.1.0/24(rw,sync,no_subtree_check)' >> /etc/exports
fi
sudo systemctl restart nfs-kernel-server
# firewall setting
# NB: replace 192.168.1.0/24 with valid ip or subnet based on target inventory
sudo ufw allow from 192.168.1.0/24 to any port nfs


