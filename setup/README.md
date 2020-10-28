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


Use `run.sh` to deploy Flux and Helm operator

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



## Vault

run `vault.sh` to bootstrap Vault cluster


```sh
✔  mawi@wii  …/k3s-gitops/setup  master ?  ./vault.sh
node/master-01 condition met
NAME        STATUS   ROLES    AGE   VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
worker-02   Ready    <none>   15d   v1.19.2+k3s1   10.54.0.242   <none>        Raspbian GNU/Linux 10 (buster)   4.19.97-v7l+     containerd://1.4.0-k3s1
worker-01   Ready    <none>   15d   v1.19.2+k3s1   10.54.0.241   <none>        Raspbian GNU/Linux 10 (buster)   4.19.97-v7l+     containerd://1.4.0-k3s1
master-01   Ready    master   15d   v1.19.2+k3s1   10.54.0.240   <none>        Raspbian GNU/Linux 10 (buster)   4.19.97-v7l+     containerd://1.4.0-k3s1
Wait for VAULT deployment in namespace vault to be completed by Flux
pod/vault-0 condition met
pod/vault-1 condition met
pod/vault-2 condition met
Init vault
VAULT_ROOT_TOKEN is: s.eB3KPHAXkX0UnBD5vRIzxRwn
ANSIBLE_VAULT_PASSWORD_FILE=/home/mawi/.ansible-vault
VAULT_SKIP_VERIFY=true
VAULT_UNSEAL_KEY3=***
VAULT_UNSEAL_KEY2=***
VAULT_UNSEAL_KEY1=***
VAULT_UNSEAL_KEY5=***
VAULT_UNSEAL_KEY4=***
VAULT_SECRET_NAME=
VAULT_FWD_PID=17598
VAULT_SECRETS_OPERATOR_NAMESPACE=
VAULT_ADDR=http://localhost:8200
VAULT_ROOT_TOKEN=s.***
sleeping 10 seconds to allow first vault pod to be ready
unseal raft leader vault-0
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       413da9ce-5de5-ade5-e813-91c61643fefc
Version            1.5.4
HA Enabled         true
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       413da9ce-5de5-ade5-e813-91c61643fefc
Version            1.5.4
HA Enabled         true
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            5
Threshold               3
Version                 1.5.4
Cluster Name            k3s-vault
Cluster ID              a4a46700-a403-fda4-8acc-c4382a35afda
HA Enabled              true
HA Cluster              n/a
HA Mode                 standby
Active Node Address     <none>
Raft Committed Index    24
Raft Applied Index      24
Error authenticating: error looking up token: Error making API request.

URL: GET http://10.42.2.230:8200/v1/auth/token/lookup-self
Code: 500. Errors:

* local node not active but active cluster node not found
command terminated with exit code 2
waiting for local node to become active
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.***
token_accessor       ***
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
Node                                    Address             State     Voter
----                                    -------             -----     -----
804131ec-e2b4-5f5e-a00b-dd7ce36a860b    10.42.2.230:8201    leader    true
creating port-forward
Node                                    Address             State     Voter
----                                    -------             -----     -----
804131ec-e2b4-5f5e-a00b-dd7ce36a860b    10.42.2.230:8201    leader    true
Success! Enabled the kv-v2 secrets engine at: secret/
Path      Type     Accessor               Description
----      ----     --------               -----------
token/    token    auth_token_89e1b54d    token based credentials
Key              Value
---              -----
created_time     2020-10-26T23:44:41.674750883Z
deletion_time    n/a
destroyed        false
version          1
====== Metadata ======
Key              Value
---              -----
created_time     2020-10-26T23:44:41.674750883Z
deletion_time    n/a
destroyed        false
version          1

======= Data =======
Key           Value
---           -----
key1          ***
key2          ***
key3          ***
key4          ***
key5          ***
root_token    s.***
Key       Value
---       -----
Joined    true
Key       Value
---       -----
Joined    true
unseal replicas
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       f830db92-fc08-243b-3f93-c689e81e8e39
Version            1.5.4
HA Enabled         true
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       f830db92-fc08-243b-3f93-c689e81e8e39
Version            1.5.4
HA Enabled         true
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    0/3
Unseal Nonce       n/a
Version            1.5.4
HA Enabled         true
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    0/3
Unseal Nonce       n/a
Version            1.5.4
HA Enabled         true
command terminated with exit code 2
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       658efe3a-d38c-5e48-408e-d2d600e6f533
Version            1.5.4
HA Enabled         true
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       658efe3a-d38c-5e48-408e-d2d600e6f533
Version            1.5.4
HA Enabled         true
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    0/3
Unseal Nonce       n/a
Version            1.5.4
HA Enabled         true
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    0/3
Unseal Nonce       n/a
Version            1.5.4
HA Enabled         true
command terminated with exit code 2
Success! Uploaded policy: vault-secrets-operator
Success! Enabled kubernetes auth method at: kubernetes/
Success! Data written to: auth/kubernetes/config
Success! Data written to: auth/kubernetes/role/vault-secrets-operator
NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                         AGE
vault-secrets-operator   ClusterIP      10.43.208.13   <none>        8383/TCP,8686/TCP               30s
vault                    LoadBalancer   10.43.81.18    10.54.0.241   8200:31502/TCP,8201:31430/TCP   38m
Path          Type         Accessor              Description
----          ----         --------              -----------
cubbyhole/    cubbyhole    cubbyhole_8651ee8e    per-token private secret storage
identity/     identity     identity_43f7d872     identity store
secret/       kv           kv_66a72585           n/a
sys/          system       system_b57be24f       system endpoints used for control, policy and debugging
```


