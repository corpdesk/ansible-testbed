#!/bin/bash
lxc_container="cd-db-91"
setup_file="cd-db-91-setup.sh"
echo "----------------------------------------------------"
echo "CLEAN"
echo "----------------------------------------------------"
lxc stop cd-db-91
lxc delete cd-db-91
lxc profile delete routed_91
echo "----------------------------------------------------"
echo "CREATE CONTAINER WITH INITIAL RESOURCES AND USER"
echo "----------------------------------------------------"
projDir="$HOME/ansible-testbed"
name="cd-db"
networkId="192.168.0"
hostId="91"
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
