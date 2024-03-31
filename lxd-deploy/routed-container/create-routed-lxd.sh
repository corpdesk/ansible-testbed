#!/bin/bash

# usage:
# sh create-routed-lxd.sh "web" "8" "/media/emp-06/disk-02/projects/ansible-testbed"
# sh create-routed-lxd.sh "web" "9" "/home/emp-07/ansible-testbed"

name=$1
hostId=$2
networkId="192.168.0"
parentBridge="wlp2s0"
nic="eth0" 
lxcImage="ubuntu:22.04"
projDir=$3

sh routed-lxc-container.sh \
  $name \
  $networkId \
  $hostId \
  $parentBridge \
  $nic \
  $lxcImage \
  $projDir


