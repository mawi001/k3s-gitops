# Lessons learned

List of lessons and gotchas from my project.

## Flux move deployment to different namespace won't deploy

I wanted to move a deployment `vault-secrets-operator` from `kube-system` to `vault` to put it next to `vault`

The change itself was only a `git mv`. After `fluxctl sync` the deployment was no longer in `kube-system` namespace, but also not in the `vault` namespace


Checking the logs of the `pod/helm-operator` showed why the install failed

```sh
ts=2020-10-26T23:04:00.25959977Z caller=release.go:79 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 info="starting sync run"
ts=2020-10-26T23:04:00.380637671Z caller=release.go:313 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 info="running installation" phase=install
ts=2020-10-26T23:04:04.250672256Z caller=release.go:316 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 error="installation failed: rendered manifests contain a resource that already exists. Unable to continue with install: existing resource conflict: namespace: , name: vaultsecrets.ricoberger.de, existing_kind: apiextensions.k8s.io/v1, Kind=CustomResourceDefinition, new_kind: apiextensions.k8s.io/v1, Kind=CustomResourceDefinition" phase=install
ts=2020-10-26T23:04:04.250888567Z caller=release.go:422 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 info="running uninstall" phase=uninstall
ts=2020-10-26T23:04:04.403989872Z caller=release.go:424 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 warning="uninstall failed: uninstall: Release not loaded: vault-secrets-operator: release: not found" phase=uninstall
ts=2020-10-26T23:07:00.262183441Z caller=release.go:79 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 info="starting sync run"
ts=2020-10-26T23:07:00.430016443Z caller=release.go:313 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 info="running installation" phase=install
ts=2020-10-26T23:07:04.164250983Z caller=release.go:316 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 error="installation failed: rendered manifests contain a resource that already exists. Unable to continue with install: existing resource conflict: namespace: , name: vaultsecrets.ricoberger.de, existing_kind: apiextensions.k8s.io/v1, Kind=CustomResourceDefinition, new_kind: apiextensions.k8s.io/v1, Kind=CustomResourceDefinition" phase=install
ts=2020-10-26T23:07:04.164380258Z caller=release.go:422 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 info="running uninstall" phase=uninstall
ts=2020-10-26T23:07:04.419581151Z caller=release.go:424 component=release release=vault-secrets-operator targetNamespace=vault resource=vault:helmrelease/vault-secrets-operator helmVersion=v3 warning="uninstall failed: uninstall: Release not loaded: vault-secrets-operator: release: not found" phase=uninstall
 ✔  mawi@wii  …/k3s-gitops/setup  master ?  k logs -n flux pod/helm-operator-67c9485d98-vgjbj | grep secret
```
it was because of the conflict with a crd

> error="installation failed: rendered manifests contain a resource that already exists. Unable to continue with install: existing resource conflict: namespace: , name: vaultsecrets.ricoberger.de,


The helm manifest contains the definition of this crd, but is was already deployed before and is a cluster-wide resource.

```sh
✔  mawi@wii  …/k3s-gitops/setup  master ?  k get crd | grep vaultsecrets.ricoberger.de
vaultsecrets.ricoberger.de              2020-10-26T21:58:31Z
```

Delete the crd

```sh
k delete crd vaultsecrets.ricoberger.de
customresourcedefinition.apiextensions.k8s.io "vaultsecrets.ricoberger.de" deleted
```

Sync

```sh
fluxctl --k8s-fwd-ns flux sync          
Synchronizing with ssh://git@github.com/mawi001/k3s-gitops.git
Revision of master to apply is ab069d7
Waiting for ab069d7 to be applied ...
Done.
```

More conflicts

```sh
k delete clusterrole vault-secrets-operator  
clusterrole.rbac.authorization.k8s.io "vault-secrets-operator" deleted

k delete  ClusterRoleBinding  vault-secrets-operator         
clusterrolebinding.rbac.authorization.k8s.io "vault-secrets-operator" deleted

```

Victory

