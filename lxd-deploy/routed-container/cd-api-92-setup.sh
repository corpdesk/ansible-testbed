#!/bin/bash
lxc_container="c1"
repoDir="$HOME/temp/"
app_file="cd-api.zip"

# install npm and typescript
echo "----------------------------------------------------"
echo "INSTALL npm AND typescript"
echo "----------------------------------------------------"
lxc exec c1 -- sudo -H -u devops bash -c '
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
lxc file push $HOME/temp/cd-api.zip c1/home/devops/
# change ownership
echo -e "-- set ownership"
lxc exec $lxc_container -- sudo chown devops /home/devops/$app_file

# unzip cd-api source
echo -e "uncompress cd-api"
lxc exec $lxc_container -- sudo -H -u devops bash -c '
unzip /home/devops/cd-api.zip -d /home/devops
'

# configure hosts

sh cd-api-start.sh


