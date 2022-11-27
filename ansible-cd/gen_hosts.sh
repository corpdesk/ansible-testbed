#!/bin/bash

# delete file if exists
rm -f hosts.ini

# use jq to get group names
groups=$(jq ".groups" hosts.json)

# count groups
groupsLen=$(echo "$groups" | jq '. | length')

# initiate group counter
i=0

# loop through the groups
while [ $i -le $groupsLen ]
do
    # get value of the current group
    g=$(jq ".groups[$i].name" hosts.json)
    echo "value of g1 is $g"

    # filter off null groups and process valid groups
    if [ "$g" = null ]
    then
        echo ""
    else
        echo "[$g]" >> hosts.ini
        echo "$g"

        # get all the hosts
        hosts=$(jq ".hosts" hosts.json)
        # count available hosts
        hostsLen=$(echo "$hosts" | jq '. | length')
        j=0
        # ------------------------------
        # loop through $hosts
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
                isChild=$(echo "$gp" | jq ".[] | select(.name==$g)")
                echo "value of isChild is $isChild"
                isChildLen=$(echo "$isChild" | jq '. | length')
                echo "value of isChildLen is $isChildLen"
                if [ $isChildLen -gt 0 ]
                then
                    echo "valude of isChild2 is $isChild"
                    h=$(jq ".hosts[$j].ip" hosts.json)
                    echo "$h" >> hosts.ini
                    
                else
                    echo "no parents found"
                fi
            fi
            j=$(($j + 1))
        done
        
    fi
    # create a space before the next group
    echo " " >> hosts.ini
    i=$(("$i" + 1))
done

{ 
    echo "[multi:vars]"; 
    echo "ansible_user=vagrant"; 
    echo "ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key"; 
    echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'";
    echo " "
}  >> hosts.ini
