#/bin/ash

chown 1000 -R ${PWD}/config
find ${PWD}/config -type f -name "*.keystore" -print -exec chmod go-wrx {} \;
find ${PWD}/config -type f -name "*.yml" -print -exec chmod go-wrx {} \;

docker-compose -f docker-compose.yml -f docker-compose.setup.yml up setup_elasticsearch

# restart Elasticsearch so CA's take effect.
docker restart elasticsearch

# setup kibana and logstash (and system passwords)
docker-compose -f docker-compose.yml -f docker-compose.setup.yml up setup_kibana setup_logstash
# setup beats and apm server
docker-compose -f docker-compose.yml -f docker-compose.setup.yml up setup_auditbeat setup_filebeat setup_heartbeat setup_metricbeat setup_packetbeat setup_apm_server

docker-compose -f docker-compose.yml -f docker-compose.setup.yml down --remove-orphans

echo "All setup please run: docker-compose up -d"
