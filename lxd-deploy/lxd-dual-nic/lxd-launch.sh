#!/bin/bash

image=$1
lxcName=$2
lxcProfile=$3
# lxc launch ubuntu:22.04 mycontainer --profile privatepublicnetwork
lxc launch $image $lxcName --profile privatepublicnetwork