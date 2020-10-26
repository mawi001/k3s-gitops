# Setup

## Requirements

At this moment you need at least to following:

- Running k3s RPI cluster


## Helm deploy flux and helmOperator

Deploy flux and helmOperator for RPI

Export KUBECONFIG
```sh
export KUBECONFIG=~/.kube/config-k3s
```

Cluster status
```sh
✔  mawi@wii  …/k3s-gitops/setup  master ?  k get node
NAME        STATUS   ROLES    AGE   VERSION
worker-02   Ready    <none>   12d   v1.19.2+k3s1
worker-01   Ready    <none>   12d   v1.19.2+k3s1
master-01   Ready    master   12d   v1.19.2+k3s1
```


Use `run.sh` to deploy

```sh
./run.sh
+ echo 'Deploy Flux'
Deploy Flux
+ helm upgrade -i flux --values https://raw.githubusercontent.com/mawi001/k3s-gitops/master/setup/flux/flux/flux-values.yaml fluxcd/flux --namespace flux
Release "flux" has been upgraded. Happy Helming!
NAME: flux
LAST DEPLOYED: Sat Oct 24 22:04:11 2020
NAMESPACE: flux
STATUS: deployed
REVISION: 5
TEST SUITE: None
NOTES:

```

Add deploy key to repo
![](assets/README-ced13979.png)
