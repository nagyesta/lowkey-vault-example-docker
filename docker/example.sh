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
docker run --rm --name lowkey-docker -d -p 8443:8443 -e LOWKEY_ARGS -v docker-lv-import:/import/:rw -v docker-lv-config:/config/:ro nagyesta/lowkey-vault:2.1.0@sha256:f38cca88ccd2d66af0e4be79719b73fb9f8d29f89a41d5e33a376ca93ada1cb0

# If you want to rely on managed identity, then start up an Assumed Identity container on port 8080
docker run --rm --name assumed-id-docker -d -p 8080:8080 -e ASSUMED_ID_PORT=8080 nagyesta/assumed-identity:1.1.5@sha256:b7b4770e4a00bf208fb777f096116b95ad9226124a63db236608289aba7ab61e
