#!/bin/bash

echo "."
echo "."
echo "."
echo "--------$(hostname)/STARTING cluster-init-user.sh"
echo "--------$(hostname)/cluster-init-user.sh: whoami: $(whoami)"

echo "--------$(hostname)/cluster-init-user.sh: system update"
sudo sh /tmp/pre-init-user.sh

if [ -d "/home/devops/" ] 
then
    echo "--------$(hostname)/cluster-init-user.sh: /home/devops/ dir exists"
else
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

if [ -d "/home/$adminUser/ansible-testbed" ] 
then
    echo "--------$(hostname)/host-update-cluster.sh: cloud-brix files for $adminUser will be updated"
    cd /home/$adminUser/ansible-testbed
    sudo -H -u devops bash -c 'git fetch --all'
    cd /home/$adminUser/
else
    echo "--------$(hostname)/host-update-cluster.sh: updating source files for $adminUser"
    # git clone https://github.com/corpdesk/ansible-testbed.git
    sudo -H -u devops bash -c 'git clone https://github.com/corpdesk/ansible-testbed.git'
fi



# ----------------------------------------------
# initialize worker node

# for i in {1..3}
count=3
i=0
while [ $i -lt $count ]
do
    j=$(($i + 1))
    echo "--------$(hostname)/cluster-init-user.sh: pushing pre-init-user.sh from cluster member to cd-db-0$j"
    lxc file push /tmp/pre-init-user.sh  cd-db-0$j/tmp/pre-init-user.sh
    echo "--------$(hostname)/cluster-init-user.sh: pushing worker-init-user.sh from clulster member to  cd-db-0$j"
    lxc file push /tmp/worker-init-user.sh  cd-db-0$j/tmp/worker-init-user.sh
    echo "--------$(hostname)/cluster-init-user.sh: running pre-init-user.sh on cd-db-0$j"
    lxc exec cd-db-0$j -- sh /tmp/pre-init-user.sh
    echo "--------$(hostname)/cluster-init-user.sh: running worker-init-user.sh cd-db-0$j"
    lxc exec cd-db-0$j -- sh /tmp/worker-init-user.sh

    # ssh copy to app container
    echo "--------$(hostname)/cluster-init-user.sh: ssh-copy-id to cd-db-0$j"
    sh /home/devops/ansible-testbed/shared-files/ssh-copy-id.sh cd-db-0$j
    i=$(($i + 1))
done
