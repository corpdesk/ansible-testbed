#!/bin/bash
# sudo sh setup_initial_user.sh
# INSTALL ANSIBLE SERVER REQUIREMENTS
# sudo useradd -m -s /bin/bash devops
echo "creating devops user (non-inteructive, with preset hushed password):"
sudo useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash devops
echo "escalate the devops to sudoer:"
usermod -aG sudo devops
sudo id devops
echo "switch to devops user:"
su -c devops
echo "move to devops home dir:"
cd ~/
echo "current directory:"
pwd
# useradd -m -s /bin/bash -p
# useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash devops

# ansible-playbook playbook03.yml
