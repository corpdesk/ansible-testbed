#!/bin/bash

# Each vm-host machine will have a vagrant file deploying 5 vms
# In the current script zone is identified by the vm-host host name
#


targetFile="Vagrantfile";
subhostDir="../initial-user/sub-hosts";
vmBox="bento/ubuntu-22.04";
vmMem="2048";
netBase="192.168.1";

# /////////////////////////////////////////////////
hostData="hosts.json";
# get all the hosts
hosts=$(jq ".hosts" "$hostData");
hostsLen=$(echo "$hosts" | jq '. | length');
echo "value of hostsLen is $hostsLen";

initIpNum=201;
i=0;
while [ $i -lt $hostsLen ]
do
    # use -r to remove the double quotes
    # g=$( echo "$vmHosts" | jq -r ".[$i].name")
    hn=$( echo "$hosts" | jq -r ".[$i].host_name")
    ip=$( echo "$hosts" | jq -r ".[$i].ip")
    isVmHost=$( echo "$hosts" | jq -r ".[$i].is_vm_host")
    isActive=$( echo "$hosts" | jq -r ".[$i].is_active")
    echo "the value of ip is $ip";
    # echo "the value of isVm is $isVm";
    if [ $isVmHost = true ] && [ $isActive = true ]
    then
        # if not exists, create subhost directory named with vm-host ip
        mkdir -p $subhostDir/$ip;
        rm -f $subhostDir/$ip/$targetFile;
        touch "$subhostDir/$ip/$targetFile";
        zone="$hn"
        #ip range:
        lIp="$initIpNum";
        hIp=$(($initIpNum + 4));
        echo "the value of lIp is $lIp";
        echo "the value of hIp is $hIp";
        
        {
            echo "# -*- mode: ruby -*-";
            echo "# vi: set ft=ruby :";
            
            echo "VAGRANTFILE_API_VERSION = \"2\"";
            echo "Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|";
            echo "  # General Vagrant VM configuration.e";
            echo "  config.vm.box = \"$vmBox\"";
            echo "  config.ssh.insert_key = false";
            echo "  config.vm.synced_folder \".\", \"/vagrant\", disabled: true";
            
            echo "  zone=\"$zone\"";
            
            # the section below to be implemented using a loop with date fed from json file
            echo "  # setup devops user";
            echo "  config.vm.provision \"file\", source: \"remove_devops.sh\", destination: \"remove_devops.sh\"";
            echo "  config.vm.provision \"file\", source: \"reset_environment.sh\", destination: \"reset_environment.sh\"";
            echo "  config.vm.provision \"file\", source: \"setup_initial_user.sh\", destination: \"setup_initial_user.sh\"";
            echo "  # config.vm.provision \"file\", source: \"init_cluster.js\", destination: \"init_cluster.js\"";
            echo "  # config.vm.provision \"file\", source: \"build_cluster.js\", destination: \"build_cluster.js\"";
            echo "  config.vm.provision :shell, :inline => \"sudo sh setup_initial_user.sh\"";
            
            echo "#   config.vm.provision \"shell\", inline: \"sudo apt-get update; sudo ln -sf /usr/bin/python3 /usr/bin/python\"";
            echo "#   config.vm.provision \"ansible\" do |ans| ";
            echo "#     ans.playbook = \"setup_initial_user.yaml\"";
            echo "#     ans.inventory_path = \"hosts.ini\"";
            echo "#   end";
            
            echo "  # network setup";
            echo "  config.vm.network \"public_network\", bridge: \"wlp2s0: Wi-Fi (AirPort)\", auto_config: true";
            
            echo "  config.vm.provider :virtualbox do |v|";
            echo "    v.memory = $vmMem";
            echo "    v.linked_clone = true";
            echo "  end";
            
            echo "  ($lIp..$hIp).each do |i|";
            echo "    config.vm.define \"cd-db-#{zone}-#{i}\" do |app|";
            echo "      app.vm.hostname = \"cd-db-#{zone}-#{i}\"";
            echo "      app.vm.network :public_network, ip: \"$netBase.#{i}\"";
            echo "    end";
            echo "  end";
            
            echo "end";
            
        }  >> "$subhostDir/$ip/$targetFile";
        echo "$subhostDir/$ip/$targetFile";
    else
        echo "is not vm"
    fi
    initIpNum=$(($initIpNum + 5));
    i=$(($i + 1))
done

# /////////////////////////////////////////////////



