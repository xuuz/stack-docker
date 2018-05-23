#/bin/ash

docker-compose -f docker-compose.yml -f docker-compose.setup.yml run setup_elasticsearch

docker-compose -f docker-compose.yml -f docker-compose.setup.yml run setup_kibana setup_logstash


