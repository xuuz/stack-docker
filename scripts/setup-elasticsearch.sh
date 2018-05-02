#!/bin/bash

if [[ -n "$ELASTIC_PASSWORD" ]]; then
    [[ -f /usr/share/elasticsearch/config/elasticsearch.keystore ]] || (/usr/share/elasticsearch/bin/elasticsearch-keystore create)
    (echo "$ELASTIC_PASSWORD" | /usr/share/elasticsearch/bin/elasticsearch-keystore add -x 'bootstrap.password')
fi
