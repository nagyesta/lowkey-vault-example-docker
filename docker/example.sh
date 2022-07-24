#!/bin/sh -l

# Use docker-compose as the working directory while using this file!

# Create a volume, allowing us to share the backup file with the container by mounting it
docker volume create -d local -o type=none -o o=bind -o device=$PWD docker-lowkey-vault-import

# Set arguments for Lowkey Vault configuring key parameters, such as:
# - the port we want to use
# - the names of the vaults we want to pre-register at start-up
# - the debug option controlling request logging
# - the name of the import file
export LOWKEY_ARGS="--server.port=8443 --LOWKEY_VAULT_NAMES=- --LOWKEY_DEBUG_REQUEST_LOG=false --LOWKEY_IMPORT_LOCATION=/import/keyvault.json.hbs"

# Start the container and set up port-forward, pass arguments, and mount the volume
docker run --rm --name lowkey-docker -p 8443:8443 -e LOWKEY_ARGS -v docker-lowkey-vault-import:/import/:ro nagyesta/lowkey-vault:1.8.14
