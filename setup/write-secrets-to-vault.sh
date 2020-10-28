#!/usr/bin/env bash

export REPO_ROOT=$(git rev-parse --show-toplevel)

. "$REPO_ROOT"/.env

vault_write() {
  name="secret/$(dirname "$@")/$(basename -s .txt "$@")"

  echo "Writing $name to vault"
  if output=$(envsubst < "$REPO_ROOT/$*"); then
    printf '%s' "$output" | vault kv put "$name" values.yaml=-
  fi
}


vault_write "deployments/monitoring/botkube/botkube-helm-values.txt"
