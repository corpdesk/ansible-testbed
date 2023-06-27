#!/bin/bash


# first install the Custom Resource Definition (CRD) used by MySQL Operator for Kubernetes:
microk8s kubectl apply -f https://raw.githubusercontent.com/mysql/mysql-operator/trunk/deploy/deploy-crds.yaml
# next deploy MySQL Operator for Kubernetes, which also includes RBAC definitions as noted in the output: 
microk8s kubectl apply -f https://raw.githubusercontent.com/mysql/mysql-operator/trunk/deploy/deploy-operator.yaml
# Verify that the operator is running by checking the deployment that's managing the operator inside the mysql-operator 
# namespace, a configurable namespace defined by deploy-operator.yaml: 
microk8s kubectl get deployment mysql-operator --namespace mysql-operator
sleep 20
microk8s kubectl get events --namespace mysql-operator
microk8s kubectl get deployment mysql-operator --namespace mysql-operator
sleep 20
microk8s kubectl get events --namespace mysql-operator
microk8s kubectl get deployment mysql-operator --namespace mysql-operator