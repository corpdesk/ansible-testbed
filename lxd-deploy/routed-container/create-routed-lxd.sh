#!/bin/bash

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


