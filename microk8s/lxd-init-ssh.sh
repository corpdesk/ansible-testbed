#!/bin/bash

# edit host file to sync with inventory 
# check if string exists:
#   - https://stackoverflow.com/questions/4749330/how-to-test-if-string-exists-in-file-with-bash
# edit file
#   - https://stackoverflow.com/questions/2464760/modify-config-file-using-bash-script
# replace line:
#   - https://stackoverflow.com/questions/5410757/how-to-delete-from-a-text-file-all-lines-that-contain-a-specific-string
#   - sed --in-place '/some string here/d' yourfile

user="ubuntu"
deployer="kubernetes-cluster-01-deployer"
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

# push password file (experimental) - otherwise adopt secure way of handling password
lxc file push ../shared-files/p kubernetes-cluster-01-deployer/home/ubuntu/
lxc exec $deployer -- chown ubuntu /home/ubuntu/p

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
        # push sh file
        init_file="init_script.sh"
        lxc file push $init_file $hn/home/$user/
        lxc exec $hn -- chown $user /home/$user/$init_file
        cmdInit="sh $init_file"
        lxc exec $hn -- sudo --user $user bash -ilc "su $user && cd ~/ && $cmdInit"
        # cmdChown="sudo chown -R $user ~/.ssh"
        cmdKeycheckOff="sshpass -f p ssh -o StrictHostKeyChecking=no $user@$hn"
        cmdSshCopy="sshpass -f p ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$hn"
        lxc exec $hn -- sudo --user $user bash -ilc "cd ~/ && pwd && $cmdKeycheckOff && $cmdSshCopy && echo done"
    else
        echo "item is not active or is not vm compliant"
    fi
    i=$(($i + 1))
done

# remove password file (experimental)
rm -fr ~/p

