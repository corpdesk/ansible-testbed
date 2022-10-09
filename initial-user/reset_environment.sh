#!/bin/bash

# update execution codes
git pull https://georemo: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@github.com/georemo/ansible-testbed.git
# git pull https://username:password@git_hostname.com/my/repository

# Reset: remove previous versions
sudo rm /var/nfs/p_key/ansibleServer.pub
sudo rm /home/ubuntu/.ssh/ansibleServer.pub
sudo rm /root/.ssh/ansibleServer.pub