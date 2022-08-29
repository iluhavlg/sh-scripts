#!/bin/bash
NAMESPACE=eyevox
helm list -n $NAMESPACE
echo ----------------------------------------------
echo Enter the filter for helm releases to delete:

read FILTER

for each in $(helm list -n $NAMESPACE |grep $FILTER|awk '{print $1}');
do
 helm uninstall -n $NAMESPACE $each
done
