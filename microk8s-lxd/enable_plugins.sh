#!/bin/bash
# Ref: https://microk8s.io/docs/addon-mayastor

networkName="microk8s"
networkId="192.168.2"
remoteUser="devops"

# The nvme_fabrics and nvme_tcp modules are required on all hosts. Install the modules with:
# sudo apt install linux-modules-extra-$(uname -r)

# Then enable them with:
# sudo modprobe nvme_tcp
# echo 'nvme-tcp' | sudo tee -a /etc/modules-load.d/microk8s-mayastor.conf

# edit microk8s profile
# lxc profile edit microk8s
# add 'nvme_tcp' to the list of config.linux.kernel_modules list




# create containers
for i in 0 1 2
do
    echo "current container: $networkName-1$i"
    # ################################################
    # # Enable DNS (Use add-ons)
    # # MicroK8s uses the minimum of components for a pure, lightweight Kubernetes. However, plenty of extra features are available with a few keystrokes using “add-ons” - pre-packaged components that will provide extra capabilities for your Kubernetes, from simple DNS management to machine learning with Kubeflow!
    # # To start it is recommended to add DNS management to facilitate communication between services. For applications which need storage, the ‘hostpath-storage’ add-on provides directory space on the host. These are easy to set up:

    lxc exec $networkName-1$i -- microk8s enable dns ingress community hostpath-storage rbac helm3
    # # microk8s enable metallb:192.168.2.131-192.168.2.135

    ################################################
    # enable openebs

    # # HugePages must be enabled. Mayastor requires at least 1024 4MB HugePages.
    # # This can be achieved by running the following commands on each host:
    # lxc exec $networkName-1$i -- sudo sysctl vm.nr_hugepages=1024

    # How to enable huge pages in lxc containers?
    # https://discuss.linuxcontainers.org/t/how-to-enable-huge-pages-in-lxc-containers/14628
    # Ref: https://discuss.linuxcontainers.org/t/lxd-3-22-has-been-released/7027
    lxc stop $networkName-1$i
    lxc config set $networkName-1$i security.syscalls.intercept.mount true
    lxc config set $networkName-1$i security.syscalls.intercept.mount.allowed hugetlbfs
    lxc config set $networkName-1$i limits.hugepages.2MB 1GB
    lxc start $networkName-1$i
    # ------------------------------------

    lxc exec $networkName-1$i -- sudo systemctl enable iscsid
    
    lxc exec $networkName-1$i -- echo vm.nr_hugepages = 1024 | sudo tee -a /etc/sysctl.d/20-microk8s-hugepages.conf
    # lxc exec $networkName-1$i -- echo 'vm.nr_hugepages=1024' | sudo tee -a /etc/sysctl.conf

    # You should restart MicroK8s at this point:
    lxc exec $networkName-1$i -- microk8s stop
    sleep 10
    lxc exec $networkName-1$i -- microk8s start
    sleep 20

    # # Enable the Mayastor addon:
    lxc exec $networkName-1$i -- microk8s enable core/mayastor --default-pool-size 20G
done