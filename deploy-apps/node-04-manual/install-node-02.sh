nodeVersion="v16"
cd ~
sudo apt install curl
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
nvm install $nodeVersion

#-----------------------------------------------
devops@cd-api-01:~/cd-api$ export NVM_DIR="$HOME/.nvm"
devops@cd-api-01:~/cd-api$ [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
devops@cd-api-01:~/cd-api$ npm version

#----------------------------------------------

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
npm version

bash -c 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
npm version'



