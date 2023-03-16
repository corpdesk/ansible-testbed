# ----------------------------------------------------------------------------
gfsServer0="cd-glusterfs-20"
gfsServer1="cd-glusterfs-21"
gfsServer2="cd-glusterfs-22"

gfsClient0="cd-glusterfs-30"
gfsClient1="cd-glusterfs-31"

# dirctory: can be dedicated to given consumer
consDistrDir="ff6e24d8-f1cb-44e4-ad53-1cc62db0c45b"

# simulate a client id with uuidgen
uid="2bafb89d-700d-48d8-a367-24cf42f25293"



# ------------------------------------------------------------------------------

# gfs-server
# this should be a name registered at dns or hosts linked to a floating ip address for the gfs servers
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

192.168.3.30 $gfsClient0
192.168.3.31 $gfsClient1

EOF


# Installing the GlusterFS Client and Connecting to the Distributed Volume
# It’s now time to install the GlusterFS client. We’ll do this on cd-glusterfs-30. For this, issue the command:
sudo apt install glusterfs-client -y

# Create a new mount point for GlusterFS on cd-glusterfs-30 with the command:
sudo mkdir -p /mnt/glusterfs

# We can now mount the distributed file system with the command:
sudo mount -t glusterfs $gfsServer0:/vol-$uid /mnt/glusterfs/

# Finally, you’ll want to make sure the distributed file system is mounted at boot. 
# To do this, you’ll need to edit the /etc/fstab file with the command:
sudo echo "$gfsServer0:/vol-$uid /mnt/glusterfs glusterfs defaults,_netdev 0 0" >> /etc/fstab

# -----------------------------------------------------------
# Testing the Filesystem

# Move over to cd-glusterfs-30 and create a test file with the command:
sudo touch /mnt/glusterfs/thenewstack

# Check to make sure the new file appears on both $gfsServer0, $gfsServer1 and $gfsServer2 with the command (run on all glusterfs servers):
ls /mnt
# You should see thenewstack appear in the directories.