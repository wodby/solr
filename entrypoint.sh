#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

sudo init_volumes

gotpl /etc/gotpl/solr.in.sh.tmpl > /etc/default/solr.in.sh

migrate

if [[ "${1}" == 'make' ]]; then
    exec "$@" -f /usr/local/bin/actions.mk
else
    exec docker-entrypoint.sh "$@"
fi
