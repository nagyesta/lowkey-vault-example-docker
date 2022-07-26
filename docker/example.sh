#!/bin/sh -l

# Use docker-compose as the working directory while using this file!

# Create a volume, allowing us to share the backup file with the container by mounting it
docker volume create -d local -o type=none -o o=bind -o device=$PWD docker-lowkey-vault-import

# Set arguments for Lowkey Vault configuring key parameters, such as:
# - setting the port we want to use: --server.port=8443
# - overriding the key store type: --server.ssl.key-store-type=JKS
# - overriding the key store path: --server.ssl.key-store=/import/cert.jks
# - overriding the key store password: --server.ssl.key-store-password=password
# - disable automatic vault creation: --LOWKEY_VAULT_NAMES=-
# - turn off debug option controlling request logging: --LOWKEY_DEBUG_REQUEST_LOG=false
# - specify the name of the import file: --LOWKEY_IMPORT_LOCATION=/import/keyvault.json.hbs
# - defining the value of {{host}} placeholders in the import: --LOWKEY_IMPORT_TEMPLATE_HOST=localhost
# - defining the value of {{port}} placeholders in the import: --LOWKEY_IMPORT_TEMPLATE_PORT=8443
# More details at: https://github.com/nagyesta/lowkey-vault/tree/main/lowkey-vault-app#startup-parameters
export LOWKEY_ARGS="--server.port=8443 --server.ssl.key-store-type=JKS --server.ssl.key-store=/import/cert.jks --server.ssl.key-store-password=password --LOWKEY_VAULT_NAMES=- --LOWKEY_DEBUG_REQUEST_LOG=false --LOWKEY_IMPORT_LOCATION=/import/keyvault.json.hbs --LOWKEY_IMPORT_TEMPLATE_HOST=localhost --LOWKEY_IMPORT_TEMPLATE_PORT=8443"

# Start the container in a detached mode and set up port-forward, pass arguments, and mount the volume
docker run --rm --name lowkey-docker -d -p 8443:8443 -e LOWKEY_ARGS -v docker-lowkey-vault-import:/import/:ro nagyesta/lowkey-vault:1.14.12@sha256:9701e49f0f17d755e62f9cdbb4a137d4dab7832e6f95b7a36059c8d67829fb0e
