#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

sudo init_volumes

gotpl /etc/gotpl/solr.in.sh.tmpl > /etc/default/solr.in.sh

migrate

if [[ -n "${SOLR_STANDALONE}" && ! -e "${SOLR_HOME}/configsets" && ! -L "${SOLR_HOME}/configsets" ]]; then
    # User-managed cores resolve named config sets beneath SOLR_HOME, while distributions ship them under /opt/solr.
    mkdir -p "${SOLR_HOME}"
    ln -s /opt/solr/server/solr/configsets "${SOLR_HOME}/configsets"
fi

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

if [[ "${@}" == "solr-foreground -c" ]]; then
    # Solr 10 defaults to cloud mode and replaces the -c flag with --user-managed for standalone mode.
    if [[ "${SOLR_VERSION%%.*}" -ge 10 ]]; then
        if [[ -n "${SOLR_STANDALONE}" ]]; then
            exec docker-entrypoint.sh solr-foreground --user-managed
        fi
        exec docker-entrypoint.sh solr-foreground
    elif [[ -n "${SOLR_STANDALONE}" ]]; then
        exec docker-entrypoint.sh solr-foreground
    fi
fi

exec docker-entrypoint.sh "$@"
