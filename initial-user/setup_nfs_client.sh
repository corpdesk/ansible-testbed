#!/bin/bash

# Usage:
# sudo sh setup_nfs_client.sh -a ansibleServer -d sharedDirectory -p mountingPoint
# Example:
# sudo sh setup_nfs_client.sh -a 192.168.1.155 -d /var/nfs/p_key -p /nfs/p_key

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
sudo apt install nfs-common expect -y
sudo mkdir -p /nfs/p_key
printf "\nStart mounting nfs shared dir:"
sudo mount "$ansibleServer":"$sharedDirectory" "$mountingPoint" &
printf "\nEnd mounting nfs shared dir:\n"
sleep 3
printf "\nStart setting up initial user:"
sudo sh setup_initial_user.sh
printf "\nEnd setting up initial user:"
# echo "content of target file:"
# less "$mountingPoint"/ansibleServer.pub &

# echo 'yU0B14NC1PdE' | su - devops -c "sudo cp /nfs/p_key/ansibleServer.pub /home/devops/.ssh/ansibleServer.pub"
printf "\nStart 2nd su:"
#  expect -c 'spawn su - -l devops -c "sudo cp /nfs/p_key/ansibleServer.pub /home/devops/.ssh/ansibleServer.pub"; expect "Password :"; send "yU0B14NC1PdE\n"; interact'
echo "yU0B14NC1PdE" | sudo -S sleep 1 && sudo su - devops && mkdir /home/devops/.ssh/  && cp /nfs/p_key/ansibleServer.pub /home/devops/.ssh/ansibleServer.pub
# expect -c '
#  log_user 0
#  spawn /usr/bin/sudo su - devops
#  expect "*: "
#  send "yU0B14NC1PdE\n"
#  interact
# '
printf "\nEnd 2nd su:"
printf "\nWho am I?"
whoami

