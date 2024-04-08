#!/bin/bash

lxc stop cd-db-91
sleep 2
lxc start cd-db-91
sleep 5
lxc stop cd-api-92
sleep 2
lxc start cd-api-92
sleep 5

# cd-api start
lxc exec cd-api-92 -- sudo -H -u devops bash -c '
cd /home/devops/cd-api
pwd
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
npm install @socket.io/redis-adapter
npm start
'


