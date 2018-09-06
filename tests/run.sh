#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

host="solr"
core="core1"

cid="$(
	docker run -d -e DEBUG --name "${NAME}" "${IMAGE}"
)"
trap "docker rm -vf ${cid} > /dev/null" EXIT

solr() {
    docker run --rm -i -e DEBUG --link "${NAME}":"${host}" "${IMAGE}" "$@"
}

echo "Checking solr readiness..."
solr make check-ready host="${host}" max_try=25 delay_seconds=5

echo "Initializing (creating default core)..."
solr make init host="${host}"

echo "Checking if default core has been created..."
solr make ping core="default" host="${host}"

echo "Checking init with existing core..."
solr make init host="${host}"

configsets=($(solr sh -c 'ls -d configsets/* | sed "s/configsets\///"'))

for config in "${configsets[@]}"; do
    echo "Creating new core..."
    solr make core="${core}" config_set="${config}" host="${host}"

    echo "Checking if core has been created..."
    solr make ping core="${core}" config_set="${config}" host="${host}"

    echo "Reloading core..."
    solr make reload core="${core}" config_set="${config}" host="${host}"

    echo "Deleting core..."
    solr make delete core="${core}" config_set="${config}" host="${host}"

    echo "Checking if core has been deleted..."
    solr bash -c "curl -sIN 'http://${host}:8983/solr/${core}/admin/ping' | head -n 1 | awk '{print \$2}' | grep 404"
done;