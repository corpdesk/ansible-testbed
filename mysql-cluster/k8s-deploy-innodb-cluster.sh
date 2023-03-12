#!/bin/bash

# To create an InnoDB Cluster with kubectl, first create a secret containing credentials 
# for a new MySQL root user, a secret named 'mypwds' in this example: 
kubectl create secret generic mypwds \
        --from-literal=rootUser=root \
        --from-literal=rootHost=% \
        --from-literal=rootPassword="sakila"

# Use that newly created user to configure a new MySQL InnoDB Cluster. This example's 
# InnoDBCluster definition creates three MySQL server instances and one MySQL Router instance: 

cat > mycluster.yaml <<EOF
apiVersion: mysql.oracle.com/v2
kind: InnoDBCluster
metadata:
  name: mycluster
spec:
  secretName: mypwds
  tlsUseSelfSigned: true
  instances: 3
  router:
    instances: 1

EOF

microk8s kubectl apply -f mycluster.yaml
microk8s kubectl get innodbcluster --watch