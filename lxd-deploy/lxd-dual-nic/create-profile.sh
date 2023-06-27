#!/bin/bash

# set profile
lxc profile create privatepublicnetwork
# wget https://raw.githubusercontent.com/georemo/lxd/lxc/privatepublicnetwork.profile -O privatepublicnetwork.profile

# IMPORTANT: 
# 1. confirm the nic name for the ethernet card is set correctly in the profile
# 2. make sure ethernet wire is connected and the router is switched on
cat privatepublicnetwork.profile | lxc profile edit privatepublicnetwork
