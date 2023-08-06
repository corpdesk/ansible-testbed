#!/bin/bash

sudo deluser devops
sudo rm -r -f /home/devops
# add devops user
sudo useradd -m -p $(openssl passwd -1 yU0B14NC1PdE) devops
if [ -d "/home/devops/.cb/mysql-shell-scripts/" ] 
then
    echo "--------/home/devops/.cb/mysql-shell-scripts/ dir exists"
else
    echo "--------creating new .cb/mysql-shell-scriptsdir"
    mkdir -p /home/devops/.cb/mysql-shell-scripts/
fi
sudo chmod -R 755 /home/devops/
# escalate devops to sudoer
sudo usermod -aG sudo devops
sudo cp /etc/sudoers /etc/sudoers.backup
# suppress password prompt on switch to user
sudo bash -c 'echo "devops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
# enable password authentication for ssh connection
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sudo sed -i -E 's/#?PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh
for i in {1..3}
do
    sh /home/devops/ansible-testbed/shared-files/ssh-copy-id.sh cd-db-0$i
done
