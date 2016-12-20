#!/usr/bin/env bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

name=${NAME:-solr}
host=${HOST:-localhost}
port=${PORT:-8983}
started=0

for i in {30..0}; do
    if docker exec "$name" curl -s "http://$host:$port"; then
        started=1
        break
    fi
    echo 'Solr starting...'
    sleep 1
done

if [[ "$started" -eq '0' ]]; then
    echo >&2 'Error. Solr is unreachable.'
    exit 1
fi

echo 'Solr has started!'

echo 'Create Solr cores'
echo '========================================================================='
docker exec "$name" solr-create-core core1
docker exec "$name" solr-create-core core2 drupal7
docker exec "$name" solr-create-core core3 drupal8

echo 'Verify Solr cores'
echo '========================================================================='
docker exec "$name" curl -s http://localhost:8983/solr/core1/admin/ping
docker exec "$name" curl -s http://localhost:8983/solr/core2/admin/ping
docker exec "$name" curl -s http://localhost:8983/solr/core3/admin/ping

echo 'Reload Solr cores'
echo '========================================================================='
docker exec "$name" solr-reload-core core1
docker exec "$name" solr-reload-core core2
docker exec "$name" solr-reload-core core3

echo 'Delete Solr cores'
echo '========================================================================='
docker exec "$name" solr-delete-core core1
docker exec "$name" solr-delete-core core2
docker exec "$name" solr-delete-core core3
