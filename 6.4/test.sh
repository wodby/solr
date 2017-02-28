#!/usr/bin/env bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

host='localhost:8983'

waitForSolr() {
    started=0

    for i in {30..0}; do
        if solr curl -s "http://${host}"; then
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
    docker exec $NAME "$@"
}

waitForSolr

solr make create core=core1
solr curl -s "http://${host}/solr/core1/admin/ping"
solr make reload core=core1
solr make delete core=core1