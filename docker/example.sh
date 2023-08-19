#!/bin/sh -l

# Use docker as the working directory while using this file!

# Create volumes, allowing us to share the backup file and configuration files with the container by mounting it
docker volume create -d local -o type=none -o o=bind -o device=$PWD/import docker-lv-import
docker volume create -d local -o type=none -o o=bind -o device=$PWD/config docker-lv-config

# Set arguments for Lowkey Vault configuring key parameters, such as:
# - setting the port we want to use: --server.port=8443
# - overriding the key store type: --server.ssl.key-store-type=JKS
# - overriding the key store path: --server.ssl.key-store=/config/cert.jks
# - overriding the key store password: --server.ssl.key-store-password=password
# - disable automatic vault creation: --LOWKEY_VAULT_NAMES=-
# - turn off debug option controlling request logging: --LOWKEY_DEBUG_REQUEST_LOG=false
# - specify the name of the import file: --LOWKEY_IMPORT_LOCATION=/import/keyvault.json.hbs
# - defining the value of {{host}} placeholders in the import: --LOWKEY_IMPORT_TEMPLATE_HOST=localhost
# - defining the value of {{port}} placeholders in the import: --LOWKEY_IMPORT_TEMPLATE_PORT=8443
# More details at: https://github.com/nagyesta/lowkey-vault/tree/main/lowkey-vault-app#startup-parameters
export LOWKEY_ARGS="--server.port=8443 --server.ssl.key-store-type=JKS --server.ssl.key-store=/config/cert.jks --server.ssl.key-store-password=password --LOWKEY_VAULT_NAMES=- --LOWKEY_DEBUG_REQUEST_LOG=false --LOWKEY_IMPORT_LOCATION=/import/keyvault.json.hbs --LOWKEY_IMPORT_TEMPLATE_HOST=localhost --LOWKEY_IMPORT_TEMPLATE_PORT=8443"

# Start the container in a detached mode and set up port-forward, pass arguments, and mount the volume
docker run --rm --name lowkey-docker -d -p 8443:8443 -e LOWKEY_ARGS -v docker-lv-import:/import/:rw -v docker-lv-config:/config/:ro nagyesta/lowkey-vault:2.0.0@sha256:020b5dd3f1e85ac0d20e8967b1797252c84b8ea29aa8510efaf65f31eaa9cb15
