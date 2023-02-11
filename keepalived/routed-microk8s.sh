#!/bin/bash

# local variables
lxc_container="microk8-lxd-01-node-3"
networkId="192.168.1"
hostId="16"
parentBridge="wlp2s0"
lxc_image="ubuntu:22.04"
routedProfile="routed_$networkId.$hostId"

# variables for the template MUST be exported
export GEN_LXC_IP="$networkId.$hostId"
export GEN_LXC_GATEWAY="$networkId.1"
export GEN_LXC_NS="8.8.8.8"
export GEN_LXC_PARENT=$parentBridge

# substitute variables in the template
envsubst <routed.template >$routedProfile.yaml
# create profile
lxc profile create $routedProfile
# set profile
sudo lxc profile edit $routedProfile < $routedProfile.yaml
# launch container
# lxc launch $lxc_image $lxc_container --profile default --profile $routedProfile


# dedicated to lxd container with specific ip to host microk8s
sh microk8s-preps.sh
lxc launch -p default -p $routedProfile -p microk8s $lxc_image $lxc_container
sleep 20

# to be able to ssh into host use below codes:
lxc exec $lxc_container -- sudo apt update -y
lxc exec $lxc_container -- sudo ufw allow from $networkId.0/24 to any port 22
lxc exec $lxc_container -- sudo apt-get install git net-tools openssh-server tree fish jq  -y
lxc exec $lxc_container -- sudo service ssh restart
# allow ssh connections
# allow lxd heartbeats
lxc exec $lxc_container -- sudo ufw allow from $networkId.0/24 to any port 8443
lxc exec $lxc_container -- sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
lxc exec $lxc_container -- sudo sed -i -E 's/#?PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec $lxc_container -- sudo sed -i -E 's/#?ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
lxc exec $lxc_container -- sudo sed -i -E 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
lxc exec $lxc_container -- sudo sed -i -E 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
lxc exec $lxc_container -- sudo systemctl restart ssh

lxc exec $lxc_container -- sudo apt update && sudo apt upgrade
lxc exec $lxc_container -- sudo snap install microk8s --classic
