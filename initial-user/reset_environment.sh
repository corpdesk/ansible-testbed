#!/bin/bash

# git clone https://github.com/georemo/ansible-testbed.git
# update execution codes
# git pull https://georemo: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@github.com/georemo/ansible-testbed.git
# git pull https://username:password@git_hostname.com/my/repository
sudo apt update -y
sudo sh remove_devops.sh
sudo mkdir /home/devops/vagrant-deploy
sudo chmod -R 755 /home/devops/vagrant-deploy
chown -R devops /home/devops/vagrant-deploy

# allow rsync
sudo ufw allow from 192.168.1.0/24 to any port 873

# Reset: remove previous versions
# sudo rm /var/nfs/p_key/ansibleServer.pub
# sudo rm /home/ubuntu/.ssh/ansibleServer.pub
# sudo rm /root/.ssh/ansibleServer.pub

# Disable Password Authentication before applying ssh-copy-id  
# The #? is an extended regular expression that matches the line whether it's commented or not. 
# The -E switch enables extended regexp support for sed.
# sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo apt install openssh-server  -y
sudo service ssh restart
sudo ufw allow from 192.168.1.0/24 to any port 22
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sudo sed -i -E 's/#?PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i -E 's/#?ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i -E 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i -E 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh




