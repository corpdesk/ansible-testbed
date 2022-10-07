#!/bin/bash

# Usage:
# sh setup_nfs_client.sh -a ansibleServer -d sharedDirectory -p mountingPoint
# Example:
# sh setup_nfs_client.sh -a 192.168.1.155 -d /var/nfs/p_key -p /nfs/p_key

helpFunction()
{
    echo ""
    echo "Usage: $0 -a ansibleServer -d sharedDirectory -p mountingPoint"
    echo "Example: $0 -a 192.168.1.155 -d /var/nfs/p_key -p /nfs/p_key"
    echo -e "\t-a hostname or ip for ansible server"
    echo -e "\t-d shared directory"
    echo -e "\t-p mounting point"
    exit 1 # Exit script after printing help
}

while getopts "a:d:p:" opt
do
    case "$opt" in
        a ) ansibleServer="$OPTARG" ;;
        d ) sharedDirectory="$OPTARG" ;;
        p ) mountingPoint="$OPTARG" ;;
        ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

# Print helpFunction in case parameters are empty
if [ -z "$ansibleServer" ] || [ -z "$sharedDirectory" ] || [ -z "$mountingPoint" ]
then
    echo "Some or all of the parameters are empty";
    helpFunction
fi

# Begin script in case all parameters are correct
echo "$ansibleServer"
echo "$sharedDirectory"
echo "$mountingPoint"

# variable input:
# host_ip, server shared dir:  /var/nfs/p_key, local mounting point: /nfs/p_key
sudo apt update -y
sudo apt install nfs-common -y
sudo mkdir -p /nfs/p_key
# sudo mount 192.168.1.155:/var/nfs/p_key /nfs/p_key
sudo mount "$ansibleServer":"$sharedDirectory" "$mountingPoint"

