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
