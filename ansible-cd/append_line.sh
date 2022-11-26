#!/bin/bash

rm hosts.ini
# use jq to get group names
groups=$(jq ".groups" hosts.json)
i=0
for group in $groups
do
    g=$(jq ".groups[$i].name" hosts.json)
    echo "$g"
    if [ "$g" == null ]
    then
        echo ""
    else
        echo "[$g]" >> hosts.ini
        # hosts=$(jq ".hosts" hosts.json)
        hosts=$(jq ".hosts[] | select(.color=='yellow')" hosts.json)
        # ------------------------------
        for host in $hosts
        do
            # get parents
            p=$(jq ".hosts[$i].group_parents" hosts.json)
            h=$(jq ".hosts[$i].ip" hosts.json)
            echo "$h"
            if [ "$h" == null ]
            then
                echo ""
            else
                echo "$h" >> hosts.ini
            fi
            i=$i+1;
        done
        # ------------------------------
    fi
    i=$i+1;
done
# ...then loop through
# append group name
# get all the items under the group
# loop through the result and append the ip and hostanem
# append line
# echo 'I=eth0' >> net.eth0.config.sh