#!/bin/bash

hostData="hosts.json";
sshConfigFile=$(jq ".files.sshConfigFile" "$hostData");
eTime=$(date +%s);
# sshConfigFile="\~/.ssh/config";
# sshConfigFile="config";
IdentityFile="\~/.ssh/id_ed25519_mac_01_github";

# back up file if exists
if [ -e "$sshConfigFile" ]
then
    cp "$sshConfigFile" "$sshConfigFile.\"$eTime\".bk"
    rm -f $sshConfigFile;
else
    echo "cannot copy. The file \"$sshConfigFile\" does not exist"
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
    isVm=$( echo "$hosts" | jq ".[$i].is_vm")
    isActive=$( echo "$hosts" | jq ".[$i].is_active")
    echo "the value of ip is $ip";
    # echo "the value of isVm is $isVm";
    if [ $isVm = true ] && [ $isActive = true ]
    then
        echo "is vm"
        {
            echo "Host $ip";
            echo "  ForwardAgent yes";
            echo "  AddKeysToAgent yes";
            echo "  UseKeychain yes";
            echo "  IdentityFile $IdentityFile";
        } >> $sshConfigFile
        # create a space before the next setting
        echo " " >> $sshConfigFile
    else
        echo "is not vm"
    fi
    i=$(($i + 1))
done