#!/usr/bin/env bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

host='solr'
port='8983'

waitForSolr() {
    started=0

    for i in {30..0}; do
        if solr curl -s "http://${host}:${port}"; then
            started=1
            break
        fi
        echo 'Solr is starting...'
        sleep 5
    done

    if [[ "$started" -eq '0' ]]; then
        echo >&2 'Error. Solr is unreachable.'
        exit 1
    fi

    echo 'Solr has started!'
}

solr() {
    docker run --rm -i --link "${NAME}":"${host}" "${IMAGE}" "$@"
}

waitForSolr

echo "Creating new core..."
solr make core=core1 | grep "200 OK"
echo "Checking if core has been created..."
solr make ping core=core1 | grep "200 OK"
echo "Reloading core..."
solr make reload core=core1 | grep "200 OK"
echo "Deleting core..."
solr make delete core=core1 | grep "200 OK"
echo "Checking if core has been deleted..."
solr make ping core=core1 | grep "404 Not Found"
