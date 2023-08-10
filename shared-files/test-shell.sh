#!/bin/bash

# global variables
export HOST_USER="emp-09"
export HOST_NAME="emp-09"
export CB_OPERATOR="devops"
export CLUSTER_MEMBER="routee-93"
export EXEC_FILE="host-update-cluster.sh"
export SHARED_FILES_HOST="/home/${HOST_USER}/ansible-testbed/shared-files"
export SHARED_FILES_CLUSTER_MEMBER="/home/${CB_OPERATOR}/ansible-testbed/shared-files"


# print header
cmdHead='
    source ./fx.sh
    fxHeader'

# clone or update files
cmdGit='
    source ./fx.sh
    fxSubHeader "Update files from Git"
    fxGit "ansible-testbed" "https://github.com/corpdesk/ansible-testbed.git"'


# push cb files to /tmp/ dir for cluster member
cmdPushClusterFilesTmp='
    source ./fx.sh
    fxSubHeader "Move cb files to /tmp/ directory at ${CLUSTER_MEMBER}"
    fxPushClusterTmpFile "fx.sh"                
    fxPushClusterTmpFile "worker-init-user.sh"  
    fxPushClusterTmpFile "cluster-init-user.sh" 
    fxPushClusterTmpFile "pre-init-user.sh"     
    fxPushClusterTmpFile "ssh-key.sh"           
    fxPushClusterTmpFile "ssh-copy-id.sh"       
    fxPushClusterTmpFile "p"'

# execute init-user in cluster member
cmdInitClusterUser='
    source ./fx.sh
    fxSubHeader "Execute ${EXEC_FILE} at ${CLUSTER_MEMBER}"
    fxExecClusterTmpFile "cluster-init-user.sh"'

# push cb files to ~/.cb/ dir for cluster member
cmdPushClusterFilesCb='
    source ./fx.sh
    fxSubHeader "PUSH POST-INITIAL FILES TO $clusterMember/home/$operator/.cb/ DIRECTORY"
    fxPushClusterCbFile "cluster-init-user.sh"          "" 
    fxPushClusterCbFile "p"                             ""
    fxPushClusterCbFile "cluster-update-worker.sh"      ""
    fxPushClusterCbFile "cluster-update-dirs.sh"        ""
    fxPushClusterCbFile "init_cluster.js"               ""
    fxPushClusterCbFile "init_build_cluster.js"         "mysql-shell-scripts/"
    fxPushClusterCbFile "build_cluster.js"              "mysql-shell-scripts/"'

# reset permissions for operator in the cluster member   
cmdClusterMemberResetPerm='
    source ./fx.sh
    fxSubHeader "PUSH POST-INITIAL FILES TO $clusterMember/home/$operator/.cb/ DIRECTORY"
    fxClusterMemberResetPerm'

# do cb bootstrap the worker containers
# containers would be for specific project eg db containers for given projects
cmdExecClusterFilesCb='
    source ./fx.sh
    fxSubHeader "Execute ${EXEC_FILE} at ${CLUSTER_MEMBER}"
    fxExecClusterCbFile "cluster-update-worker.sh"'
    
# run scripts in this file
cmd="$cmdHead;$cmdGit;$cmdPushClusterFilesTmp;$cmdInitClusterUser;$cmdPushClusterFilesCb;$cmdClusterMemberResetPerm;$cmdExecClusterFilesCb;"
bash -c "$cmd"

