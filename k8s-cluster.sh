#!/bin/bash

if [ "$1" == "create" ]; then
  kind create cluster --name three-nodes-cluster --config k8s/kind-3nodes.yaml;
elif [ "$1" == "delete" ]; then
    kind delete cluster --name "$(kind get clusters)";
  else
    kind get clusters;
fi
