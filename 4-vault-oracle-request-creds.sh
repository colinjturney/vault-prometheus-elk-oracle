#!/bin/bash

export VAULT_TOKEN=$(cat /vagrant/vault.txt | grep Token | cut -d' ' -f2)

vault read database/creds/readonly