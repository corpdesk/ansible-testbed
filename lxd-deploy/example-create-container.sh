#!/bin/bash

# ---------
# Notes: 
#        1. This file makes use of the the script ($projDir/ansible-testbed/lxd-deploy/lxc-deploy.sh)
#           for single nic or the script ($projDir/lxd-deploy/lxd-dual-nic/lxd-launch.sh) for dual nic
#           containers.
#        2. On this script one can set whether to use dual or single nic
# ---------

# the name assigned to the client container (storage domain, in cloud-brix) and voluname at the server
networkName="test-a"
# Note that 192.168.3.x is the lxd network (as specified in the eth0 parent in 
# the file $HOME/ansible-testbed/lxd-deploy/lxd-dual-nic/privatepublicnetwork.profile.yaml)
# remember to change this according to the environment (eg non cluster setup, lxd cluster environment etc)
# networkId="192.168.0" // for emp-06 (lxdbr0)
networkId="240.15.0"
dualNic=true
from=3
to=5
projDir="$HOME/ansible-testbed"
image="ubuntu:22.04"
lxcName="$networkName"
lxcProfile="privatepublicnetwork"

# set the script for creating single nic container with static ip
deloyGfs="$projDir/lxd-deploy/lxc-deploy.sh"

# set the script for creating dual-nic container (local dhcp & macvlan dhcp)
deloyGfs2nic="$projDir/lxd-deploy/lxd-dual-nic/lxd-launch.sh"

# from=32
# to=33

# create containers
if [ "$dualNic" = true ] ; then
   sh $deloyGfs2nic $image $lxcName $from $to $lxcProfile
else
   sh $deloyGfs $networkName $networkId $from $to $projDir
fi