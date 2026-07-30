#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

sudo init_volumes

gotpl /etc/gotpl/solr.in.sh.tmpl > /etc/default/solr.in.sh

migrate

if [[ "${1}" == 'make' ]]; then
    for arg in "$@"; do
        case "${arg}" in
            -f|-f*|--file|--file=*|--makefile|--makefile=*)
                exec "$@"
                ;;
        esac
    done
    exec "$@" -f /usr/local/bin/actions.mk
fi

if [[ "${@}" == "solr-foreground -c" && "${SOLR_STANDALONE}" ]]; then
    exec docker-entrypoint.sh solr-foreground
fi

exec docker-entrypoint.sh "$@"
