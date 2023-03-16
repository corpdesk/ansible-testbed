networkName="cd-glusterfs"
networkId="192.168.3"
from=20
to=22
projDir="/home/emp-06/ansible-testbed"
deployGlusterfs="$projDir/lxd-deploy/lxc-deploy.sh"

# sh $deployGlusterfs $networkName $networkId $from $to $projDir

from=30
to=31

sh $deployGlusterfs $networkName $networkId $from $to $projDir

