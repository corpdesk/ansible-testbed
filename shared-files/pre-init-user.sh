#!/bin/bash

operator="devops"
clusterMember="routed-93"
echo "--------updating $clusterMember"
sudo apt update
echo "--------upgradinig $clusterMember"
sudo apt upgrade -y
echo "--------installing git"
sudo apt install git -y
echo "--------installing net-tools"
sudo apt install net-tools -y
echo "--------installing telnet"
sudo apt install telnet -y
echo "--------installing sshpass"
sudo apt install sshpass -y
echo "--------installing tree"
sudo apt install tree -y
echo "--------installing fish"
sudo apt install fish -y
echo "--------installing jq"
sudo apt install jq -y
echo "--------installing tracetoute"
sudo apt install traceroute  -y
