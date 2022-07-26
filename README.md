![LowkeyVault](https://raw.githubusercontent.com/nagyesta/lowkey-vault/main/.github/assets/LowkeyVault-logo-full.png)

[![GitHub license](https://img.shields.io/github/license/nagyesta/lowkey-vault-example-docker?color=informational)](https://raw.githubusercontent.com/nagyesta/lowkey-vault-example-docker/main/LICENSE)
[![Docker test](https://img.shields.io/github/actions/workflow/status/nagyesta/lowkey-vault-example-docker/docker.yml?logo=github&branch=main)](https://github.com/nagyesta/lowkey-vault-example-docker/actions/workflows/docker.yml)
[![Lowkey secure](https://img.shields.io/badge/lowkey-secure-0066CC)](https://github.com/nagyesta/lowkey-vault)

# Lowkey Vault - Example Docker

This is an example for [Lowkey Vault](https://github.com/nagyesta/lowkey-vault). It shows how you can start Lowkey Vault
while using most of the features it provides.

### Points of interest

* [docker/example.sh](docker/example.sh) shows how you can start up your container attaching the
  [keyvault.json.hbs](docker/keyvault.json.hbs) backup file from the same folder. 
* [docker-compose/docker-compose.yml](docker-compose/docker-compose.yml) shows how to start up your container
  using Docker compose including how you can import the [keyvault.json.hbs](docker-compose/keyvault.json.hbs) backup.

