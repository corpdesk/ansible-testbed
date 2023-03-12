#!/bin/bash

# This script is for setting static ip for lxd
# It has then been integrated for installing differet types of servers
#   - keepalived/haproxy nodes for vrrp system
#   - webservers for testing the above
#   - microk8s nodes to be served by the vrrp system
#
# Each type of setting requres carefull review of the params to do multiple deployment of required nodes
#

hostId="12" # last ip digit for the server (host ip)
priority="100"
# app="webserver"
# app="vrrp"
app="microk8s"
profileSetting=""
# host variables
lxc_container=""
networkId="192.168.2"

# lxd image
lxc_image="ubuntu:22.04"
# init setup file
initSetup="reset_environment.sh"
# setup file for keepalived/haproxy
applicationSetupFile=""
# keepalived nic
nic="eth0"
# keepalived hostId for floating ip 
fId="240"
# haproxy backend bind port
targetPort=""
# keepalivd mode
mode=""

# haproxy target server setting
rm -f ../nodes.data
touch ../nodes.data
case "$app" in
   "webserver") 
    lxc_container="webserver-$hostId"
    applicationSetupFile="test-webserver.sh"
   ;;
   "vrrp") 
    lxc_container="vrrp-$hostId"
    applicationSetupFile="vrrp.sh"
    # haproxy mode
    mode="http"
    # haproxy bind port
    targetPort="80"
    # nodes.data contents are used to define haproxy target hosts in the /etc/haproxy/haproxy.cfg file
    echo "server webserver-238 $networkId.238:$targetPort check" >> ../nodes.data
    echo "  server webserver-239 $networkId.239:$targetPort check" >> ../nodes.data
   ;;
   "microk8s") 
    # ##############################################################
    # PROFILE INSTALLATION (ONLY DONE ONCE)
    # # Add the MicroK8s LXD profile
    # # MicroK8s requires some specific settings to work within LXD (these are explained in more detail below). These can be applied using a custom profile. The first step is to create a new profile to use:
    # # lxc profile create microk8s
    # # Once created, we’ll need to add the rules. If you’re using ZFS, you’ll need this version or, if you’re using ext4, you’ll need this one. There is a section at the end of this document to describe what these rules do.
    # # Download the profile:
    
    # # for ZFS
    # wget https://raw.githubusercontent.com/ubuntu/microk8s/master/tests/lxc/microk8s-zfs.profile -O microk8s.profile
    # # for ext4
    # # wget https://raw.githubusercontent.com/ubuntu/microk8s/master/tests/lxc/microk8s.profile -O microk8s.profile

    # #We can now pipe that file into the LXD profile.
    # cat microk8s.profile | lxc profile edit microk8s

    # #And then clean up.
    # rm microk8s.profile
    

    # ##############################################################
    # PROFILE SETTING (DONE FOR EVERY CONTAINIER THAT REQURES microk8s)
    profileSetting="-p default -p microk8s"
    lxc_container="microk8s-$hostId"
   ;;
esac



# launch $app
echo -e "-- launch $app\n"
lxc launch $profileSetting $lxc_image $lxc_container
lxc network attach lxdbr0 $lxc_container eth0 eth0 
lxc config device set $lxc_container eth0 ipv4.address "$networkId.$hostId"
lxc exec $lxc_container -- reboot
# takes a moment to load eth0
sleep 15
echo -e "-- Containers list\n"
lxc list


echo -e "-- Push $initSetup file\n"
lxc file push ../../shared-files/$initSetup $lxc_container/tmp/

echo -e "-- Push nodes.data file\n"
lxc file push "../nodes.data" $lxc_container/tmp/

echo -e "-- Push $applicationSetupFile file\n"
lxc file push ../$applicationSetupFile $lxc_container/tmp/

echo -e "-- Check /tmp/ directory:\n"
lxc exec $lxc_container -- ls /tmp/

# setup
echo -e "-- Do initial setup\n"
lxc exec $lxc_container -- sudo sh /tmp/$initSetup

echo -e "-- Install $app\n"
case "$app" in
   "webserver")
    lxc exec $lxc_container -- sudo sh /tmp/$applicationSetupFile
   ;;
   "vrrp") 
    lxc exec $lxc_container -- sh /tmp/$applicationSetupFile \
        $priority \
        $nic \
        $networkId \
        $fId \
        $targetPort \
        $mode \
        $targetServers
   ;;
   "microk8s")
    lxc exec $lxc_container -- sudo snap install microk8s --classic
   ;;
esac
