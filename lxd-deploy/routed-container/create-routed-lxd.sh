#!/bin/bash

name=$1
hostId=$2
networkId="192.168.0"
parentBridge="wlp2s0"
nic="eth0" 
lxc_image="ubuntu:22.04"

sh routed-lxc-container.sh \
  $name \
  $networkId \
  $hostId \
  $parentBridge \
  $nic \
  $lxc_image 

