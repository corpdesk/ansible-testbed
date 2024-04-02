#!/bin/bash

# install npm and typescript
lxc exec c1 -- sudo -H -u devops bash -c '
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install v16.20.1
npm install -g typescript
npm install -g ts-node
npm install -g zx
'
lxc_container="c1"
repoDir="$HOME/temp/"
app_file="cd-api.zip"
# push cd-api compressed source
echo -e "-- Push $app_file file to $lxc_container/home/devops"
lxc file push "$repoDir$app_file" $lxc_container/home/devops
# change ownership
lxc exec c1 -- sudo chown devops /home/devops/$app_file
# change permissions

# unzip cd-api source
lxc exec cd-shell-24 -- sudo -H -u devops bash -c '
unzip /home/devops/cd-api.zip -d /home/devops/cd-api
'


