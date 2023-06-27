#!/bin/bash

lxc_container="microk8s-10"
lxc file push k8s-deploy-innodb-cluster.sh $lxc_container/tmp/
lxc file push k8s-mysql-operator.sh $lxc_container/tmp/
lxc exec $lxc_container -- sh /tmp/k8s-mysql-operator.sh