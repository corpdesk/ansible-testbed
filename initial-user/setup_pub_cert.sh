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

sudo sh setup_nfs_server.sh
sleep 3

# create ssh key pair
# sudo ssh-keygen -t rsa -b 2048 -f ~/.ssh/"$sshKeyName" -q -N ""
sudo ssh-keygen -t rsa -b 2048 -f ~/.ssh/ansibleServer -q -N ""
# copy the generated public file to shared directory for target inventory servers
sleep 4
sudo chmod -R 755 /home/ubuntu/
sudo cp ~/.ssh/"$sshKeyName".pub "$sharedDirectory"/"$sshKeyName".pub
sudo cp /root/.ssh/"$sshKeyName".pub /home/ubuntu/.ssh/"$sshKeyName".pub

