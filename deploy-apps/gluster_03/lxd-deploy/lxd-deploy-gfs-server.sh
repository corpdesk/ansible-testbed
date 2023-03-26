#!/bin/bash

# Ref: https://thenewstack.io/tutorial-deploy-a-highly-availability-glusterfs-storage-cluster/

# You need to run <projDir>/deploy-apps/gluster_03/lxd-deploy/lxd-deploy-gluster-containers.sh to create lxc containers to host glusterfs servers
# This is a script for setting up glusterfs server
# after this script  is done, go to <projDir>/deploy-apps/gluster_03/lxd-deploy/lxd-deploy-gfs-domain.sh to create 
# glusterfs clients (cloud-brix storage domains)
# storage domains are the ones consumed by application clients(eg corpdesk) and treated like webservers.

gfsServer0="cd-glusterfs-20"
gfsServer1="cd-glusterfs-21"
gfsServer2="cd-glusterfs-22"

# hosts setup
cat > /etc/hosts <<EOF                                                                                   
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

192.168.3.20 $gfsServer0
192.168.3.21 $gfsServer1
192.168.3.22 $gfsServer2


EOF

# install 
sudo apt-get install glusterfs-server -y
sudo systemctl start glusterd
sudo systemctl enable glusterd



# -------------------------------------------------------------------------------
# Configuring GlusterFS
# Now that your servers are ready and GlusterFS is installed, it’s time to configure gluster. On $gfsServer0, create a trusted pool with the command:
sudo gluster peer probe $gfsServer1
sudo gluster peer probe $gfsServer2
# You should see peer probe: success returned.

# Verify the status of the two peers with the command:
sudo gluster peer status
# You should see that $gfsServer1 is connected

# # -------------------------------------------------------------------------------------------------------------------
# # Creating a $consDistrDir Volume

# # dirctory: can be dedicated to given consumer
# consDistrDir="ff6e24d8-f1cb-44e4-ad53-1cc62db0c45b"
# # a volume can be defined by end user within a consumer
# # simulate a client id with uuidgen
# uid="2bafb89d-700d-48d8-a367-24cf42f25293"

# # We’ll next create a distributed volume. I would highly recommend you create this volume on a partition 
# # that isn’t within the system directory (aka, not on the same drive that your OS is hosted on). 
# # If you create this volume on the same drive as the OS, you could run into sync errors.
# # Let’s create a new directory for GlusterFS (on $gfsServer0, $gfsServer1 and $gfsServer2) with the command:
# sudo mkdir -p /glusterfs/$consDistrDir

# # ----------------------------------------------------------------------

# # With the directory created, we can now create a volume (named vol-$uid) that will replicate on both 
# # $gfsServer0, $gfsServer1 and $gfsServer2. 
# # WARNING:
# # volume create: vol-$uid: failed: The brick $gfsServer0:/glusterfs/$consDistrDir is being created in the root partition. 
# # It is recommended that you don't use the system's root partition for storage backend. Or use 'force' at the end of the command if you want to override this behavior.
# # The command for this is: 
# sudo gluster volume create vol-$uid replica 3 transport tcp $gfsServer0:/glusterfs/$consDistrDir $gfsServer1:/glusterfs/$consDistrDir $gfsServer2:/glusterfs/$consDistrDir force
# sudo gluster volume start vol-$uid

# # mount the volume on each of the servers
# # On $gfsServer0 issue the command:
# sudo mount -t glusterfs $gfsServer0:/vol-$uid /mnt

# # On $gfsServer1 issue the command:
# sudo mount -t glusterfs $gfsServer1:/vol-$uid /mnt

# # On $gfsServer2 issue the command:
# sudo mount -t glusterfs $gfsServer2:/vol-$uid /mnt