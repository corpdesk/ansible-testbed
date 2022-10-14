#!/bin/bash

# variables:
# - remote_user
# - remote_password

sudo sh reset_environment.sh
# INSTALL ANSIBLE SERVER REQUIREMENTS
sudo apt install ansible sshpass -y

# SETUP INITIAL USER
sudo sh setup_initial_user.sh

# echo "switch to devops user:"
# su - devops -c "cd /home/devops"
# echo "current directory:"
# su - devops -c "pwd"


printf "\nStart 1st su:"
sudo sh setup_nfs_server.sh
sudo sh setup_pub_cert.sh -n id_rsa -d /var/nfs/p_key
printf "\nEnd 1st su:\n"



# su - devops -c "ansible app2 -m ping"
# ansible app2 -m ping
# ansible-playbook playbook03.yml
ansible app2 --extra-vars "ansible_user=devops ansible_password=yU0B14NC1PdE" -m ping
# ansible-playbook -i hosts.ini install-vagrant.yaml -kK -vvv
# on physical host servers, copy vagrant directory in devops directory
#   - set ips for given host
#   - Vagrantfile with allocated ips
# run vagrant up
# setup mysql
#   - mysql-servers
#   - mysql-shell
#   - operator
# setup gluster file system
# setup redis cluster
# setup node.js
#   - load-balancer 
#   - queue
#   - with mysql-router
# setup angular cluster
#   - with loadbalancer



