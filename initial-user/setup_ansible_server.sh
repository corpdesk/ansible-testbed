#!/bin/bash

# variables:
# - remote_user
# - remote_password

sudo sh reset_environment.sh
# INSTALL ANSIBLE SERVER REQUIREMENTS
sudo apt upgrade -y
sudo apt install ansible sshpass -y

# SETUP INITIAL USER
sudo sh setup_initial_user.sh

# echo "switch to devops user:"
# su - devops -c "cd /home/devops"
# echo "current directory:"
# su - devops -c "pwd"

printf "\nStart 1st su:"
# echo 'yU0B14NC1PdE' | su - devops -c "sudo sh setup_pub_cert.sh -n id_rsa -d /var/nfs/p_key"
sudo sh setup_pub_cert.sh -n id_rsa -d /var/nfs/p_key
printf "\nEnd 1st su:\n"

# su - devops -c "ansible app2 -m ping"
# ansible app2 -m ping
# ansible-playbook playbook03.yml
# ansible app2 --extra-vars "ansible_user=devops ansible_password=yU0B14NC1PdE" -m ping -vvv

