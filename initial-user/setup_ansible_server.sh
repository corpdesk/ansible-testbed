#!/bin/bash
# INSTALL ANSIBLE SERVER REQUIREMENTS
sudo sh setup_initial_user.sh
echo "whoami:"
whomi
sudo sh setup_pub_cert.sh -n ansibleServer -d /var/nfs/p_key
sudo apt upgrade -y
sudo apt install ansible -y
echo "whoami:"
whomi
ansible 192.168.1.137 -m ping
# ansible-playbook playbook03.yml
