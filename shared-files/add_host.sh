#!/bin/bash

# Hostname and IP address to add to /etc/hosts
HOSTNAME=$1
IP_ADDRESS=$2

# Check if the host entry already exists in /etc/hosts
if grep -q "$HOSTNAME" /etc/hosts; then
    echo "Host entry for $HOSTNAME already exists."
else
    # Add the host entry to /etc/hosts
    echo "$IP_ADDRESS    $HOSTNAME" | sudo tee -a /etc/hosts > /dev/null
    echo "Host entry for $HOSTNAME added to /etc/hosts."
fi
