#!/bin/bash

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



