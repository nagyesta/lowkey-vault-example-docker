![LowkeyVault](https://raw.githubusercontent.com/nagyesta/lowkey-vault/main/.github/assets/LowkeyVault-logo-full.png)

[![GitHub license](https://img.shields.io/github/license/nagyesta/lowkey-vault-example-docker?color=informational)](https://raw.githubusercontent.com/nagyesta/lowkey-vault-example-docker/main/LICENSE)
[![Docker test](https://img.shields.io/github/actions/workflow/status/nagyesta/lowkey-vault-example-docker/docker.yml?logo=github&branch=main)](https://github.com/nagyesta/lowkey-vault-example-docker/actions/workflows/docker.yml)
[![Lowkey secure](https://img.shields.io/badge/lowkey-secure-0066CC)](https://github.com/nagyesta/lowkey-vault)

# Lowkey Vault - Example Docker

This is an example for [Lowkey Vault](https://github.com/nagyesta/lowkey-vault). It shows how you can start Lowkey Vault
while using most of the features it provides.

### Points of interest

* [docker/example.sh](docker/example.sh) shows how you can start up your container attaching the
  [keyvault.json.hbs](docker/import/keyvault.json.hbs) backup file from the import sub-folder as well as using an
  external configuration file named [application.properties](docker/config/application.properties) from the config
  sub-folder. 
* [docker-compose/docker-compose.yml](docker-compose/docker-compose.yml) shows how to start up your container
  using Docker compose including the import of the [keyvault.json.hbs](docker-compose/import/keyvault.json.hbs)
  backup and use configuration overrides from [application.properties](docker-compose/config/application.properties).
* [docker-compose-multiarch/docker-compose.yml](docker-compose-multiarch/docker-compose.yml) shows how you need to
  change the Docker compose setup to use a multiarch image and achieve the same outcome, i.e. import the 
  [keyvault.json.hbs](docker-compose-multiarch/import/keyvault.json.hbs) backup and load the configuration from
  [application.properties](docker-compose-multiarch/config/application.properties).

