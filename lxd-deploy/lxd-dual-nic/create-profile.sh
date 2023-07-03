#!/bin/bash

# set profile
lxc profile create privatepublicnetwork
# wget https://raw.githubusercontent.com/georemo/lxd/lxc/privatepublicnetwork.profile -O privatepublicnetwork.profile

# IMPORTANT: 
# 1. Confirm the nic parent for eth0 is specified correctly.
#    On emp-06, it is lxdbr0 but in the lxd cluster, the default is lxdfan0
# 2. confirm the nic parent for eth1 name for the ethernet card is set correctly in the profile
# Examples:
# DEVICE                    |   INTERFACE   |   DESCRIPTION
# -----------------------------------------------------------------------------------------
# HP EliteBook 840 G3       | enp0s31f6     |   used in emp-06 and emp-07
# -----------------------------------------------------------------------------------------
# HP ProDesk 600 G3 SFF     | eno1          |   used in cloud-brix lab cd-09-X to cd-11-X
# -----------------------------------------------------------------------------------------
# innotek GmbH(Virtualbox)  | eth2          |   used in cloud brix lxd containers

# 2. make sure ethernet wire is connected and the router is switched on


cat privatepublicnetwork.profile | lxc profile edit privatepublicnetwork
