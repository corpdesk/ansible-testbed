#!/bin/bash

# assuming lxd cluster is already running,
# you are logged in to any physical server in cb environment

clusterMember="routed-93"
controllerUser="emp-09"
controllerIp="192.168.0.9"
controllerMember="$controllerUser@$controllerIp"
initialUser=""
pswd=""
# hash created by:
# python -c 'import crypt; print crypt.crypt("yU0B14NC1PdE", "$1$SomeSalt$")'
# as used earlier in shell script: sudo useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash devops
# recommended: openssl passwd -salt SomeSalt -1 yU0B14NC1PdE
appName="cd-sql"
image="ubuntu:22.04"
targetApp="mysql-cluster"
from=0
to=2

initAppContainer( $appContainer, $initialUser, $pswd){
    echo "starting initAppContainer($appContainer, $initialUser, $pswd)"
    # push initial user file
    lxc file push $initUserFile $appContainer/tmp/
    # push reset_env file
    lxc file push $resetEnvFile $appContainer/tmp/
    #
    # ------------------------------------------------
    # setup ssh user to allow ansible operations
    lxc exec $appContainer -- useradd -m -p $(openssl passwd -1 mypassword) $initialUser
    $appIp=$(lxc list -c4 --format csv $cname | cut -d' ' -f1)
    # ssh-copy-id to new container from all the controllers
    ssh emp-09@192.168.0.9  ssh-copy-id -i /home/emp-09/.ssh/id_rsa.pub $initialUser@$appIp
    ssh emp-10@192.168.0.10 ssh-copy-id -i /home/emp-10/.ssh/id_rsa.pub $initialUser@$appIp
    ssh emp-11@192.168.0.11 ssh-copy-id -i /home/emp-11/.ssh/id_rsa.pub $initialUser@$appIp
    # initial_user: devops
    # hash created by:
    # python -c 'import crypt; print crypt.crypt("yU0B14NC1PdE", "$1$SomeSalt$")'
    # as used earlier in shell script: sudo useradd -m -p \$6\$QGFip3kXOicYeuKf\$pq3AMKWm9G6/iWtu10G6ciExPjRNcGZRL5Gni6zEHg46juPx4ZSSPkBMZLAF/WBfclfDbuSi4KXGW7b4hg1pH/ -s /bin/bash devops
    # recommended: openssl passwd -salt SomeSalt -1 yU0B14NC1PdE
}

initAppMaintainer(){
    # launch maintainers
    # confirm numbers are always the requred
    # if less create to the required number
    # if more kill excess
}

installApp( $targetApp,$appName-$i ){

}


if[[$lxcCount -gt 1]]
then
    for i in $(seq $from $to); do
    # launch application container
    ssh $controllerMember lxc exec $clusterMember -- lxc launch ubuntu:22.04 $appName-$i

    # sleep to allow ip propergation
    sleep 10

    # set initial user, install default apps
    initAppContainer( $appContainer, $initialUser, $pswd);

    # install and configure target app
    installApp( $targetApp,$appName-$i);

    # initialize application auto mainterners
    initAppMaintainer();

    done
else
    lxc exec $clusterMember -- lxc launch ubuntu:22.04 $appName

    # sleep to allow ip propergation
    sleep 10

    # set initial user, install default apps
    initAppContainer( $appContainer, $initialUser, $pswd);

    # install and configure target app
    installApp( $targetApp,$appName-$i);

    # initialize application auto mainterners
    initAppMaintainer();
fi




