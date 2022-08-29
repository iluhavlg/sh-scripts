#!/bin/bash
echo List of k8s Namespaces:
# Получить список всех неймспейсов
kubectl get ns|grep Active|awk '{print $1}'
echo ----------------------------------------------
echo Enter the Namespace to delete Terminating pods:
read NAMESPACE
echo Deleting Terminating pods in namespace $NAMESPACE

for each in $(kubectl get pods -n $NAMESPACE|grep Terminating|awk '{print $1}');
do
kubectl delete pods $each -n $NAMESPACE --force
done
