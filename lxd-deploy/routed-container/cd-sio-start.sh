#!/bin/bash

lxc stop cd-db-91
sleep 2
lxc start cd-db-91
sleep 5
lxc stop cd-sio-93
sleep 2
lxc start cd-sio-93
sleep 5


# cd-sio start
lxc exec cd-sio-93 -- sudo -H -u devops bash -c '
cd /home/devops/cd-sio
pwd
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
npm install @socket.io/redis-adapter
npm start
'


