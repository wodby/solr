#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

host=$1

# Create default core if there are no cores.
cores=$(curl -s "http://${host}:8983/solr/admin/cores?action=STATUS" | { grep -c "instanceDir" || true; })

if [[ "${cores}" == 0 ]]; then
    echo "No solr cores found, creating a default core"
    make create core="default" host="${host}" -f /usr/local/bin/actions.mk
fi
