#!/bin/bash

# Randomly delete pods in a Kubernetes namespace.
#Expects partial namespace value to get complete namespace name.

partialNamespaceValue=$1;
set -ex

namespaceName=`kubectl get pods --all-namespaces -o wide | grep $partialNamespaceValue | tr -s ' ' | cut -d ' ' -f1 | head -1`

: ${DELAY:=300}
: ${NAMESPACE:=$namespaceName}

while true; do
  kubectl \
    --namespace "${NAMESPACE}" \
    -o 'jsonpath={.items[*].metadata.name}' \
    get pods | \
      tr " " "\n" | \
      shuf | \
      head -n 1 |
      xargs -t --no-run-if-empty \
        kubectl --namespace "${NAMESPACE}" delete pod
  sleep "${DELAY}"
#/bin/sh gtPodInfo.sh $partialNamespaceValue
done
