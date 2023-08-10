#!/bin/bash

lxc exec routed-93 -- lxc file push /tmp/pre-init-user.sh cd-api/tmp/pre-init-user.sh
lxc exec routed-93 -- lxc file push /tmp/init-user.sh cd-api/tmp/init-user.sh
lxc exec routed-93 -- sh /tmp/pre-init-user.sh
lxc exec routed-93 -- sh /tmp/init-user.sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
su $USER
nvm install --lts
nvm install v16.20.1


