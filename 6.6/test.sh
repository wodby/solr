#!/usr/bin/env bash

set -e

if [[ ! -z "${DEBUG}" ]]; then
    set -x
fi

host="solr"
core="core1"

cid="$(
	docker run -d --name "${NAME}" "${IMAGE}"
)"
trap "docker rm -vf ${cid} > /dev/null" EXIT

solr() {
    docker run --rm -i --link "${NAME}":"${host}" "${IMAGE}" "$@"
}

echo "Checking solr readiness..."
solr make check-ready host="${host}" max_try=25 delay_seconds=5
echo "Creating new core..."
solr make core="${core}" host="${host}"
echo "Checking if core has been created..."
solr make ping core="${core}" host="${host}"
echo "Reloading core..."
solr make reload core="${core}" host="${host}"
echo "Deleting core..."
solr make delete core="${core}" host="${host}"
echo "Checking if core has been deleted..."
solr bash -c "curl -sIN 'http://${host}:8983/solr/${core}/admin/ping' | head -n 1 | awk '{print \$2}' | grep 404"
