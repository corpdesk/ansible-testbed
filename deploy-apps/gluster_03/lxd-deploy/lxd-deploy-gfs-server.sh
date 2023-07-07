#!/bin/bash

# Ref: https://thenewstack.io/tutorial-deploy-a-highly-availability-glusterfs-storage-cluster/

# You need to run <projDir>/deploy-apps/gluster_03/lxd-deploy/lxd-deploy-gluster-containers.sh to create lxc containers to host glusterfs servers
# This is a script for setting up glusterfs server
# after this script  is done, go to <projDir>/deploy-apps/gluster_03/lxd-deploy/lxd-deploy-gfs-domain.sh to create 
# glusterfs clients (cloud-brix storage domains)
# storage domains are the ones consumed by application clients(eg corpdesk) and treated like webservers.



gfsServer0="cd-glusterfs-09"
gfsServer1="cd-glusterfs-10"
gfsServer2="cd-glusterfs-11"

# alternative names
gfsServer_alt_0="emp-09"
gfsServer_alt_1="emp-10"
gfsServer_alt_2="emp-11"

# distributed directory
distrDir="/glusterfs/distributed"

# consumer volume directory:
# consDistrDir=""

# hosts setup
sudo cat > /etc/hosts <<EOF                                                                             /etc/hosts                                                                                        
127.0.0.1 localhost
127.0.1.1 $HOSTNAME

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

# primary names
192.168.0.9 $gfsServer0
192.168.0.10 $gfsServer1
192.168.0.11 $gfsServer2

# alternative name
192.168.0.9 $gfsServer_alt_0
192.168.0.10 $gfsServer_alt_1
192.168.0.11 $gfsServer_alt_2

EOF

# install 
sudo apt-get install glusterfs-server -y
sudo systemctl start glusterd
sudo systemctl enable glusterd



# -------------------------------------------------------------------------------
# Configuring GlusterFS
# Now that your servers are ready and GlusterFS is installed, it’s time to configure gluster. On $gfsServer0, create a trusted pool with the command:
# each server should probe the rest other than itself
if [ "$HOSTNAME" = $gfsServer0 ]; then
    sudo gluster peer probe $gfsServer1
    sudo gluster peer probe $gfsServer2
else
    printf '%s\n' "...moving next"
fi

if [ "$HOSTNAME" = $gfsServer1 ]; then
    sudo gluster peer probe $gfsServer0
    sudo gluster peer probe $gfsServer2
else
    printf '%s\n' "moving next"
fi

if [ "$HOSTNAME" = $gfsServer2 ]; then
    sudo gluster peer probe $gfsServer0
    sudo gluster peer probe $gfsServer1
else
    printf '%s\n' "done"
fi


# You should see peer probe: success returned.

# Verify the status of the two peers with the command:
sudo gluster peer status
# You should see that $gfsServer1 is connected

# # -------------------------------------------------------------------------------------------------------------------
# # Creating a distributed volume $consDistrDir

# gfsServer0="cd-glusterfs-09"
# gfsServer1="cd-glusterfs-10"
# gfsServer2="cd-glusterfs-11"

# # dirctory: can be dedicated to given consumer
consDistrDir="ff6e24d8-f1cb-44e4-ad53-1cc62db0c45b"
# # a volume can be defined by end user within a consumer
# # simulate a client id with uuidgen
uid="2bafb89d-700d-48d8-a367-24cf42f25293"

# # We’ll next create a distributed volume. I would highly recommend you create this volume on a partition 
# # that isn’t within the system directory (aka, not on the same drive that your OS is hosted on). 
# # If you create this volume on the same drive as the OS, you could run into sync errors.
# # Let’s create a new directory for GlusterFS (on $gfsServer0, $gfsServer1 and $gfsServer2) with the command:
sudo mkdir -p /glusterfs/$consDistrDir
# sudo mkdir -p $distrDir

# # ----------------------------------------------------------------------

# # With the directory created, we can now create a volume (named vol-$uid) that will replicate on both 
# # $gfsServer0, $gfsServer1 and $gfsServer2. 
# # WARNING:
# # volume create: vol-$uid: failed: The brick $gfsServer0:/glusterfs/$consDistrDir is being created in the root partition. 
# # It is recommended that you don't use the system's root partition for storage backend. Or use 'force' at the end of the command if you want to override this behavior.
# # The command for this is: 
sudo gluster volume create vol-$uid replica 3 transport tcp $gfsServer0:/glusterfs/$consDistrDir $gfsServer1:/glusterfs/$consDistrDir $gfsServer2:/glusterfs/$consDistrDir force
sudo gluster volume start vol-$uid

# # mount the volume on each of the servers
# # On $gfsServer0 issue the command:
sudo mount -t glusterfs $gfsServer0:/vol-$uid /mnt

# # On $gfsServer1 issue the command:
sudo mount -t glusterfs $gfsServer1:/vol-$uid /mnt

# # On $gfsServer2 issue the command:
sudo mount -t glusterfs $gfsServer2:/vol-$uid /mnt