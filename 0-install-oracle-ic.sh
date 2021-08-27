#!/bin/bash

# Install Oracle Instant Client

sudo mkdir -p /opt/oracle

sudo cp /vagrant/instantclient-basic-linux.x64-19.10.0.0.0dbru.zip /opt/oracle

cd /opt/oracle

unzip instantclient*

sudo apt-get update

sudo apt-get install libaio1

sudo sh -c "echo /opt/oracle/instantclient_19_10 > \
    /etc/ld.so.conf.d/oracle-instantclient.conf"

sudo ldconfig