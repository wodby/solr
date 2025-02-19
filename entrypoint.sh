#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

migrate

sed -E -i 's@^#SOLR_HEAP=".*"@'"SOLR_HEAP=${SOLR_HEAP}"'@' /etc/default/solr.in.sh

if [[ "${1}" == 'make' ]]; then
    exec "$@" -f /usr/local/bin/actions.mk
else
    exec docker-entrypoint.sh "$@"
fi
