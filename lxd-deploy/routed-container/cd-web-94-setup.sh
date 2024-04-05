#!/bin/bash

lxc_container="cd-web-94"
apache_installer="/home/emp-07/ansible-testbed/vrrp/webserver.sh"

echo -e "-- Push $setup_file file to $lxc_container/temp/"
lxc file push $setup_file $lxc_container/temp/
lxc exec $lxc_container -- sh /temp/$setup_file