#!/bin/bash
# Script variables:
#   - ip Range
#   - lIp
#   - hIp

targetFile="Vagrantfile";
vmBox="bento/ubuntu-22.04";
vmMem="2048";
netBase="192.168.1";
zone="107"
#ip range:
lIp=176;
hIp=178;
rm -f $targetFile;

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
    echo "  config.vm.provision \"file\", source: \"init_cluster.js\", destination: \"init_cluster.js\"";
    echo "  config.vm.provision \"file\", source: \"build_cluster.js\", destination: \"build_cluster.js\"";
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

}  >> "$targetFile"
