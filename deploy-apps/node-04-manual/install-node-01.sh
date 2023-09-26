#!/bin/bash

lxc exec routed-93 -- lxc file push /tmp/pre-init-user.sh cd-api/tmp/pre-init-user.sh
lxc exec routed-93 -- lxc file push /tmp/init-user.sh cd-api/tmp/init-user.sh
lxc exec routed-93 -- sh /tmp/pre-init-user.sh
lxc exec routed-93 -- sh /tmp/init-user.sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install v16.20.1

bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install v16.20.1'

------------------------------
initialize container:
-----------------------
bash -c 'lxc_container="cd-api-22"
projDir="/media/emp-06/disk-02/projects/ansible-testbed"
initEnv="reset_environment.sh"
initUser="setup_initial_user.sh"
lxc file push "$projDir/shared-files/$initEnv" $lxc_container/tmp/
lxc file push "$projDir/shared-files/$initUser" $lxc_container/tmp/
sleep 5
lxc exec $lxc_container -- sh /tmp/$initUser'

install nodejs via nvm:
-----------------------
lxc exec cd-api-22 -- sudo -H -u devops bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install v16.20.1'


# ----------------------------------------------------------------------------------------------------
root@cd-api-01:~# su devops
$ cd ~
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
su devops  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 15916  100 15916    0     0  14347      0  0:00:01  0:00:01 --:--:-- 14338
=> Downloading nvm from git to '/home/devops/.nvm'
=> Cloning into '/home/devops/.nvm'...
remote: Enumerating objects: 360, done.
remote: Counting objects: 100% (360/360), done.
remote: Compressing objects: 100% (306/306), done.
remote: Total 360 (delta 40), reused 171 (delta 28), pack-reused 0
Receiving objects: 100% (360/360), 220.23 KiB | 924.00 KiB/s, done.
Resolving deltas: 100% (40/40), done.
* (HEAD detached at FETCH_HEAD)
  master
=> Compressing and cleaning up git repository

=> Appending nvm source string to /home/devops/.profile
=> bash_completion source string already in /home/devops/.profile
=> Close and reopen your terminal to start using nvm or run the following to use it now:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
$ nvm install v16.20.1

#----------------------------------------------

devops@cd-api-01:~/cd-api$ export NVM_DIR="$HOME/.nvm"
devops@cd-api-01:~/cd-api$ [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
devops@cd-api-01:~/cd-api$ npm version

# ----------------------------------------------------------------------------------------------------

Remove:
rm -fr ~/.nvm
rm -fr ~/.npm
rm -fr ~/.bower


