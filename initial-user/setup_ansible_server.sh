#!/bin/bash
# INSTALL ANSIBLE SERVER REQUIREMENTS
sudo sh setup_initial_user.sh

# echo "switch to devops user:"
# su - devops -c "cd /home/devops"
# echo "current directory:"
# su - devops -c "pwd"

printf "\nStart 1st su:"
echo 'yU0B14NC1PdE' | su - devops -c "sudo sh setup_pub_cert.sh -n ansibleServer -d /var/nfs/p_key"
printf "\nEnd 1st su:\n"
sudo apt upgrade -y
sudo apt install ansible -y
su - devops -c "ansible app2 -m ping"
# ansible-playbook playbook03.yml
