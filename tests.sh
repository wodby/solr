#!/usr/bin/env bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

name=${NAME:-solr}

docker exec "$name" solr-create-core core1
docker exec "$name" solr-create-core core2 drupal7
docker exec "$name" solr-create-core core3 drupal8

curl -s http://localhost:8983/solr/core1/admin/ping
curl -s http://localhost:8983/solr/core2/admin/ping
curl -s http://localhost:8983/solr/core3/admin/ping

docker exec "$name" solr-reload-core core1
docker exec "$name" solr-reload-core core2
docker exec "$name" solr-reload-core core3

docker exec "$name" solr-delete-core core1
docker exec "$name" solr-delete-core core2
docker exec "$name" solr-delete-core core3
