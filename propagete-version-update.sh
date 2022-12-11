#!/bin/bash

LOWKEY_VAULT_VERSION=$(grep nagyesta/lowkey-vault: < docker-compose/docker-compose.yml | cut -d ':' -f 3 | cut -d '@' -f 1)
LOWKEY_VAULT_HASH=$(grep nagyesta/lowkey-vault: < docker-compose/docker-compose.yml | cut -d ':' -f 4)

echo "Identified image version: ${LOWKEY_VAULT_VERSION}@sha256:${LOWKEY_VAULT_HASH}"

# Update sh variant
cp docker/example.sh docker/example.sh.bak
sed "s/lowkey-vault:[0-9]\+.[0-9]\+.[0-9]\+@sha256:[0-9a-f]\+/lowkey-vault:${LOWKEY_VAULT_VERSION}@sha256:${LOWKEY_VAULT_HASH}/" < docker/example.sh.bak > docker/example.sh
rm docker/example.sh.bak

# Update multi-arch variant
cp docker-compose-multiarch/docker-compose.yml docker-compose-multiarch/docker-compose.yml.bak
sed "s/lowkey-vault:[0-9]\+.[0-9]\+.[0-9]\+/lowkey-vault:${LOWKEY_VAULT_VERSION}/" < docker-compose-multiarch/docker-compose.yml.bak > docker-compose-multiarch/docker-compose.yml
rm docker-compose-multiarch/docker-compose.yml.bak