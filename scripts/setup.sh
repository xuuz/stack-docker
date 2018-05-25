#/bin/ash

docker-compose -f docker-compose.yml -f docker-compose.setup.yml up setup_elasticsearch

# restart Elasticsearch so CA's take effect.
docker restart elasticsearch

# setup kibana and logstash (and system passwords)
docker-compose -f docker-compose.yml -f docker-compose.setup.yml up setup_kibana setup_logstash
# setup beats and apm server
docker-compose -f docker-compose.yml -f docker-compose.setup.yml up setup_auditbeat setup_filebeat setup_heartbeat setup_metricbeat setup_packetbeat setup_apm_server


