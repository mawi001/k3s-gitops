#!/usr/bin/env bash
export NAMESPACE=vault
export MASTER_NODE=master-01

kubectl wait --for=condition=ready node/$MASTER_NODE --timeout=30s
kubectl get node -o wide

echo "Wait for VAULT deployment in namespace $NAMESPACE to be completed by Flux"
until [ $(kubectl -n $NAMESPACE get po -l app=vault | grep -c 'Running') -eq 3 ]; do echo 'waiting for Vault pods to become running...' ; sleep 10 ; kubectl -n $NAMESPACE get po -o wide; done
until kubectl -n $NAMESPACE exec -ti vault-0 -- nc -z localhost 8200 ; do echo 'waiting for vault service accepting connections on tcp/8200' ; sleep 1 ; done
until kubectl -n $NAMESPACE exec -ti vault-1 -- nc -z localhost 8200 ; do echo 'waiting for vault service accepting connections on tcp/8200' ; sleep 1 ; done
until kubectl -n $NAMESPACE exec -ti vault-2 -- nc -z localhost 8200 ; do echo 'waiting for vault service accepting connections on tcp/8200' ; sleep 1 ; done

kubectl -n $NAMESPACE  wait --for=condition=Initialized pod/vault-0 --timeout=30s
kubectl -n $NAMESPACE  wait --for=condition=Initialized pod/vault-1 --timeout=30s
kubectl -n $NAMESPACE  wait --for=condition=Initialized pod/vault-2 --timeout=30s

export sealed_status=$(kubectl -n $NAMESPACE exec "vault-0" -- vault status -format=json 2>/dev/null | jq -r '.sealed')
export init_status=$(kubectl -n $NAMESPACE exec "vault-0" -- vault status -format=json 2>/dev/null | jq -r '.initialized')

export sealed_status_1=$(kubectl -n $NAMESPACE exec "vault-1" -- vault status -format=json 2>/dev/null | jq -r '.sealed')
export init_status_1=$(kubectl -n $NAMESPACE exec "vault-1" -- vault status -format=json 2>/dev/null | jq -r '.initialized')

export sealed_status_2=$(kubectl -n $NAMESPACE exec "vault-2" -- vault status -format=json 2>/dev/null | jq -r '.sealed')
export init_status_2=$(kubectl -n $NAMESPACE exec "vault-2" -- vault status -format=json 2>/dev/null | jq -r '.initialized')

if [ "$init_status" == "false" ]; then
  echo "Init vault"

  vault_init=$(kubectl -n $NAMESPACE exec "vault-0" -- vault operator init -format json)
  export VAULT_UNSEAL_KEY1=$(echo $vault_init | jq -r '.unseal_keys_hex[0]')
  export VAULT_UNSEAL_KEY2=$(echo $vault_init | jq -r '.unseal_keys_hex[1]')
  export VAULT_UNSEAL_KEY3=$(echo $vault_init | jq -r '.unseal_keys_hex[2]')
  export VAULT_UNSEAL_KEY4=$(echo $vault_init | jq -r '.unseal_keys_hex[3]')
  export VAULT_UNSEAL_KEY5=$(echo $vault_init | jq -r '.unseal_keys_hex[4]')

  export VAULT_ROOT_TOKEN=$(echo $vault_init | jq -r '.root_token')

  echo "VAULT_ROOT_TOKEN is: $VAULT_ROOT_TOKEN"

  env | grep VAULT

  echo "sleeping 10 seconds to allow first vault pod to be ready"
  sleep 10

  echo "unseal raft leader vault-0"
  if [ "$sealed_status" == "true" ]; then

    kubectl -n $NAMESPACE exec "vault-0" -- vault operator unseal "$VAULT_UNSEAL_KEY1"
    kubectl -n $NAMESPACE exec "vault-0" -- vault operator unseal "$VAULT_UNSEAL_KEY2"
    kubectl -n $NAMESPACE exec "vault-0" -- vault operator unseal "$VAULT_UNSEAL_KEY3"

  fi

  # * local node not active but active cluster node not found
  # command terminated with exit code 2
  # until kubectl -n $NAMESPACE exec vault-0 -- vault login -no-print "$VAULT_ROOT_TOKEN"; do
  until kubectl -n $NAMESPACE exec vault-0 -- vault login "$VAULT_ROOT_TOKEN"; do
    echo "waiting for local node to become active..."
    sleep 3
  done

  # until kubectl --namespace $NAMESPACE exec vault-0 -- vault operator raft list-peers; do
  #   echo "Settle raft protocol"
  #   sleep 3
  # done

