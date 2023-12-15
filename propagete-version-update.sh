#!/bin/bash

LOWKEY_VAULT_VERSION=$(grep nagyesta/lowkey-vault: < docker-compose/docker-compose.yml | cut -d ':' -f 3 | cut -d '@' -f 1)
ASSUMED_ID_VERSION=$(grep nagyesta/assumed-identity: < docker-compose/docker-compose.yml | cut -d ':' -f 3 | cut -d '@' -f 1)
LOWKEY_VAULT_HASH=$(grep nagyesta/lowkey-vault: < docker-compose/docker-compose.yml | cut -d ':' -f 4)
ASSUMED_ID_HASH=$(grep nagyesta/assumed-identity: < docker-compose/docker-compose.yml | cut -d ':' -f 4)

echo "Identified image versions:"
echo "-> lowkey-vault:${LOWKEY_VAULT_VERSION}@sha256:${LOWKEY_VAULT_HASH}"
echo "-> assumed-identity:${ASSUMED_ID_VERSION}@sha256:${ASSUMED_ID_HASH}"

# Update sh variant
cp docker/example.sh docker/example.sh.bak
sed "s/lowkey-vault:[0-9]\+.[0-9]\+.[0-9]\+@sha256:[0-9a-f]\+/lowkey-vault:${LOWKEY_VAULT_VERSION}@sha256:${LOWKEY_VAULT_HASH}/" < docker/example.sh.bak > docker/example.sh.tmp
sed "s/assumed-identity:[0-9]\+.[0-9]\+.[0-9]\+@sha256:[0-9a-f]\+/assumed-identity:${ASSUMED_ID_VERSION}@sha256:${ASSUMED_ID_HASH}/" < docker/example.sh.tmp > docker/example.sh
rm docker/example.sh.tmp
rm docker/example.sh.bak

# Update multi-arch variant
cp docker-compose-multiarch/docker-compose.yml docker-compose-multiarch/docker-compose.yml.bak
sed "s/lowkey-vault:.\+/lowkey-vault:${LOWKEY_VAULT_VERSION}-ubi9-minimal/" < docker-compose-multiarch/docker-compose.yml.bak > docker-compose-multiarch/docker-compose.yml.tmp
sed "s/assumed-identity:.\+/assumed-identity:${ASSUMED_ID_VERSION}/" < docker-compose-multiarch/docker-compose.yml.tmp > docker-compose-multiarch/docker-compose.yml
rm docker-compose-multiarch/docker-compose.yml.tmp
rm docker-compose-multiarch/docker-compose.yml.bak
