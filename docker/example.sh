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
docker run --rm --name lowkey-docker -d -p 8443:8443 -e LOWKEY_ARGS -v docker-lv-import:/import/:rw -v docker-lv-config:/config/:ro nagyesta/lowkey-vault:4.0.27@sha256:1edfe3f23c057aabf1cc5078a740d5130bdf795b00a66aac1d29faf859251f69

# If you want to rely on managed identity, then start up an Assumed Identity container on port 8080
docker run --rm --name assumed-id-docker -d -p 8080:8080 -e ASSUMED_ID_PORT=8080 nagyesta/assumed-identity:2.1.17@sha256:60cd8ada7450238a9b1d82848fc2cfbe5499f68afd9b99b3a594f24b60a61044
