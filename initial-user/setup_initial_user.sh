#!/bin/bash
# To run: sudo sh setup_initial_user.sh

# reset environment
sudo sh reset_environment.sh

# INSTALL ANSIBLE SERVER REQUIREMENTS
# sudo useradd -m -s /bin/bash devops
echo "creating devops user (non-inteructive, with preset hushed password):"
sudo useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash devops
echo "escalate the devops to sudoer:"
usermod -aG sudo devops
sudo id devops
# useradd -m -s /bin/bash -p
# useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash devops

sudo mkdir /home/devops/vagrant-deploy
sudo chmod -R 755 /home/devops/vagrant-deploy
chown -R devops /home/devops/vagrant-deploy


# ansible-playbook playbook03.yml
