#!/bin/bash

# to be able to ssh into host use below codes:
sudo apt update -y
sudo apt-get install git net-tools openssh-server tree fish jq  -y
sudo service ssh restart
# allow ssh connections
sudo ufw allow from 192.168.1.0/24 to any port 22
# allow lxd heartbeats
sudo ufw allow from 192.168.1.0/24 to any port 8443
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sudo sed -i -E 's/#?PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i -E 's/#?ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i -E 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i -E 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh
