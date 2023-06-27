curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
sudo apt -y install nodejs

# OPTION 2: nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# install
sudo apt update
# sudo adduser devops
# usermod -aG sudo devops
sudo apt install nodejs npm -y
# create node.js typescript project
# Ref: https://www.sitepoint.com/google-zx-write-node-shell-scripts/
# create a new project:

projName="zx-shell-scripts"
cd $HOME
mkdir $projName
cd $projName
npm init --yes
# enable typescript
# npm install -g npx
npm install --save-dev typescript ts-node
# Then we can install the zx library:
npm install --save-dev zx

touch hello-world-typescript.js

cat > $HOME/$projName/hello-world-typescript.js <<EOF
#! ./node_modules/.bin/ts-node

// hello-world-typescript.ts

import { $ } from "zx";

void (async function () {
  await $`ls`;
})();
EOF

cat > $HOME/$projName/tsconfig.json <<EOF
{
  "compilerOptions": {
    "target": "es2017",
    "module": "commonjs"
  }
}

EOF

chmod u+x hello-world-typescript.ts



