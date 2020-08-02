#!/bin/bash

if [ "$1" == "create" ]; then
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.8.1/kind-linux-amd64
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/
  kind create cluster --name three-nodes-cluster --config k8s/kind-3nodes.yaml;
elif [ "$1" == "delete" ]; then
    kind delete cluster --name "$(kind get clusters)";
  else
    kind get clusters;
fi
