#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

sudo init_volumes

mkdir -p /opt/solr/server/solr/configsets

# Symlinks config sets to volume.
for configset in $(ls -d /opt/docker-solr/configsets/*); do
    ln -s "${configset}" /opt/solr/server/solr/configsets/;
done

if [[ ! -f /opt/solr/server/solr/solr.xml ]]; then
    ln -s /opt/docker-solr/solr.xml /opt/solr/server/solr/solr.xml
fi

sed -i 's@^SOLR_HEAP=".*"@'"SOLR_HEAP=${SOLR_HEAP}"'@' /opt/solr/bin/solr.in.sh

if [[ "${1}" == 'make' ]]; then
    exec "$@" -f /usr/local/bin/actions.mk
else
    exec docker-entrypoint.sh "$@"
fi
