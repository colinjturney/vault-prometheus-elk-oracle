#!/bin/bash

# Install Oracle Plugin

export VAULT_TOKEN=$(cat /vagrant/vault.txt | grep Token | cut -d' ' -f2)

curl -o vault-oracle.zip https://releases.hashicorp.com/vault-plugin-database-oracle/0.4.0/vault-plugin-database-oracle_0.4.0_linux_amd64.zip

unzip vault-oracle.zip

sudo cp vault-plugin-database-oracle /etc/vault.d/plugins

sudo setcap cap_ipc_lock=+ep /etc/vault.d/plugins/vault-plugin-database-oracle

shasum -a 256 /etc/vault.d/plugins/vault-plugin-database-oracle | cut -f1 -d' ' > /tmp/oracle-plugin.sha256

echo "Plugin register..."

vault secrets enable database

vault plugin register \
    -sha256 $(cat /tmp/oracle-plugin.sha256) \
    database \
    vault-plugin-database-oracle 