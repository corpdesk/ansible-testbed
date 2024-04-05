#!/bin/bash



# cd-api start
lxc exec c1 -- sudo -H -u devops bash -c '
cd /home/devops/cd-api
npm install @socket.io/redis-adapter
npm start
'


