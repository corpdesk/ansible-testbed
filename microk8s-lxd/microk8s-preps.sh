#!/bin/bash

# preps
lxc profile create microk8s
wget https://raw.githubusercontent.com/ubuntu/microk8s/master/tests/lxc/microk8s-zfs.profile -O microk8s.profile
cat microk8s.profile | lxc profile edit microk8s
rm microk8s.profile
