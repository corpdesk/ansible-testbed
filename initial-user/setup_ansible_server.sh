#!/bin/bash
# INSTALL ANSIBLE SERVER REQUIREMENTS
sudo sh setup_pub_cert.sh
sudo apt upgrade -y
sudo apt install ansible -y
ansible-playbook playbook03.yml
