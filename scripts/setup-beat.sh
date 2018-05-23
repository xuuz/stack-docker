#!/bin/bash

set -euo pipefail

beat=$1


until curl -s -k https://kibana:5601; do
    sleep 2
done
sleep 5

chmod go-w /usr/share/$beat/$beat.yml


echo "Creating keystore..."
# create beat keystore
${beat} --strict.perms=false keystore create --force
chown 1000 /usr/share/$beat/$beat.keystore

echo "adding ES_PASSWORD to keystore..."
echo "$ELASTIC_PASSWORD" | ${beat} --strict.perms=false keystore add ES_PASSWORD --stdin
${beat} --strict.perms=false keystore list

echo "Setting up dashboards..."
# Load the sample dashboards for the Beat.
# REF: https://www.elastic.co/guide/en/beats/metricbeat/master/metricbeat-sample-dashboards.html
${beat} --strict.perms=false setup -v
exit 1

echo "Copy keystore to ./config dir"
ls -la /usr/share/$beat
cp /usr/share/$beat/$beat.keystore /config/$beat/$beat.keystore
chown 1000:1000 /config/$beat/$beat.keystore
