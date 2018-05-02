SHELL=/bin/bash

ifndef ELASTIC_VERSION
ELASTIC_VERSION := $(shell awk 'BEGIN { FS = "[= ]" } /^ELASTIC_VERSION=/ { print $$2 }' .env)
endif
export ELASTIC_VERSION

ifndef GIT_BRANCH
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
endif

TARGETS := apm-server elasticsearch logstash kibana beats

images: $(TARGETS)
push: $(TARGETS:%=%-push)
clean: $(TARGETS:%=%-clean)

$(TARGETS): $(TARGETS:%=%-checkout)
	(cd stack/$@ && make)

$(TARGETS:%=%-push): $(TARGETS:%=%-checkout)
	(cd stack/$(@:%-push=%) && make push)

$(TARGETS:%=%-checkout):
	test -d stack/$(@:%-checkout=%) || \
          git clone https://github.com/elastic/$(@:%-checkout=%)-docker.git stack/$(@:%-checkout=%)
	(cd stack/$(@:%-checkout=%) && git fetch && git reset --hard && git checkout origin/$(GIT_BRANCH))

$(TARGETS:%=%-clean):
	rm -rf stack/$(@:%-clean=%)

deploy:
	docker-compose up -d

deploy_elasticsearch: setup_elasticsearch
	docker-compose up -d elasticsearch

deploy_kibana: deploy_elasticsearch
	docker-compose up -d kibana

down:
	docker-compose down

purge:
	docker-compose down --volumes --remove-orphans

setup_elasticsearch:
	docker-compose run -e ELASTIC_PASSWORD=changeme elasticsearch /usr/local/bin/setup-elasticsearch.sh

setup_logstash:
	docker-compose run --no-deps -e ELASTIC_PASSWORD=changeme logstash /usr/local/bin/setup-logstash.sh

setup_kibana:
	docker-compose run --no-deps -e ELASTIC_PASSWORD=changeme kibana /usr/local/bin/setup-kibana.sh

setup_auditbeat:
	docker-compose run --no-deps -e ELASTIC_PASSWORD=changeme auditbeat /usr/local/bin/setup-beat.sh auditbeat

setup_filebeat:
	docker-compose run --no-deps -e ELASTIC_PASSWORD=changeme filebeat /usr/local/bin/setup-beat.sh filebeat

setup_heartbeat:
	docker-compose run --no-deps -e ELASTIC_PASSWORD=changeme heartbeat /usr/local/bin/setup-beat.sh heartbeat

setup_metricbeat:
	docker-compose run --no-deps -e ELASTIC_PASSWORD=changeme metricbeat /usr/local/bin/setup-beat.sh metricbeat

setup_packetbeat:
	docker run --rm -it --cap-add=NET_ADMIN  -e ELASTIC_PASSWORD=changeme -v `pwd`/scripts/setup-beat.sh:/usr/local/bin/setup-beat.sh:ro --network=stack-docker_stack --entrypoint="/bin/sh" docker.elastic.co/beats/packetbeat:6.2.4 -c  "/usr/local/bin/setup-beat.sh packetbeat"

setup_apm-server:
	docker-compose run --no-deps -e ELASTIC_PASSWORD=changeme apm-server /usr/local/bin/setup-beat.sh apm-server

SETUP_TARGETS:= setup_logstash setup_kibana setup_auditbeat setup_filebeat setup_heartbeat setup_metricbeat setup_packetbeat setup_apm-server

setup: deploy_kibana
	$(MAKE) -j $(SETUP_TARGETS) && stty sane

magic: setup deploy
