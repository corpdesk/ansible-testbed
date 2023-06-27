#!/bin/bash

# - this script is used to set up gluster client (cloud-brix storage).
# - cloud-brix maintains a number of webservers used for online storage
# - While initializing, a new consumer creates a subdomain on one of the servers.
# - The root directory for that subdomain is dedicated to storage for a given consumer

projDir="$HOME/ansible-testbed"
gfsServer0="cd-glusterfs-20"
gfsServer1="cd-glusterfs-21"
gfsServer2="cd-glusterfs-22"

serverFrom=20
serverTo=22

clientFrom=1
clientTo=2

# the name assigned to the client container (storage domain, in cloud-brix) and voluname at the server
storageDomain="stor-dom-000-1"

# gfsClient0="cd-glusterfs-30"
# gfsClient1="cd-glusterfs-31"
# gfsClient2="$storageDomain-1"
# $storageDomain

# ---------------------------
# ON THE SERVERS
# ---------------------------
# Creating a $storageDomain Volume



# We’ll next create a distributed volume. I would highly recommend you create this volume on a partition 
# that isn’t within the system directory (aka, not on the same drive that your OS is hosted on). 
# If you create this volume on the same drive as the OS, you could run into sync errors.
# Let’s create a new directory for GlusterFS (on $gfsServer0, $gfsServer1 and $gfsServer2) with the command:

for i in $(seq $serverFrom $serverTo); do
    if [ -d "/glusterfs/$storageDomain" ]; then
        ### Take action if /glusterfs/$storageDomain exists ###
        echo 'directory "/glusterfs/$storageDomain" already exits'
    else
        lxc exec cd-glusterfs-$i -- mkdir -p /glusterfs/$storageDomain
    fi
done 

# ----------------------------------------------------------------------

# With the directory created, we can now create a volume (named vol-$storageDomain) that will replicate on both 
# $gfsServer0, $gfsServer1 and $gfsServer2. 
# WARNING:
# volume create: vol-$storageDomain: failed: The brick $gfsServer0:/glusterfs/$storageDomain is being created in the root partition. 
# It is recommended that you don't use the system's root partition for storage backend. Or use 'force' at the end of the command if you want to override this behavior.
# The command for this is: 
lxc exec $gfsServer0 --  gluster volume create vol-$storageDomain replica 3 transport tcp $gfsServer0:/glusterfs/$storageDomain $gfsServer1:/glusterfs/$storageDomain $gfsServer2:/glusterfs/$storageDomain force
lxc exec $gfsServer0 --  gluster volume start vol-$storageDomain

# # mount the volume on each of the servers
# # On $gfsServer0 issue the command:
# sudo mount -t glusterfs $gfsServer0:/vol-$storageDomain /mnt

# # On $gfsServer1 issue the command:
# sudo mount -t glusterfs $gfsServer1:/vol-$storageDomain /mnt

# # On $gfsServer2 issue the command:
# sudo mount -t glusterfs $gfsServer2:/vol-$storageDomain /mnt

for i in $(seq $serverFrom $serverTo); do
    lxc exec "cd-glusterfs-$i" -- mount -t glusterfs "cd-glusterfs-$i:/vol-$storageDomain" /mnt
done 

# END OF SERVER ACTIONS (CREATE CLIENT VOLUME)
# -----------------------------

# ----------------------------------------------------------------------------
# START CLIENT ACTION (MOUNT SERVER VOLUME):
# ----------------------------------------------------------------------------


# # dirctory: can be dedicated to given consumer
# storageDomain="B0B3DA99-1859-A499-90F6-1E3F69575DCD"



# ------------------------------------------------------------------------------

# gfs-server
# this should be a name registered at dns or hosts linked to a floating ip address for the gfs servers
# # hosts setup
# cat > /etc/hosts <<EOF                                                                                   
# 127.0.0.1 localhost

# # The following lines are desirable for IPv6 capable hosts
# ::1 ip6-localhost ip6-loopback
# fe00::0 ip6-localnet
# ff00::0 ip6-mcastprefix
# ff02::1 ip6-allnodes
# ff02::2 ip6-allrouters
# ff02::3 ip6-allhosts

