#!/bin/bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

if [[ "${1}" == 'make' ]]; then
    exec "$@" -f /opt/docker-solr/scripts/solr.mk
else
    exec "$@"
fi

exec docker-entrypoint.sh "$@"