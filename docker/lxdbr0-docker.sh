#!/bin/bash

# local variables
networkId="192.168.2"
hostId="4"
lxc_container="docker-$hostId"
# parentBridge="wlp2s0"
lxc_image="ubuntu:22.04"
# init setup file
initSetup="reset_environment.sh"
# preInstall=microk8s-preps.sh
# postInstall=microk8s-postinstallation.sh

# sh $preInstall
# dedicated to lxd container with specific ip to host microk8s
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

echo -e "-- Push dockerInstall.sh file\n"
lxc file push dockerInstall.sh $lxc_container/tmp/
lxc exec $lxc_container -- echo "$networkId.$hostId $lxc_container" >> /etc/hosts
lxc exec $lxc_container -- sh /tmp/dockerInstall.sh