## Write secrets to Vault

use the script `./write-secrets-to-vault.sh` to write secrets to Vault


```sh
./write-secrets-to-vault.sh                                            
Writing secret/deployments/monitoring/botkube/botkube-helm-values to vault
Key              Value
---              -----
created_time     2020-10-28T15:14:39.773500912Z
deletion_time    n/a
destroyed        false
version          4
```

## Test Vault-secret-operator is reading from Vault

Check the pod logs

`k logs -n vault -l app.kubernetes.io/instance=vault-secrets-operator -f`

The operator should read from vault and update Kubernetes secrets. The logs show expected behavior. 

```sh
{"level":"info","ts":1603897724.4103765,"logger":"controller_vaultsecret","msg":"Reconciling VaultSecret","Request.Namespace":"monitoring","Request.Name":"botkube-helm-values"}
{"level":"info","ts":1603897724.4105616,"logger":"vault","msg":"Read secret secret/deployments/monitoring/botkube/botkube-helm-values"}
{"level":"info","ts":1603897724.4289556,"logger":"controller_vaultsecret","msg":"Updating a Secret","Request.Namespace":"monitoring","Request.Name":"botkube-helm-values","Secret.Namespace":"monitoring","Secret.Name":"botkube-helm-values"}
{"level":"info","ts":1603897724.5456312,"logger":"controller_vaultsecret","msg":"Reconciling VaultSecret","Request.Namespace":"monitoring","Request.Name":"botkube-helm-values"}
{"level":"info","ts":1603897724.545951,"logger":"vault","msg":"Read secret secret/deployments/monitoring/botkube/botkube-helm-values"}
{"level":"info","ts":1603897724.5650191,"logger":"controller_vaultsecret","msg":"Updating a Secret","Request.Namespace":"monitoring","Request.Name":"botkube-helm-values","Secret.Namespace":"monitoring","Secret.Name":"botkube-helm-values"}
{"level":"info","ts":1603898024.5406802,"logger":"controller_vaultsecret","msg":"Reconciling VaultSecret","Request.Namespace":"monitoring","Request.Name":"botkube-helm-values"}
{"level":"info","ts":1603898024.5407786,"logger":"vault","msg":"Read secret secret/deployments/monitoring/botkube/botkube-helm-values"}
{"level":"info","ts":1603898024.5557017,"logger":"controller_vaultsecret","msg":"Updating a Secret","Request.Namespace":"monitoring","Request.Name":"botkube-helm-values","Secret.Namespace":"monitoring","Secret.Name":"botkube-helm-values"}
```
