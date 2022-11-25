#!/bin/bash

# use jq to get group names
g=jq '.groups' hosts.json
i=0
for group in $g
do
    jq ".groups[$i].name" hosts.json >> hosts.ini
    $i=$i + 1
done
# ...then loop through
# append group name
# get all the items under the group
# loop through the result and append the ip and hostanem
# append line
# echo 'I=eth0' >> net.eth0.config.sh