#!/usr/bin/env bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

HOST='solr'
PORT='8983'

solr() {
    docker run --rm -i --link "${NAME}":"${HOST}" "${IMAGE}" "$@"
}

echo "Creating new core..."
solr make core=core1 host=$HOST port=$PORT | grep "200 OK"
echo "Checking if core has been created..."
solr make ping core=core1 host=$HOST port=$PORT | grep "200 OK"
echo "Reloading core..."
solr make reload core=core1 host=$HOST port=$PORT | grep "200 OK"
echo "Deleting core..."
solr make delete core=core1 host=$HOST port=$PORT | grep "200 OK"
echo "Checking if core has been deleted..."
solr make ping core=core1 host=$HOST port=$PORT | grep "404 Not Found"
