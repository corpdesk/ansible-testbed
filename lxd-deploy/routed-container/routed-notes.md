Notes:
Motivated by need for:
- access containers accross lan
- automate container creation and management

Ref: https://blog.simos.info/how-to-get-lxd-containers-get-ip-from-the-lan-with-routed-network/

Accomplished:
- automated creation of networked containers in a LAN
- platform for lxd cluster accross lan via containers

# This script is for creating and LXD container
# that has a routed network interface.
# The resulting nic is then accessible from host LAN

# USAGE:
# routed-lxc-container.sh \
#   $name : key name of the container. Note that the eventual name is a concatenantion of this string and netork id.
#   $networkId : the first 3 octets of ip seperated by .
#   $hostId : last digit of the ip
#   $parentBridge : interface for the host
#   $nic : interface for the container
#   $lxc_image: container image

###############################
# # EXAMPLE 1 (single container):
# name="routed"
# networkId="192.168.0"
# hostId="97"
# parentBridge="eno1"
# nic="eth0" 
# lxc_image="ubuntu:22.04"
#
# sh routed-lxc-container.sh \
#   $name \
#   $networkId \
#   $hostId \
#   $parentBridge \
#   $nic \
#   $lxc_image 
#
################################
# EXAMPLE 2 (serial ips):
name="routed"
networkId="192.168.0"
from=93
to=94
parentBridge="wlp2s0"
nic="eth0" 
lxc_image="ubuntu:22.04"

for i in $(seq $from $to); do
 sh routed-lxc-container.sh \
   $name \
   $networkId \
   $i \
   $parentBridge \
   $nic \
   $lxc_image 
 done 
#
################################

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



To do:
Create a cloud-brix api that can:

cb init

cb container create
cb container add
cb container delete

cb cluster create
cb cluster add
cb cluster remove

cb gluster create
cb gluster add
cb gluster remove

--------------------------------------------

/media/emp-06/disk-02/projects/ansible-testbed/lxd-deploy/routed-container/routed-lxc-container.sh

192.168.0.11 fip
192.168.0.12 lb-01
192.168.0.13 lb-02

192.168.0.21 cd-db-01 
192.168.0.22 cd-api-01
192.168.0.23 cd-sio-01
192.168.0.24 cd-shell-01
192.168.0.25 cd-user-01
192.168.0.26 cd-moduleman-01
192.168.0.27 cd-comm-01

192.168.0.31 cd-db-02



sh create-routed-lxd.sh "cd-shell" "24"
sh create-routed-lxd.sh "cd-user" "25"
sh create-routed-lxd.sh "cd-moduleman" "26"
sh create-routed-lxd.sh "cd-comm" "27"

