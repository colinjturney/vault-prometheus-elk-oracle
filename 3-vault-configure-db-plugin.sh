#!/bin/bash

# Configure Vault with plugin and connection information

export VAULT_TOKEN=$(cat /vagrant/vault.txt | grep Token | cut -d' ' -f2)

export DB_CONNECTION_STRING="demodb-oracle.ctcbia33ysen.eu-west-2.rds.amazonaws.com"
export DB_PORT="1521"
export VAULT_TOKEN=$(cat /vagrant/vault.txt | grep Token | cut -d' ' -f2)
export DB_USERNAME="vault_su"
export DB_PASSWORD="Pa55W0rd!"

vault write database/config/oracle-database \
    plugin_name=vault-plugin-database-oracle \
    connection_url="{{username}}/{{password}}@${DB_CONNECTION_STRING}:${DB_PORT}/ORACLE" \
    allowed_roles="readonly" \
    username="${DB_USERNAME}" \
    password="${DB_PASSWORD}"

vault write database/roles/readonly \
    db_name=oracle-database \
    creation_statements='CREATE USER {{username}} IDENTIFIED BY "{{password}}"; GRANT CONNECT TO {{username}}; GRANT CREATE SESSION TO {{username}};' \
    default_ttl="1h" \
    max_ttl="24h"

vault write database/config/oracle-database-2 \
    plugin_name=vault-plugin-database-oracle \
    connection_url="{{username}}/{{password}}@${DB_CONNECTION_STRING}:${DB_PORT}/ORACLE" \
    allowed_roles="readonly" \
    username="${DB_USERNAME}" \
    password="${DB_PASSWORD}"

vault write database/roles/readonly-2 \
    db_name=oracle-database-2 \
    creation_statements='CREATE USER {{username}} IDENTIFIED BY "{{password}}"; GRANT CONNECT TO {{username}}; GRANT CREATE SESSION TO {{username}};' \
    default_ttl="1h" \
    max_ttl="24h"

vault write database/config/oracle-database-3 \
    plugin_name=vault-plugin-database-oracle \
    connection_url="{{username}}/{{password}}@${DB_CONNECTION_STRING}:${DB_PORT}/ORACLE" \
    allowed_roles="readonly" \
    username="${DB_USERNAME}" \
    password="${DB_PASSWORD}"

vault write database/roles/readonly-3 \
    db_name=oracle-database-3 \
    creation_statements='CREATE USER {{username}} IDENTIFIED BY "{{password}}"; GRANT CONNECT TO {{username}}; GRANT CREATE SESSION TO {{username}};' \
    default_ttl="1h" \
    max_ttl="24h"