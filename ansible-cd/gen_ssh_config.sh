#!/bin/bash


# configFile="\~/.ssh/config";
configFile="config";
IdentityFile="\~/.ssh/id_ed25519_mac_01_github";

# back up file if exists
if [ -e "$configFile" ]
then
    cp "$configFile" "$configFile.bk"
    rm -f $configFile;
else
    echo "cannot copy. The file $configFile does not exist"
fi

# get all the hosts
hosts=$(jq ".hosts" hosts.json)
hostsLen=$(echo "$hosts" | jq '. | length');
echo "value of hostsLen is $hostsLen";
i=0;
while [ "$i" -le $hostsLen ]
do
    # use -r to remove the double quotes
    ip=$( echo "$hosts" | jq -r ".[$i].ip")
    isVm=$( echo "$hosts" | jq ".[$i].is_vm")
    echo "the value of ip is $ip";
    # echo "the value of isVm is $isVm";
    if [ $isVm = true ]
    then
        echo "is vm"
        {
            echo "Host $ip";
            echo "  ForwardAgent yes";
            echo "  AddKeysToAgent yes";
            echo "  UseKeychain yes";
            echo "  IdentityFile $IdentityFile";
        } >> config
        # create a space before the next setting
        echo " " >> $configFile
    else
        echo "is not vm"
    fi
    i=$(($i + 1))
done