#!/bin/bash
# To run: sudo sh setup_initial_user.sh

# reset environment
sudo sh /tmp/reset_environment.sh
initialUser="devops"
pswd="yU0B14NC1PdE"


# INSTALL ANSIBLE SERVER REQUIREMENTS


# check if $initialUser dir exits
if [ -d "/home/$initialUser/" ] 
then
    echo "user $initialUser esists" 
    sleep 0
else
    # sudo useradd -m -s /bin/bash $initialUser
    echo "creating $initialUser user (non-inteructive, with preset hushed password):"
    # sudo useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash $initialUser
    useradd -m -p $(openssl passwd -1 $pswd) $initialUser
    echo "escalate the $initialUser to sudoer:"
    usermod -aG sudo $initialUser
    sudo id $initialUser
    # no password for $initialUser as a sudoer
    sudo echo "$initialUser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    # useradd -m -s /bin/bash -p
    # useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash $initialUser
    sudo mkdir -p /home/$initialUser/.ssh
    sudo ssh-keygen -t rsa -b 2048 -f /home/$initialUser/.ssh/id_rsa -q -N ""
    sudo chown $initialUser /home/$initialUser/.ssh
    sudo chmod -R 700 /home/$initialUser/.ssh
    sudo mkdir /home/$initialUser/vagrant-deploy
    sudo chmod -R 755 /home/$initialUser/vagrant-deploy
    chown -R $initialUser /home/$initialUser/vagrant-deploy
    
fi


# ansible-playbook playbook03.yml
