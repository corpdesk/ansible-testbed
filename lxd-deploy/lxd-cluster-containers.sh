# the name assigned to the client container (storage domain, in cloud-brix) and voluname at the server
networkName="test-a"
# Note that 192.168.3.x is the lxd network (as specified in the eth0 parent in 
# the file $HOME/ansible-testbed/lxd-deploy/lxd-dual-nic/privatepublicnetwork.profile.yaml)
# remember to change this according to the environment (eg non cluster setup, lxd cluster environment etc)
# networkId="192.168.0" // for emp-06 (lxdbr0)
networkId="240.15.0"
dualNic=true
from=1
to=5
projDir="$HOME/ansible-testbed"
image="ubuntu:22.04"
lxcName="$networkName"
lxcProfile="privatepublicnetwork"

# set the script for creating single nic container with static ip
deloyGfs="$projDir/lxd-deploy/lxc-deploy.sh"

# -----------------------------

# input
# networkName=$1
# networkId=$2
# from=$3
# to=$4
# projDir=$5
# echo "projDir=$projDir"
# lxcDeploy="$projDir/lxd-deploy/lxdbr0-lxc.sh"


# create containers
for i in $(seq $from $to); do
# launch a container for specific network and static ip address
# sh $lxcDeploy $networkName $networkId $i $projDir
lxc launch $image "$networkName-$i"
done 