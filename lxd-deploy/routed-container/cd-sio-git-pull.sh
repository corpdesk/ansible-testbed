#!/bin/bash

lxc exec cd-sio-93 -- sudo -H -u devops bash -c '
cd /home/devops/cd-sio
pwd
git pull
'