#!/bin/bash
lxc_container="cd-sio-93"
repoDir="$HOME/temp/"
app_file="cd-api.zip"
add_host_file="../../shared-files/add_host.sh"

# install npm and typescript
echo "----------------------------------------------------"
echo "INSTALL npm AND typescript"
echo "----------------------------------------------------"
lxc exec $lxc_container -- sudo -H -u devops bash -c '
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install v16.20.1
npm install -g typescript
npm install -g ts-node
npm install -g zx
npm --version
'

# push cd-api compressed source
echo "----------------------------------------------------"
echo "DEPLOY cd-api"
echo "----------------------------------------------------"
echo -e "-- Push $app_file file to $lxc_container/home/devops"
lxc file push $HOME/temp/cd-api.zip cd-sio-93/home/devops/
echo -e "-- Push $app_file file to $lxc_container/home/devops"
lxc file push $add_host_file cd-sio-93/home/devops/

# change ownership
echo -e "-- set ownership"
lxc exec $lxc_container -- sudo chown devops /home/devops/$app_file

# unzip cd-api source
echo -e "uncompress cd-api"
lxc exec $lxc_container -- sudo -H -u devops bash -c '
unzip /home/devops/cd-api.zip -d /home/devops
mv /home/devops/cd-api /home/devops/cd-sio
'

# configure hosts
lxc exec $lxc_container -- sudo -H -u devops bash -c '
# database access
sh /home/devops/add_host.sh "cd-db-91" "192.168.0.91"
# api access
sh /home/devops/add_host.sh "cd-sio-93" "192.168.0.92"
# socket-io push server access
sh /home/devops/add_host.sh "cd-sio-93" "192.168.0.93"
# web server access
sh /home/devops/add_host.sh "cd-web-94" "192.168.0.94"
'




