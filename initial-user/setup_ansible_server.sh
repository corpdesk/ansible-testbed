#!/bin/bash
# INSTALL ANSIBLE SERVER REQUIREMENTS
#   - variable input for setup_nfs_server.sh:
#   - inventory array or subnet specification nfs, $shared_dir=/var/nfs/p-key
#   - ssh file name: $ssh_key_name=id_rsa_ansible
sh setup_nfs_server.sh
# create ssh key pair
ssh-keygen -t rsa -b 2048 -f ~/.ssh/$ssh_key_name -q -N ""
# copy the generated public file to shared directory for target inventory servers
cp ~/.ssh/$ssh_key_name.pub $shared_dir/$ssh_key_name.pub 
# SETUP INVENTORY
# SET INITIAL USER:
#   - cd ansible-testbed/initial-user
#   - ansible-playbook playbook03.yml
#     EXIT
