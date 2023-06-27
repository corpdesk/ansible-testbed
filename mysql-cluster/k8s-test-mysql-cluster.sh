#!/bin/bash

# Use that newly created user to configure a new MySQL InnoDB Cluster. This example's 
# InnoDBCluster definition creates three MySQL server instances and one MySQL Router instance: 

microk8s kubectl run --rm -it myshell --image=mysql/mysql-operator -- mysqlsh root@mycluster --sql
# expected tests:
# MySQL mycluster SQL> SELECT @@hostname