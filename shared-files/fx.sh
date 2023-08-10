#!/bin/bash

func1 (){
   fun="$1"
   book="$2"
   printf "func=%s,book=%s\n" "$fun" "$book"
}

func2 (){
   fun2="$1"
   book2="$2"
   printf "func2=%s,book2=%s\n" "$fun2" "$book2"
}

fxGitAnsibleTestbed(){
    if [ -d "/home/emp-06/test/ansible-testbed" ] 
    then
        echo "--------$(hostname)/host-update-cluster.sh: cloud-brix files for ${HOST_USER}  will be updated"
        cd /home/emp-06/test/ansible-testbed
        git pull
        cd /home/emp-06/
    else
        mkdir -p /home/emp-06/test/
        cd /home/emp-06/test/
        echo "--------$(hostname)/host-update-cluster.sh: updating source files for ${HOST_USER}"
        git clone https://github.com/corpdesk/ansible-testbed.git
    fi
}