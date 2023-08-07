#!/bin/bash

echo "."
echo "."
echo "."
echo "--------STARTING cluster-init-user.sh"
echo "--------$(hostname)/cluster-init-user.sh: executing at $(hostname)"

if [ -d "/home/devops/" ] 
then
    echo "--------$(hostname)/cluster-init-user.sh: /home/devops/ dir exists"
else
    echo "--------$(hostname)/cluster-init-user.sh: removing user devops"
    sudo deluser devops
    sudo rm -r -f /home/devops
    # add devops user
    echo "--------$(hostname)/cluster-init-user.sh: adding user devops"
    sudo useradd -m -p $(openssl passwd -1 yU0B14NC1PdE) devops
fi

if [ -d "/home/devops/.cb/mysql-shell-scripts/" ] 
then
    echo "--------$(hostname)/cluster-init-user.sh: /home/devops/.cb/mysql-shell-scripts/ dir exists"
else
    echo "--------$(hostname)/cluster-init-user.sh: creating new .cb/mysql-shell-scriptsdir"
    mkdir -p /home/devops/.cb/mysql-shell-scripts/
fi
echo "--------$(hostname)/cluster-init-user.sh: setting devops profile"
sudo chmod -R 755 /home/devops/
# escalate devops to sudoer
sudo usermod -aG sudo devops
sudo cp /etc/sudoers /etc/sudoers.backup
# suppress password prompt on switch to user
sudo bash -c 'echo "devops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
echo "--------$(hostname)/cluster-init-user.sh: setting up ssh access"
# enable password authentication for ssh connection
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sudo sed -i -E 's/#?PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# for i in {1..3}
count=3
i=0
while [ $i -lt $count ]
do
    j=$(($i + 1))
    echo "--------$(hostname)/cluster-init-user.sh: ssh-copy-id to cd-db-0$j"
    sh /home/devops/ansible-testbed/shared-files/ssh-copy-id.sh cd-db-0$j
    i=$(($i + 1))
done
