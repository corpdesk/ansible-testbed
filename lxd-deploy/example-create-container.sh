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
# note that 192.168.3.x is the lxd network identity where this script is invoked
# remember to change this according to the settings for lxdbr0, the local lxd nic
networkId="192.168.0"
dualNic=true
from=1
to=2
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