# 192.168.3.20 $gfsServer0
# 192.168.3.21 $gfsServer1
# 192.168.3.22 $gfsServer2

# 192.168.0.101 $storageDomain
# 192.168.3.82  $storageDomain

# EOF
# set hosts in the lxd host machine. Should be done to all potential clients. Eg front end servers
sudo sh "$projDir/deploy-apps/apache/shellInstall/setStorageHosts.sh"

# set hosts in the lxd container (storage domain)
lxc file push "$projDir/deploy-apps/apache/shellInstall/setStorageHosts.sh" $storageDomain/tmp/
lxc exec $storageDomain -- sh /tmp/setStorageHosts.sh

# for i in $(seq $clientFrom $clientTo); do
lxc exec $storageDomain -- apt update
# Installing the GlusterFS Client and Connecting to the Distributed Volume
# It’s now time to install the GlusterFS client. We’ll do this on cd-glusterfs-30. For this, issue the command:
lxc exec $storageDomain -- apt install glusterfs-client -y

# Create a new mount point for GlusterFS on cd-glusterfs-30 with the command:
lxc exec $storageDomain -- mkdir -p /mnt/glusterfs

# We can now mount the distributed file system with the command:
lxc exec $storageDomain -- mount -t glusterfs $gfsServer0:/vol-$storageDomain /mnt/glusterfs/

# Finally, you’ll want to make sure the distributed file system is mounted at boot. 
# To do this, you’ll need to edit the /etc/fstab file with the command:
lxc exec $storageDomain -- echo "$gfsServer0:/vol-$storageDomain /mnt/glusterfs glusterfs defaults,_netdev 0 0" >> /etc/fstab

# done

# install webserver
lxc file push $projDir/deploy-apps/apache/shellInstall/apacheInstall.sh $storageDomain/tmp/
lxc exec $storageDomain -- sh /tmp/apacheInstall.sh

lxc exec $storageDomain -- cat /etc/apache2/sites-available/000-default.conf
lxc exec $storageDomain -- sed -i 's/\/var\/www\/html/\/mnt\/glusterfs/g' /etc/apache2/sites-available/000-default.conf
lxc exec $storageDomain -- cat /etc/apache2/sites-available/000-default.conf
lxc exec $storageDomain -- cat /etc/apache2/apache2.conf
lxc exec $storageDomain -- sed -i 's/\/var\/www/\/mnt\/glusterfs/g' /etc/apache2/apache2.conf
lxc exec $storageDomain -- cat /etc/apache2/apache2.conf
lxc exec $storageDomain -- adduser ubuntu www-data
lxc exec $storageDomain -- chown -R www-data:www-data /mnt/glusterfs
lxc exec $storageDomain -- chmod -R g+rw /mnt/glusterfs
lxc exec $storageDomain -- chmod -R 755 /mnt/glusterfs
lxc exec $storageDomain -- echo -e "-- Restarting Apache web server\n"
lxc exec $storageDomain -- service apache2 restart

# -----------------------------------------------------------
# Testing the Filesystem

# Move over to cd-glusterfs-30 and create a test file with the command:
lxc exec $storageDomain -- touch /mnt/glusterfs/index.html
lxc exec $storageDomain -- nano /mnt/glusterfs/index.html

curl http://$storageDomain

# Check to make sure the new file appears on both $gfsServer0, $gfsServer1 and $gfsServer2 with the command (run on all glusterfs servers):
lxc exec $storageDomain -- ls /mnt
# You should see thenewstack appear in the directories.
lxc exec $storageDomain -- mkdir /mnt/glusterfs/B0B3DA99-1859-A499-90F6-1E3F69575DCD/user-resources
lxc exec $storageDomain -- chown -R www-data:www-data /mnt/glusterfs/B0B3DA99-1859-A499-90F6-1E3F69575DCD
lxc exec $storageDomain -- service apache2 restart
