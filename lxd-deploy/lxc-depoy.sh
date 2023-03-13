#!/bin/bash

# input
networkName=$1
networkId=$2
from=$3
to=$4
projDir=$5
lxcDeploy="$projDir/lxd-deploy/lxdbr0-lxc.sh"

# create containers
for i in $(seq $from $to); do
# launch a container for specific network and static ip address
sh $lxcDeploy $networkName $networkId $i $projDir
done 

# set host file
# for i in $(seq $from $to); do
#     for j in $(seq $from $to); do
#         lxc shell $networkName-$i -- echo "$networkId.$j $networkName-$j" >> /etc/hosts
#         lxc shell $networkName-$i -- echo "$networkId.$j $networkName-$j" >> /etc/hosts
#         lxc shell $networkName-$i -- echo "$networkId.$j $networkName-$j" >> /etc/hosts
#     done
# done 



