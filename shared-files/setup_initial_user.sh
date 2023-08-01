#!/bin/bash
# To run: sudo sh setup_initial_user.sh

# reset environment
sudo sh /tmp/reset_environment.sh

# INSTALL ANSIBLE SERVER REQUIREMENTS


# check if devops dir exits
if [ -d "/home/devops/" ] 
then
    echo "user devops esists" 
    sleep 0
else
    # sudo useradd -m -s /bin/bash devops
    echo "creating devops user (non-inteructive, with preset hushed password):"
    sudo useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash devops
    sudo mkdir -p /home/devops/.ssh
    sudo chown devops /home/devops/.ssh
    sudo chmod 700 /home/devops/.ssh
    echo "escalate the devops to sudoer:"
    usermod -aG sudo devops
    sudo id devops
    # no password for devops as a sudoer
    sudo echo "devops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    # useradd -m -s /bin/bash -p
    # useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash devops

    sudo mkdir /home/devops/vagrant-deploy
    sudo chmod -R 755 /home/devops/vagrant-deploy
    chown -R devops /home/devops/vagrant-deploy
fi


# ansible-playbook playbook03.yml
