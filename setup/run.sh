#!/usr/bin/env bash
set -xe

echo "Deploy Flux"
helm upgrade -i flux --values https://raw.githubusercontent.com/mawi001/k3s-gitops/master/setup/flux/flux/flux-values.yaml \
  fluxcd/flux \
  --namespace flux

echo "Deploy helmOperator"
helm upgrade -i helm-operator --values https://raw.githubusercontent.com/mawi001/k3s-gitops/master/setup/flux/helm-operator/helm-operator-values.yaml \
 fluxcd/helm-operator \
  --namespace flux

echo "Print Flux SSH pubkey"
# print flux pubkey
kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2
