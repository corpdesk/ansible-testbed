#!/bin/bash

lxc_container="cd-web-94"
setup_dir="/home/emp-07/ansible-testbed/vrrp/"
setup_file="webserver.sh"

echo -e "-- Push $setup_file file to $lxc_container/temp/"
lxc file push $setup_dir$setup_file $lxc_container/temp/
lxc exec $lxc_container -- sh /temp/$setup_file