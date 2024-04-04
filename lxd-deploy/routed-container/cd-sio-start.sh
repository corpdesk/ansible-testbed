#!/bin/bash

# cd-api start
lxc exec cd-sio-93 -- sudo -H -u devops bash -c '
cd /home/devops/cd-api
npm install @socket.io/redis-adapter
npm start
'


