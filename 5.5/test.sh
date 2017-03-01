#!/usr/bin/env bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

HOST="solr"
PORT="8983"
CORE="core1"

solr() {
    docker run --rm -i --link "${NAME}":"${HOST}" "${IMAGE}" "$@"
}

echo "Checking solr readiness..."
solr make check-ready core=$CORE host=$HOST port=$PORT
echo "Creating new core..."
solr make core=$CORE host=$HOST port=$PORT
echo "Checking if core has been created..."
solr make ping core=$CORE host=$HOST port=$PORT
echo "Reloading core..."
solr make reload core=$CORE host=$HOST port=$PORT
echo "Deleting core..."
solr make delete core=$CORE host=$HOST port=$PORT
echo "Checking if core has been deleted..."
solr bash -c "curl -sIN 'http://$HOST:$PORT/solr/$CORE/admin/ping' | head -n 1 | awk '{print \$2}' | grep 404"
