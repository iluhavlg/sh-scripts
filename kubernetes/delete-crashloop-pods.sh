#!/bin/bash
echo List of k8s Namespaces:
# Получить список всех неймспейсов
kubectl get ns|grep Active|awk '{print $1}'
echo ----------------------------------------------
echo Enter the Namespace to delete CrashLoopBackOff pods:
read NAMESPACE
echo Deleting pods in CrashLoopBackOff status in namespace $NAMESPACE

for each in $(kubectl get pods -n $NAMESPACE|grep CrashLoopBackOff|awk '{print $1}');
do
kubectl delete pods $each -n $NAMESPACE --force --grace-period=0
done