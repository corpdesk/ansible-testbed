#!/bin/bash

# This script is for setting static ip for lxd
# It has then been integrated for installing differet types of servers
#   - keepalived/haproxy nodes for vrrp system
#   - webservers for testing the above
#   - microk8s nodes to be served by the vrrp system
#
# Each type of setting requres carefull review of the params to do multiple deployment of required nodes
#
# host variables
projDir="$HOME/ansible-testbed"
hostId="95" # last ip digit for the server
lxc_container="routed-$hostId"
networkId="192.168.0"

# wifi bridge - to allow connection to local network
parentBridge="eno1"
# lxd image
lxc_image="ubuntu:22.04"
# lxd profile name
routedProfile="routed_$hostId"
# network setup template
template="$projDir/shared-files/routed.template"
# init setup file
initSetup="reset_environment.sh"
# setup file for keepalived/haproxy
# applicationSetupFile="vrrp.sh"

# webserver setup file for testing vrrp
# applicationSetupFile="test-webserver.sh"

# #######################################
# KEEPALIVE SETTING FOR WEBSERVER
# below are specific to keepalive/haproxy variable
# you can change the configs to suit mysql service
# # keepalived priority setting for specific host
# priority="100"
# keepalived nic
nic="eth0"
# # keepalived hostId for floating ip 
# fId="240"
# # haproxy backend bind port
# targetPort="80"
# # keepalivd mode
# mode="http"
# # haproxy target server setting
# rm -f ../nodes.data
# touch ../nodes.data
# echo "server webserver-01 $networkId.238:$targetPort check" >> ../nodes.data
# echo "  server webserver-02 $networkId.239:$targetPort check" >> ../nodes.data
# targetServers="server webserver-01 $networkId.238:$targetPort check\n server webserver-02 $networkId.239:$targetPort check"

# variables for the template MUST be exported
export GEN_LXC_IP="$networkId.$hostId"
export GEN_LXC_GATEWAY="$networkId.1"
export GEN_LXC_NS="8.8.8.8"
export GEN_LXC_PARENT=$parentBridge
export GEN_LXC_ETH=$nic

# substitute variables in the template
# envsubst <"../../$template" >$routedProfile.yaml
envsubst <"$template" >"$routedProfile.yaml"
# create profile
lxc profile create $routedProfile
# set profile
lxc profile edit $routedProfile < $routedProfile.yaml
# launch container
lxc launch $lxc_image $lxc_container --profile default --profile $routedProfile


# dedicated to lxd container with specific ip to host microk8s
# sh microk8s-preps.sh
# lxc launch -p default -p $routedProfile -p microk8s $lxc_image $lxc_container
# sleep 20

# # launch haprocy/vrrp
# echo -e "-- launch haprocy/vrrp\n"
# lxc launch -p default -p $routedProfile $lxc_image $lxc_container
# echo -e "-- Containers list\n"
# lxc list

# lxc exec $lxc_container -- bash -c "export PRIORITY='$priority'"
# lxc exec $lxc_container -- bash -c "export HOSTNAME='$lxc_container'"


echo -e "-- update container\n"
lxc exec $lxc_container -- apt update && apt upgrade -y


echo -e "-- Push $initSetup file\n"
# lxc file push ../../shared-files/$initSetup $lxc_container/tmp/
lxc file push $projDir/shared-files/$initSetup $lxc_container/tmp/

# echo -e "-- Push nodes.data file\n"
# lxc file push "../nodes.data" $lxc_container/tmp/

# echo -e "-- Push $applicationSetupFile file\n"
# lxc file push ../$applicationSetupFile $lxc_container/tmp/

echo -e "-- Check /tmp/ directory:\n"
lxc exec $lxc_container -- ls /tmp/

# setup
echo -e "-- Do initial setup\n"
lxc exec $lxc_container -- sudo sh /tmp/$initSetup

# echo -e "-- Install webserver\n"
# lxc exec $lxc_container -- sudo sh /tmp/$applicationSetupFile

# echo -e "-- Install keepalivd and haproxy\n"
# lxc exec $lxc_container -- sh /tmp/$applicationSetupFile \
#   $priority \
#   $nic \
#   $networkId \
#   $fId \
#   $targetPort \
#   $mode \
#   $targetServers

