#!/bin/bash

gfsServer0="cd-glusterfs-20"
gfsServer1="cd-glusterfs-21"
gfsServer2="cd-glusterfs-22"

# the name assigned to the client container (storage domain, in cloud-brix) and voluname at the server
storageDomain="stor-dom-000-1"

# consumer identification
consToken="B0B3DA99-1859-A499-90F6-1E3F69575DCD"

# subdomain setup
tee -a /etc/hosts <<EOF

# storage servers
192.168.3.20 $gfsServer0
192.168.3.21 $gfsServer1
192.168.3.22 $gfsServer2

# storage domains
192.168.0.101 $storageDomain
192.168.3.82  $storageDomain
192.168.0.101 $consToken.$storageDomain
192.168.3.82  $consToken.$storageDomain
EOF