Deployment is started.

***TODO***: find out the proper way to move deployments between namespaces or how to deal with conflicts

```sh
ts=2020-10-26T23:34:06.201400844Z caller=helm.go:69 component=helm version=v3 info="creating 6 resource(s)" targetNamespace=vault release=vault-secrets-operator
ts=2020-10-26T23:34:07.308738119Z caller=helm.go:69 component=helm version=v3 info="beginning wait for 6 resources with timeout of 5m0s" targetNamespace=vault release=vault-secrets-operator
ts=2020-10-26T23:34:10.458198382Z caller=helm.go:69 component=helm version=v3 info="Deployment is not ready: vault/vault-secrets-operator. 0 out of 1 expected pods are ready" targetNamespace=vault release=vault-secrets-operator
ts=2020-10-26T23:34:11.435028204Z caller=helm.go:69 component=helm version=v3 info="Deployment is not ready: vault/vault-secrets-operator. 0 out of 1 expected pods are ready" targetNamespace=vault release=vault-secrets-operator
ts=2020-10-26T23:34:13.509825873Z caller=helm.go:69 component=helm version=v3 info="Deployment is not ready: vault/vault-secrets-operator. 0 out of 1 expected pods are ready" targetNamespace=vault release=vault-secrets-operator
ts=2020-10-26T23:34:15.458889584Z caller=helm.go:69 component=helm version=v3 info="Deployment is not ready: vault/vault-secrets-operator. 0 out of 1 expected pods are ready" targetNamespace=vault release=vault-secrets-operator
ts=2020-10-26T23:34:17.862919743Z caller=helm.go:69 component=helm version=v3 info="Deployment is not ready: vault/vault-secrets-operator. 0 out of 1 expected pods are ready" targetNamespace=vault release=vault-secrets-operator
ts=2020-10-26T23:34:20.526274026Z caller=helm.go:69 component=helm version=v3 info="Deployment is not ready: vault/vault-secrets-operator. 0 out of 1 expected pods are ready" targetNamespace=vault release=vault-secrets-operator

```

Status

```sh
k get all -n vault -l app.kubernetes.io/instance=vault-secrets-operator
NAME                                          READY   STATUS             RESTARTS   AGE
pod/vault-secrets-operator-547987c964-mvccb   0/1     CrashLoopBackOff   2          48s

NAME                             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
service/vault-secrets-operator   ClusterIP   10.43.162.144   <none>        8383/TCP,8686/TCP   50s

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/vault-secrets-operator   0/1     1            0           50s

NAME                                                DESIRED   CURRENT   READY   AGE
replicaset.apps/vault-secrets-operator-547987c964   1         1         0       50s
```


## Flux does not deploy the changes that you expect

There might be something wrong. Check the `helm-operator` logs.

```sh
k logs -n flux -l app=helm-operator -f
```

Example:

- commit metrics-server deployment
- run `fluxctl sync`

expected result:

`metrics-server` pod running in `kube-system` namespace

actual result:

*nothing happened*

Checking logs showed a conflict caused by leftovers from previous metrics-server deployment (non-flux)

```sh
k logs -n flux -l app=helm-operator  | grep metrics
ts=2020-10-27T11:01:07.978290925Z caller=release.go:316 component=release release=metrics-server targetNamespace=kube-system resource=kube-system:helmrelease/metrics-server helmVersion=v3 error="installation failed: rendered manifests contain a resource that already exists. Unable to continue with install: existing resource conflict: namespace: kube-system, name: metrics-server, existing_kind: /v1, Kind=Service, new_kind: /v1, Kind=Service" phase=install
ts=2020-10-27T11:01:07.978400978Z caller=release.go:422 component=release release=metrics-server targetNamespace=kube-system resource=kube-system:helmrelease/metrics-server helmVersion=v3 info="running uninstall" phase=uninstall
ts=2020-10-27T11:01:08.28494049Z caller=release.go:424 component=release release=metrics-server targetNamespace=kube-system resource=kube-system:helmrelease/metrics-server helmVersion=v3 warning="uninstall failed: uninstall: Release not loaded: metrics-server: release: not found" phase=uninstall
```

