#!/bin/bash

# update execution codes
# git pull https://georemo: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@github.com/georemo/ansible-testbed.git
# git pull https://username:password@git_hostname.com/my/repository

# Reset: remove previous versions
# sudo rm /var/nfs/p_key/ansibleServer.pub
# sudo rm /home/ubuntu/.ssh/ansibleServer.pub
# sudo rm /root/.ssh/ansibleServer.pub

# Disable Password Authentication before applying ssh-copy-id  
# The #? is an extended regular expression that matches the line whether it's commented or not. 
# The -E switch enables extended regexp support for sed.
sudo sed -i -E 's/#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
