#!/bin/bash

# https://www.digitalocean.com/community/questions/ssh-copy-id-not-working-permission-denied-publickey
# https://www.linuxbabe.com/linux-server/setup-passwordless-ssh-login
# https://stackoverflow.com/questions/12202587/automatically-enter-ssh-password-with-script

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
# sudo ssh-keygen -t rsa -b 2048 -f ~/.ssh/ansibleServer -q -N ""
sudo ssh-keygen -t rsa -b 2048 -f /home/devops/.ssh/id_rsa -q -N ""
# copy the generated public file to shared directory for target inventory servers
sleep 4

# OPTION 1
sudo ssh-copy-id -i /home/devops/.ssh/id_rsa.pub devops@192.168.1.121

# OPTION 2
$ sshpass -f p.txt ssh-copy-id devops@192.168.1.121

# OPTION 2
spawn ssh-copy-id $argv
expect "password:"
send "yU0B14NC1PdE\n"
expect eof

# OPTION 2
# sudo chmod -R 755 /home/ubuntu/
# sudo cp /home/ubuntu/.ssh/"$sshKeyName".pub "$sharedDirectory"/"$sshKeyName".pub

# sudo cp /home/ubuntu/.ssh/"$sshKeyName".pub /home/devops/.ssh/"$sshKeyName".pub
# sudo chmod -R 755 /home/devops/

