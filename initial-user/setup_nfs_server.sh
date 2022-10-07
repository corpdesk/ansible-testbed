#!/bin/bash

# variables:
# inventory array or subnet specification nfs, shared dir: /var/nfs/p_key
sudo apt update
sudo apt install nfs-kernel-server -y
sudo mkdir /var/nfs/p_key -p
sudo chown nobody:nogroup /var/nfs/p_key
# nfs config
# NB: replace 192.168.1.0/24 with valid ip or subnet based on target inventory
sudo echo '/var/nfs/p_key 192.168.1.0/24(rw,sync,no_subtree_check)' >> /etc/exports
sudo systemctl restart nfs-kernel-server
# firewall setting
# NB: replace 192.168.1.0/24 with valid ip or subnet based on target inventory
sudo ufw allow from 192.168.1.0/24 to any port nfs


