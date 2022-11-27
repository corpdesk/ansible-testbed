#!/bin/bash

rm hosts.ini
# use jq to get group names
groups=$(jq ".groups" hosts.json)
groupsLen=$(echo "$groups" | jq '. | length')
i=0
# for group in $groups
while [ $i -le $groupsLen ]
do
    g=$(jq ".groups[$i].name" hosts.json)
    echo "value of g1 is $g"
    if [ "$g" = null ]
    then
        echo ""
    else
        echo "[$g]" >> hosts.ini
        echo "$g"
        hosts=$(jq ".hosts" hosts.json)
        hostsLen=$(echo "$hosts" | jq '. | length')
        j=0
        # hosts=$(jq ".hosts[] | select(.color=='yellow')" hosts.json)
        # ------------------------------
        # for host in $hosts
        while [ $j -le $hostsLen ]
        do
            echo "value of i is $i"
            echo "value of j is $j"
            echo "value of g2 is $g"

            if [ "$g" = null ]
            then
                echo "g3 is null so we do nothing"
            else
                # get parents array
                gp=$(jq ".hosts[$j].group_parents" hosts.json)
                # check if this host belongs to this parent_group
                # select from gp where group.name == group
                echo "value of gp is $gp"
                # jq '.[] | select(.color=="yellow")' fruits.json
                isChild=$(echo "$gp" | jq ".[] | select(.name==$g)")
                echo "value of isChild is $isChild"
                isChildLen=$(echo "$isChild" | jq '. | length')
                echo "value of isChildLen is $isChildLen"
                if [ $isChildLen > 0 ]
                then
                    echo "valude of isChild2 is $isChild"
                    h=$(jq ".hosts[$j].ip" hosts.json)
                    echo "$h"
                    echo "---------------:"
                    echo "$h" >> hosts.ini
                    
                else
                    echo "no parents found"
                fi
            fi
            j=$(($j + 1))
        done
        
        # ------------------------------
    fi
    # create a space before the next group
    echo " " >> hosts.ini
    i=$(($i + 1))
done
# ...then loop through
# append group name
# get all the items under the group
# loop through the result and append the ip and hostanem
# append line
# echo 'I=eth0' >> net.eth0.config.sh