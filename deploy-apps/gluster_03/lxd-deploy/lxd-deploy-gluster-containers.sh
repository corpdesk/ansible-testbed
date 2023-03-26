# the name assigned to the client container (storage domain, in cloud-brix) and voluname at the server
networkName="stor-dom-000"
networkId="192.168.3"
dualNic=true
from=1
to=2
projDir="/home/emp-06/ansible-testbed"
image="ubuntu:22.04"
lxcName="$networkName"
lxcProfile="privatepublicnetwork"

# deploy single nic container with static ip
deloyGfs="$projDir/lxd-deploy/lxc-deploy.sh"

# launch dual-nic container (local dhcp & macvlan dhcp)
deloyGfs2nic="$projDir/lxd-deploy/lxd-dual-nic/lxd-launch.sh"

# from=32
# to=33

# create containers
if [ "$dualNic" = true ] ; then
   sh $deloyGfs2nic $image $lxcName $from $to $lxcProfile
else
   sh $deloyGfs $networkName $networkId $from $to $projDir
fi

