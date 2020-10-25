#!/bin/bash

# Enable job control
set -m

echo "[ INFO ] Start Vault server"
vault server -config=/vault/config/vault.hcl
