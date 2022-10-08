#!/bin/bash
# sudo sh setup_initial_user.sh
# INSTALL ANSIBLE SERVER REQUIREMENTS
# sudo useradd -m -s /bin/bash devops
sudo adduser devops
usermod -aG sudo devops
sudo id devops
su -c devops
# useradd -m -s /bin/bash -p
# useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash devops

# ansible-playbook playbook03.yml
