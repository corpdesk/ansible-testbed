#!/bin/bash
lxc_container="cd-web-94"
setup_file="cd-web-94-setup.sh"
echo "----------------------------------------------------"
echo "CLEAN"
echo "----------------------------------------------------"
lxc stop cd-web-94
lxc delete cd-web-94
lxc profile delete routed_94
echo "----------------------------------------------------"
echo "CREATE CONTAINER WITH INITIAL RESOURCES AND USER"
echo "----------------------------------------------------"
projDir="$HOME/ansible-testbed"
name="cd-web"
networkId="192.168.0"
hostId="94"
parentBridge="eno1"
nic="eth0" 
lxc_image="ubuntu:22.04"

sh routed-lxc-container.sh \
   $name \
   $networkId \
   $hostId \
   $parentBridge \
   $nic \
   $lxc_image \
   $projDir
   

echo -e "-- Push $setup_file file to $lxc_container/temp/"
lxc file push $setup_file $lxc_container/temp/
sleep 5
lxc exec $lxc_container -- sh /temp/$setup_file
