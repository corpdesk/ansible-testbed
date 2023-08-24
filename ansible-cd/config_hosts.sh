#!/bin/bash

# edit host file to sync with inventory 
# check if string exists:
#   - https://stackoverflow.com/questions/4749330/how-to-test-if-string-exists-in-file-with-bash
# edit file
#   - https://stackoverflow.com/questions/2464760/modify-config-file-using-bash-script
# replace line:
#   - https://stackoverflow.com/questions/5410757/how-to-delete-from-a-text-file-all-lines-that-contain-a-specific-string
#   - sed --in-place '/some string here/d' yourfile
#   - sed -i '/pattern/d' filename

hostData="hosts.json";
hostsFile="/etc/hosts";
eTime=$(date +%s);
echo "value of eTime is $eTime";

# back up file if exists
if [ -e "$hostsFile" ]
then
    # make a backup file labled with epoch time
    cp "$hostsFile" "$hostsFile.$eTime.bk"
else
    echo "cannot copy. The file \"$hostsFile\" does not exist"
fi

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
    echo "the value of ip is $ip";
    echo "the value of isActive is $isActive";
    if [ $isActive = true ]
    then
        echo "is active"
        # remove line that has been labled with same host name
        awk "!/$hn/" "$hostsFile" > temp && sudo mv temp "$hostsFile"
        # add new setting
        echo "$ip $hn" >> $hostsFile
    else
        echo "is not active"
    fi
    i=$(($i + 1))
done

