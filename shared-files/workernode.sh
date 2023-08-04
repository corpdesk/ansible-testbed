#!/bin/bash

apt update && apt upgrade -y
rm -fr ansible-testbed
deluser devops
rm -r -f /home/devops
# add devops user
useradd -m -p $(openssl passwd -1 yU0B14NC1PdE) devops
# escalate devops to sudoer
usermod -aG sudo devops
cp /etc/sudoers /etc/sudoers.backup
# suppress password prompt on switch to user
bash -c 'echo "devops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
# enable password authentication for ssh connection
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sed -i -E 's/#?PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh 