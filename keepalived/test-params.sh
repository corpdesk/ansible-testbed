#!/bin/bash
echo "$1"
echo "$2"
echo "$3"
echo "$4"
echo "$5"
# echo "$6"

priority=$1
nic=$2 # This may be eth0 if lxd or eth1 if vagrant...confirm in any case
fId=$3
targetPort=$4
mode=$5
# nodes=$6
echo $(pwd)
nodes=$(cat /home/emp-07/ansible-testbed/keepalived/nodes.data)


echo "priority=$priority"
echo "nic=$nic"
echo "fId=$fId"
echo "targetPort=$targetPort"
echo "mode=$mode"
echo "nodes=$nodes"

# myFunction()
# {
#     # eval string1="$1"
#     # eval string2="$2"
#     # eval string3="$3"

#     eval priority=$1
#     eval nic=$2 # This may be eth0 if lxd or eth1 if vagrant...confirm in any case
#     eval fId=$3
#     eval targetPort=$4
#     eval mode=$5
#     eval nodes=$6

#     # echo "string1 = ${string1}"
#     # echo "string2 = ${string2}"
#     # echo "string3 = ${string3}"

#     echo "priority=$priority"
#     echo "nic=$nic"
#     echo "fId=$fId"
#     echo "targetPort=$targetPort"
#     echo "mode=$mode"
#     echo "nodes=$nodes"
# }
