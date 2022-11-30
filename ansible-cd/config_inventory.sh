#!/bin/bash

hostData="hosts.json";
hostInventory=$(jq -r ".files.hostInventory" "$hostData");
# delete file if exists
rm -f $hostInventory

# use jq to get group names
groups=$(jq ".groups" "$hostData")

# count groups
groupsLen=$(echo "$groups" | jq '. | length')

# initiate group counter
i=0

# loop through the groups
while [ $i -lt $groupsLen ]
do
    # get value of the current group
    g=$(jq ".groups[$i].name" "$hostData")
    echo "value of g1 is $g"
    
    # filter off null groups and process valid groups
    if [ "$g" = null ]
    then
        echo ""
    else
        echo "[$g]" >> $hostInventory
        echo "$g"
        
        # get all the hosts
        hosts=$(jq ".hosts" "$hostData")
        # count available hosts
        hostsLen=$(echo "$hosts" | jq '. | length')
        j=0
        # ------------------------------
        # loop through $hosts
        while [ $j -lt $hostsLen ]
        do
            echo "value of i is $i"
            echo "value of hostsLen is $hostsLen"
            echo "value of j is $j"
            echo "value of g2 is $g"
            
            isActive=$( echo "$hosts" | jq ".[$i].is_active")
            
            if [ "$g" = null ] && [ $isActive = false ]
            then
                echo "g is null so we do nothing"
            else
                # get parents array
                gp=$(jq ".hosts[$j].group_parents" "$hostData")
                ip=$(jq ".hosts[$j].ip" "$hostData")
                echo "value of ip is $ip"
                # check if this host belongs to this parent_group
                # select from gp where group.name == group
                echo "value of gp is $gp"
                isChild=$(echo "$gp" | jq ".[] | select(.name==$g)")
                isChildName=$(echo "$isChild" | jq ".name")
                echo "value of isChild is $isChild"
                if [ $isChildName ]
                then
                    echo "isChild has something"
                    isChildLen=$(echo "$isChild" | jq '. | length')
                    echo "value of isChildLen is $isChildLen"
                    if [ $isChildLen -gt 0 ]
                    then
                        echo "valude of isChild2 is $isChild"
                        h=$(jq ".hosts[$j].ip" "$hostData")
                        echo "$h" >> $hostInventory
                        
                    else
                        echo "no parents found"
                    fi
                else
                    echo "isChild is null"
                fi
                
            fi
            j=$(($j + 1))
        done 
    fi
    # create a space before the next group
    echo " " >> $hostInventory
    i=$(($i + 1))
done

{
    echo "[multi:vars]";
    echo "ansible_user=vagrant";
    echo "ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key";
    echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'";
    echo " "
}  >> $hostInventory
