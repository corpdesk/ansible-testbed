#!/bin/bash

lxc exec cd-api-92 -- sudo -H -u devops bash -c '
cd /home/devops/cd-api
pwd
git pull
'

lxc exec cd-sio-93 -- sudo -H -u devops bash -c '
cd /home/devops/cd-sio
pwd
git pull
'