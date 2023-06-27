#!/bin/bash

# create lxd/lxc container with static ip connected via default lxd network
# input:
# - subnetName eg 'microk8s'
# - hostIp eg '10'
# - networkId eg '192.168.2'

echo "starting lxd-deploy/lxdbr0-lxc.sh"
# input
subnetName=$1
networkId=$2
hostId=$3
projDir=$4
echo "projDir=$projDir"
lxc_container="$subnetName-$hostId"
# parentBridge="wlp2s0"
lxc_image="ubuntu:22.04"
# init setup file
initSetup="reset_environment.sh"
initUser="setup_initial_user.sh"

lxc stop $lxc_container
sleep 5
lxc delete $lxc_container
sleep 5
lxc init -p default -p microk8s $lxc_image $lxc_container
sleep 20
lxc network attach lxdbr0 $lxc_container eth0 eth0
lxc config device set $lxc_container eth0 ipv4.address $networkId.$hostId
sleep 5
lxc start $lxc_container
sleep 20
lxc list

echo -e "-- Push $initSetup file\n"
lxc file push $projDir/shared-files/$initSetup $lxc_container/tmp/
echo -e "-- Push $initUser file\n"
lxc file push $projDir/shared-files/$initUser $lxc_container/tmp/
lxc exec $lxc_container -- sh /tmp/$initSetup
lxc exec $lxc_container -- sh /tmp/$initUser
