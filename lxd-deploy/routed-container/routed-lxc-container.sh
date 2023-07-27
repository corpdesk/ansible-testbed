#!/bin/bash

# This script is for creating and LXD container
# that has a routed network interface.
# The resulting nic is then accessible from host LAN

# USAGE:
# routed-lxc-container.sh \
#   $name : key name of the container. Note that the eventual name is a concatenantion of this string and netork id.
#   $networkId : the first 3 digits of ip
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
# ################################
# # EXAMPLE 2 (serial ips):
# name="routed"
# networkId="192.168.0"
# from=95
# to=97
# parentBridge="eno1"
# nic="eth0" 
# lxc_image="ubuntu:22.04"

# for i in $(seq $from $to); do
# sh routed-lxc-container.sh \
#   $name \
#   $networkId \
#   $i \
#   $parentBridge \
#   $nic \
#   $lxc_image 
# done 

# ################################

name=$1 # eg "routed"

# host variables
projDir="$HOME/ansible-testbed"
networkId=$2 # eg: "192.168.0"
hostId=$3 # last ip digit for the server eg 95
lxc_container="$name-$hostId"

# wifi bridge - to allow connection to local network
parentBridge=$4 # "eno1"
# target network interface
nic=$5 # "eth0"
# lxd image
lxc_image=$6 # "ubuntu:22.04"
# lxd profile name
routedProfile="routed_$hostId"
# network setup template
template="$projDir/shared-files/routed.template"
# init setup file
initSetup="reset_environment.sh"

# variables for the template MUST be exported
export GEN_LXC_IP="$networkId.$hostId"
export GEN_LXC_GATEWAY="$networkId.1"
export GEN_LXC_NS="8.8.8.8"
export GEN_LXC_PARENT=$parentBridge
export GEN_LXC_ETH=$nic

# substitute variables in the template
envsubst <"$template" >"$routedProfile.yaml"
# create profile
lxc profile create $routedProfile
# set profile
lxc profile edit $routedProfile < $routedProfile.yaml
# launch container
lxc launch $lxc_image $lxc_container --profile default --profile $routedProfile

echo -e "-- update container\n"
lxc exec $lxc_container -- apt update && apt upgrade -y

echo -e "-- Push $initSetup file\n"
# lxc file push ../../shared-files/$initSetup $lxc_container/tmp/
lxc file push $projDir/shared-files/$initSetup $lxc_container/tmp/

echo -e "-- Check /tmp/ directory:\n"
lxc exec $lxc_container -- ls /tmp/

# setup
echo -e "-- Do initial setup\n"
lxc exec $lxc_container -- sudo sh /tmp/$initSetup