fi

echo "creating port-forward"
# kubectl exec vault-0 -vault login $VAULT_ROOT_TOKEN
kubectl -n $NAMESPACE  port-forward pod/vault-0 8200:8200 --pod-running-timeout=1m0s >/dev/null 2>&1 &
export VAULT_FWD_PID=$!

echo "port-forward pid ${VAULT_FWD_PID}"

until nc -zv localhost 8200 ; do echo 'waiting for vault service accepting connections on localhost:8200' ; sleep 1 ; done

sleep 5

setup='false'

until [[ $setup == 'true' ]]; do

  export VAULT_ADDR=http://localhost:8200
  export VAULT_SKIP_VERIFY=true
  vault login -no-print "$VAULT_ROOT_TOKEN"
  vault operator raft list-peers
  vault secrets enable -path=secret kv-v2
  vault auth list
  vault kv put secret/service/vault/production root_token=$VAULT_ROOT_TOKEN key1=$VAULT_UNSEAL_KEY1 key2=$VAULT_UNSEAL_KEY2 key3=$VAULT_UNSEAL_KEY3 key4=$VAULT_UNSEAL_KEY4 key5=$VAULT_UNSEAL_KEY5
  vault kv get secret/service/vault/production


  export VAULT_SECRETS_OPERATOR_NAMESPACE=$(kubectl -n $NAMESPACE get sa vault-secrets-operator -o jsonpath="{.metadata.namespace}")
  export VAULT_SECRET_NAME=$(kubectl -n $NAMESPACE get sa vault-secrets-operator -o jsonpath="{.secrets[*]['name']}")
  export SA_JWT_TOKEN=$(kubectl -n $NAMESPACE get secret $VAULT_SECRET_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
  export SA_CA_CRT=$(kubectl -n $NAMESPACE get secret $VAULT_SECRET_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)
  export K8S_HOST=$(kubectl -n $NAMESPACE config view --minify -o jsonpath='{.clusters[0].cluster.server}')

  ## TODO: deploy vault-secrets-operator

  # create read-only policy for kubernetes
  vault policy write vault-secrets-operator vault/vault-secrets-operator.hcl

  vault auth enable kubernetes

  # Tell Vault how to communicate with the Kubernetes cluster
  vault write auth/kubernetes/config \
    token_reviewer_jwt="$SA_JWT_TOKEN" \
    kubernetes_host="$K8S_HOST" \
    kubernetes_ca_cert="$SA_CA_CRT"

  # Create a role named, 'vault-secrets-operator' to map Kubernetes Service Account to Vault policies and default token TTL
  vault write auth/kubernetes/role/vault-secrets-operator \
    bound_service_account_names="vault-secrets-operator" \
    bound_service_account_namespaces="$VAULT_SECRETS_OPERATOR_NAMESPACE" \
    policies=vault-secrets-operator \
    ttl=24h

  setup='true'
done

joined='false'

until [[ $joined == 'true' ]]; do
  kubectl -n $NAMESPACE exec "vault-1" -- vault operator raft join http://vault-0.vault:8200
  kubectl -n $NAMESPACE exec "vault-2" -- vault operator raft join http://vault-0.vault:8200

  joined='true'
done

echo "unseal replicas"
unsealed='false'

until [[ $unsealed == 'true' ]]; do

  kubectl -n $NAMESPACE exec "vault-1" -- vault operator unseal "$VAULT_UNSEAL_KEY1"
  kubectl -n $NAMESPACE exec "vault-1" -- vault operator unseal "$VAULT_UNSEAL_KEY2"
  kubectl -n $NAMESPACE exec "vault-1" -- vault operator unseal "$VAULT_UNSEAL_KEY3"
  kubectl -n $NAMESPACE exec "vault-1" -- vault status

  kubectl -n $NAMESPACE exec "vault-2" -- vault operator unseal "$VAULT_UNSEAL_KEY1"
  kubectl -n $NAMESPACE exec "vault-2" -- vault operator unseal "$VAULT_UNSEAL_KEY2"
  kubectl -n $NAMESPACE exec "vault-2" -- vault operator unseal "$VAULT_UNSEAL_KEY3"
  kubectl -n $NAMESPACE exec "vault-2" -- vault status
  unsealed='true'
done

kubectl -n $NAMESPACE get service

kill $VAULT_FWD_PID
