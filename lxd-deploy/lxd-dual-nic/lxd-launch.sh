#!/bin/bash

# usage:
# sh $deloyGfs2nic $image $lxcName $from $to $lxcProfile
# recommended: profile privatepublicnetwork
# lxc launch ubuntu:22.04 mycontainer --profile privatepublicnetwork
# lxc launch $image $lxcName --profile privatepublicnetwork

image=$1
lxcName=$2
from=$3
to=$4
lxcProfile=$5

# create containers
for i in $(seq $from $to); do
    lxc launch $image "$lxcName-$i" -p $lxcProfile
done 