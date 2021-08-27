# Vault Monitoring and Logging Demo

The code in this demo will build a local Consul cluster with a single Vault server along with a Prometheus/Grafana server and an ELK (Elasticsearch, Logstash, Kibana) server too. The aim of all of this is to demonstrate how you could collect metrics from Vault and Consul (and which metrics are most important) and also how to collect audit logs from Vault and ship them to an ELK stack.

Combined with the installation of the Oracle Database Plugin for Vault and the Terraform scripts it also attempts to show how one could manage dynamic secrets for an Oracle Database hosted on Amazon's RDS.

## Important Notes

1. **Note:** This demo aims to demonstrate how telemetry metrics and audit logs can be enabled and collected with Vault and Consul. It does **not** intend to demonstrate how to build a Vault and Consul deployment according to any reference architecture, nor does it intend to demonstrate any form of best practice. Amongst many other things, you should always enable ACLs, configure TLS and never store your Vault unseal keys or tokens on your Vault server!

## Requirements
* The VMs created by the demo will consume a total of 5GB memory.
* The demo was tested using Vagrant 2.2.18 and Virtualbox 6.1.26

## What is built?

The demo will build the following Virtual Machines:
* **vault-server**: A single Vault server
* **consul-{1-3}-server**: A cluster of 3 Consul servers within a single Datacenter
* **prometheus**: A single server running Prometheus
* **elasticsearch**: A single server running an ELK stack.

## Provisioning scripts
The following provisioning scripts will be run by Vagrant:
* config-grafana.sh: Automatically configures Prometheus as the datasource for Grafana on the prometheus VM, deploys a dashboard onto Grafana and sets that dashboard as the home dashboard.
* install-consul.sh: Automatically installs and configures Consul 1.6.2 (open source) on each of the consul-{1-3}-server VMs. A flag allows it to configure a consul client on the Vault VM too.
* install-elasticsearch.sh: Automatically installs and configures the latest version of elasticsearch on the elasticsearch VM.
* install-grafana.sh: Automatically installs Grafana onto the prometheus VM.
* install-kibana.sh: Automatically installs Kibana onto the elasticsearch VM and configures it to search on the local Elasticsearch server.
* install-logstash.sh: Automatically installs Logstash onto the elasticsearch VM and configures it to output to the local Elasticsearch server.
* install-prometheus.sh: Automatically installs Prometheus onto the Prometheus VM and configures it to scrape metrics from all consul and vault servers.
* install-rsyslog-client.sh: Configures an rsyslog client on each of the consul and vault servers to forward to the rsyslog server (which is co-located on the elasticsearch server)
* install-rsyslog-server.sh: Configures an rsyslog server on the elasticsearch server to collect logs sent from the rsyslog clients and to forward them to logstash running on the same Elasticsearch server in JSON format.
* install-telegraf.sh: Installs and configures telegraf on each of the consul and vault servers. This collects system and application metrics and publishes them on an endpoint that Prometheus can scrape from.
* install-vault.sh: Automatically installs and configures Vault (open source) on the Vault server.

## Additional files
The following additional files are also included:
* grafana-dashboard.json: Stores the grafana dashboard configuration. Used by config-grafana.sh
* 0-install-oracle-ic.sh: Installs Oracle Instant Client
* 1-init-vault.sh: Needs to be run as a manual step to initialise and unseal Vault, logging in using the root token and configuring audit logging.
* 2-vault-install-oracle.sh: Installs the Oracle Database Plugin onto Vault
* 3-vault-configure-db-plugin.sh: Configures the Oracle database plugin for Vault.
* 4-vault-oracle-request-creds: Requests the creation of credentials from the Oracle Database Secrets Engine.

## How to get started
Once Vagrant and Virtualbox are installed, to get started just run the following command within the code directory:
```
vagrant up
```

Once everything is built, you should be able to access the following UIs at the following addresses:

* Consul UI: http://10.0.0.11:7500/ui/
* Grafana UI: http://10.0.0.14:3000
* Prometheus UI: http://10.0.0.14:9090
* Kibana UI: http://10.0.0.15:6601

If you're having problems, then check your Virtualbox networking configurations. They should be set to the default of NAT. If problems still persist then you might be able to access the UIs via the port forwarding that has been set up- check the Vagrantfile for these ports.

Next, ensure you have Oracle Instant Client located within the appropriate directory in your `/vagrant/` folder as per `0-install-oracle-ic.sh`.

Also please ensure you have built the AWS RDS-related infrastructure by running terraform in `terraform/ct-tfcontrol`.

Once vagrant has completely finished, run the following to SSH onto the vault server
```
vagrant ssh vault-server
```
Once SSH'd onto the Vault server, run the following command to install the Oracle instant client on your vault server.
```
./0-install-oracle-ic.sh;
```
Next, initialise Vault by running the following command on the VAUlt server.
```
./1-init-vault.sh 
```
This will create a file called vault.txt in the directory you run the script in. The file contains a single Vault unseal key and root token, in case you wish to seal or unseal vault in the future. Of course, in a real-life scenario these files should not be generated automatically and not be stored on the vault server.

Next, install the Oracle database plugin with the following command:
```
./2-vault-install-oracle.sh
```
The next command will configure the plugin. Please make sure that the database connection string matches that of your RDS-hosted database.
```
./3-vault-configure-db-plugin.sh
```
Finally, request the creation of credentials using this final command:
```
4-vault-oracle-request-credentials.sh
```

## Support
No support or guarantees are offered with this code. It is purely a demo.

## Future Improvements
* Use Docker containers instead of VMs.
* Vault with integrated storage backend instead of Consul.
* Other suggested future improvements very welcome.
