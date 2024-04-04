#!/bin/bash
lxc_container="cd-api-92"
setup_file="cd-api-92-setup.sh"
echo "----------------------------------------------------"
echo "CLEAN"
echo "----------------------------------------------------"
lxc stop cd-api-92
lxc delete cd-api-92
lxc profile delete routed_92
echo "----------------------------------------------------"
echo "CREATE CONTAINER WITH INITIAL RESOURCES AND USER"
echo "----------------------------------------------------"
projDir="$HOME/ansible-testbed"
name="cd-api"
networkId="192.168.0"
hostId="92"
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
   

sleep 5
sh $setup_file

echo -e "-- Push $setup_file file to $lxc_container/temp/"
lxc file push $setup_file $lxc_container/temp/
sleep 5
lxc exec $lxc_container -- sh /temp/$setup_file

sh cd-api-start.sh
