# stack-docker
This example Docker Compose configuration demonstrates many components of the
Elastic Stack, all running on a single machine under Docker.

## Prerequisites
- Docker and Docker Compose.
  * Windows and Mac users get Compose installed automatically
with Docker for Windows/Mac.

  * Linux users can read the [install instructions](https://docs.docker.com/compose/install/#install-compose) or can install via pip:
```
pip install docker-compose
```

* At least 4GiB of RAM for the containers. Windows and Mac users _must_
configure their Docker virtual machine to have more than the default 2 GiB of
RAM:

![Docker VM memory settings](screenshots/docker-vm-memory-settings.png)

## Starting the stack
Try `docker-compose -f docker-compose.setup.yml -f docker-compose.yml up -d` to create a demonstration Elastic Stack with
Elasticsearch, Kibana, Logstash, Auditbeat, Metricbeat, Filebeat, Packetbeat,
and Heartbeat.

Point a browser at [`https://localhost:5601`](https://localhost:5601) to see the results.
> *NOTE*: Elasticsearch and Kibana both now are setup with self-signed certs.

Log in with `elastic` / `changeme`.
