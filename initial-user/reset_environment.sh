#!/bin/bash

# update execution codes
git pull

# Reset: remove previous versions
sudo rm /var/nfs/p_key/ansibleServer.pub
sudo rm /home/ubuntu/.ssh/ansibleServer.pub
sudo rm /root/.ssh/ansibleServer.pub