Deleting the conflicting resource resolved



## Get (really) all resources

`k get all -A` does not list roles and ClusterRoleBinding for example.

To troubleshoot issues it helps to get really all resources in the cluster.

Krew can help

https://github.com/kubernetes-sigs/krew

Install https://krew.sigs.k8s.io/docs/user-guide/setup/install/#bash



Get all resources created in the last 24h

```sh
✔  mawi@wii  …/k3s-gitops/setup  master ● ?  kubectl get-all --since 1d
WARN[0000] Could not fetch complete list of API resources, results will be incomplete: unable to retrieve the complete list of server APIs: metrics.k8s.io/v1beta1: the server is currently unable to handle the request
W1027 12:24:58.647328   31205 warnings.go:67] v1 ComponentStatus is deprecated in v1.19+
W1027 12:25:10.714100   31205 warnings.go:67] extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
NAME                                                                      NAMESPACE    AGE
configmap/vault-config                                                    vault        13h  
configmap/vault-secrets-operator-lock                                     vault        11h  
endpoints/vault-secrets-operator                                          vault        11h  
endpoints/vault                                                           vault        12h  
persistentvolumeclaim/vault-data-vault-0                                  vault        11h  
persistentvolumeclaim/vault-data-vault-1                                  vault        11h  
persistentvolumeclaim/vault-data-vault-2                                  vault        11h  
persistentvolume/pvc-6d801469-c205-4a9a-bf2c-602216905d64                              11h  
persistentvolume/pvc-d6a03212-4375-4c71-9cb2-ed3521b653ab                              11h  
persistentvolume/pvc-cc413cc7-353f-4853-bb49-525ac7b232bd                              11h  
pod/svclb-vault-n2wdx                                                     vault        12h  
pod/svclb-vault-mfvph                                                     vault        12h  
pod/svclb-vault-v976f                                                     vault        12h  
pod/vault-0                                                               vault        11h  
pod/vault-1                                                               vault        11h  
pod/vault-2                                                               vault        11h  
pod/vault-secrets-operator-547987c964-xqmqj                               vault        11h  
secret/default-token-j8pd9                                                vault        13h  
secret/vault-token-w4qvn                                                  vault        13h  
secret/vault-secrets-operator-token-wjfch                                 vault        11h  
secret/sh.helm.release.v1.vault-secrets-operator.v1                       vault        11h  
serviceaccount/default                                                    vault        13h  
serviceaccount/vault                                                      vault        13h  
serviceaccount/vault-secrets-operator                                     vault        11h  
service/vault-secrets-operator                                            vault        11h  
service/vault                                                             vault        12h  
customresourcedefinition.apiextensions.k8s.io/vaultsecrets.ricoberger.de               11h  
apiservice.apiregistration.k8s.io/v1alpha1.ricoberger.de                               11h  
controllerrevision.apps/svclb-vault-5b85c4c8c5                            vault        12h  
controllerrevision.apps/vault-5b4c76cc49                                  vault        12h  
daemonset.apps/svclb-vault                                                vault        12h  
deployment.apps/vault-secrets-operator                                    vault        11h  
replicaset.apps/vault-secrets-operator-547987c964                         vault        11h  
statefulset.apps/vault                                                    vault        12h  
endpointslice.discovery.k8s.io/vault-5f6jg                                vault        12h  
endpointslice.discovery.k8s.io/vault-secrets-operator-ktddk               vault        11h  
helmrelease.helm.fluxcd.io/metrics-server                                 kube-system  62m  
helmrelease.helm.fluxcd.io/vault-secrets-operator                         vault        13h  
clusterrolebinding.rbac.authorization.k8s.io/vault-secrets-operator                    11h  
clusterrole.rbac.authorization.k8s.io/vault-secrets-operator                           11h  
```
