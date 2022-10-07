#!/bin/bash

# Usage:
# sudo sh setup_pub_cert.sh -n sshKeyName -d sharedDirectory
# Example:
# sudo sh setup_pub_cert.sh -n ansibleServer -d /var/nfs/p_key

helpFunction()
{
    echo ""
    echo "Usage: $0 -n sshKeyName -d sharedDirectory"
    echo "Example: $0 -n ansibleServer -d /var/nfs/p_key"
    echo -e "\t-n hostname or ip for ansible server"
    echo -e "\t-d shared directory"
    exit 1 # Exit script after printing help
}

while getopts "n:d:" opt
do
    case "$opt" in
        n ) sshKeyName="$OPTARG" ;;
        d ) sharedDirectory="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

# Print helpFunction in case parameters are empty
if [ -z "$sshKeyName" ] || [ -z "$sharedDirectory" ]
then
    echo "Some or all of the parameters are empty";
    helpFunction
fi

# Begin script in case all parameters are correct
echo "$sshKeyName"
echo "$sharedDirectory"

sh setup_nfs_server.sh
# create ssh key pair
ssh-keygen -t rsa -b 2048 -f ~/.ssh/"$sshKeyName" -q -N ""
# copy the generated public file to shared directory for target inventory servers
cp ~/.ssh/"$sshKeyName".pub "$sharedDirectory"/"$sshKeyName".pub

