#!/bin/bash

# # executing concatenated commands
# cmd1="echo xx"
# cmd2="echo yy"
# cmd="$cmd1; $cmd2"
# bash -c "$cmd"
# -----------------------------------------------------------

# # exported string variable & function output
# **************************************************
# export ENV_VAR="env-var"
# fxPringSomething(){
#     echo "fxSomething";
# }
# cmdHead='echo "."
# echo "."
# echo "."
# echo "--------$(hostname)/STARTING host-update-cluster.sh"
# echo "--------$(hostname)/cluster-init-user.sh: whoami: $(whoami)"
# echo "--------$(hostname)/host-update-cluster.sh: executing at the physical machine"'
# cmd2="echo ${ENV_VAR}"
# cmd3="echo $(fxPringSomething)"
# cmd="$cmdHead; $cmd2; $cmd3;"
# bash -c "$cmd"
# -----------------------------------------------------------------

adminUser="emp-09"
operator="devops"
clusterMember="routed-93"
export ENV_VAR="env-var"

fxPringSomething(){
    echo "fxSomething";
}

gitAnsibleTestbed="
    if [ -d "/home/emp-06/test/ansible-testbed" ] 
    then
        echo "--------$(hostname)/host-update-cluster.sh: cloud-brix files for $adminUser  will be updated"
        cd /home/emp-06/test/ansible-testbed
        git pull
        cd /home/emp-06/
    else
        mkdir -p /home/emp-06/test/
        cd /home/emp-06/test/
        echo "--------$(hostname)/host-update-cluster.sh: updating source files for $adminUser"
        git clone https://github.com/corpdesk/ansible-testbed.git
    fi

}"

cmdHead='echo "."
echo "."
echo "."
echo "--------$(hostname)/STARTING host-update-cluster.sh"
echo "--------$(hostname)/cluster-init-user.sh: whoami: $(whoami)"
echo "--------$(hostname)/host-update-cluster.sh: executing at the physical machine"'
cmd2="echo ${ENV_VAR}"
cmdGitAnsibleTestbed="$gitAnsibleTestbed"

cmd="$cmdHead; $cmd2; $cmdGitAnsibleTestbed;"
bash -c "$cmd"


