#!/bin/bash

# edit host file to sync with inventory 
# check if string exists:
#   - https://stackoverflow.com/questions/4749330/how-to-test-if-string-exists-in-file-with-bash
# edit file
#   - https://stackoverflow.com/questions/2464760/modify-config-file-using-bash-script
# replace line:
#   - https://stackoverflow.com/questions/5410757/how-to-delete-from-a-text-file-all-lines-that-contain-a-specific-string
#   - sed --in-place '/some string here/d' yourfile

hostData="hosts.json";
hostsFile="/etc/hosts";
eTime=$(date +%s);
lxdImage="ubuntu:22.04"
echo "value of eTime is $eTime";

# script a preflight:
#   -  confirm lxd is installed
#   -  confirm memory and disk space is adequate

# back up file if exists
# if [ -e "$hostsFile" ]
# then
#     # make a backup file labled with epoch time
#     cp "$hostsFile" "$hostsFile.$eTime.bk"
# else
#     echo "cannot copy. The file \"$hostsFile\" does not exist"
# fi

# get all the hosts
hosts=$(jq ".hosts" "$hostData")
hostsLen=$(echo "$hosts" | jq '. | length');
echo "value of hostsLen is $hostsLen";
i=0;
while [ "$i" -lt $hostsLen ]
do
    # use -r to remove the double quotes
    ip=$( echo "$hosts" | jq -r ".[$i].ip")
    hn=$( echo "$hosts" | jq -r ".[$i].host_name")
    isActive=$( echo "$hosts" | jq ".[$i].is_active")
    isVm=$( echo "$hosts" | jq ".[$i].is_vm")
    echo "the value of ip is $ip";
    echo "the value of isActive is $isActive";
    echo "the value of isVm is $isVm";
    if [ "$isActive" = true ] && [ "$isVm" = true ]
    then
        echo "is active"
        # remove line that has been labled with same host name
        # awk "!/$hn/" "$hostsFile" > temp && sudo mv temp "$hostsFile"
        # add new setting
        # echo "$ip $hn" >> $hostsFile
        echo "starting $hn container creation..."
        lxc init $lxdImage $hn
        sleep 10
        # ...at this stage validation should be done to check if creation was success
        echo "$hn container created"
        lxc start $hn
        sleep 15
        # ...at this stage validation should be done to check if starting was success
        echo "$hn container started"
        echo "current list of containers:"
        lxc list
    else
        echo "item is not active or is not vm compliant"
    fi
    i=$(($i + 1))
done

