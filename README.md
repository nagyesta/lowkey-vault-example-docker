![LowkeyVault](https://raw.githubusercontent.com/nagyesta/lowkey-vault/main/.github/assets/LowkeyVault-logo-full.png)

[![GitHub license](https://img.shields.io/github/license/nagyesta/lowkey-vault-example-docker?color=informational)](https://raw.githubusercontent.com/nagyesta/lowkey-vault-example-docker/main/LICENSE)
[![Docker test](https://img.shields.io/github/workflow/status/nagyesta/lowkey-vault-example-docker/Docker%20test?logo=github)](https://github.com/nagyesta/lowkey-vault-example-docker/actions/workflows/docker.yml)
[![Lowkey secure](https://img.shields.io/badge/lowkey-secure-0066CC)](https://github.com/nagyesta/lowkey-vault)

# Lowkey Vault - Example Docker

This is an example for [Lowkey Vault](https://github.com/nagyesta/lowkey-vault). It shows how you can start Lowkey Vault
while using most of the features it provides.

### Points of interest

* [docker/example.sh](docker/example.sh) shows how you can start up your container attaching the
  [keyvault.json.hbs](docker/keyvault.json.hbs) backup file from the same folder. 
* [docker-compose/docker-compose.yml](docker-compose/docker-compose.yml) shows how to start up your container
  using Docker compose including how you can import the [keyvault.json.hbs](docker-compose/keyvault.json.hbs) backup.

### Note

This is my very first Docker project after using it for 2-3 hours, please have mercy when
commenting on code quality!
