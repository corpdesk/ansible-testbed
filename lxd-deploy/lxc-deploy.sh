#!/bin/bash

# ---------
# Usage: (Example: <project-directory>/ansible-testbed/deploy-apps/gluster_03/lxd-deploy/lxd-deploy-gluster-containers.sh)
# ---------
#   # deploy single nic container with static ip
#   deloyGfs="$projDir/lxd-deploy/lxc-deploy.sh"
#   # launch dual-nic container (local dhcp & macvlan dhcp)
#   deloyGfs2nic="$projDir/lxd-deploy/lxd-dual-nic/lxd-launch.sh"
#
#   # create containers
#   if [ "$dualNic" = true ] ; then
#   sh $deloyGfs2nic $image $lxcName $from $to $lxcProfile
#   else
#   sh $deloyGfs $networkName $networkId $from $to $projDir
#   fi


echo "starting lxd-deploy/lxc-deploy"
# input
networkName=$1
networkId=$2
from=$3
to=$4
projDir=$5
echo "projDir=$projDir"
lxcDeploy="$projDir/lxd-deploy/lxdbr0-lxc.sh"


# create containers
for i in $(seq $from $to); do
# launch a container for specific network and static ip address
sh $lxcDeploy $networkName $networkId $i $projDir
done 



