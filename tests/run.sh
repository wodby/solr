#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

standalone_container="solr-standalone-test-$$"

cleanup() {
    docker rm -f "${standalone_container}" >/dev/null 2>&1 || true
    docker compose down -v
}
trap cleanup EXIT

docker_exec() {
    docker compose exec -T "${@}"
}

run_action() {
    docker_exec solr make "${@:1}" -f /usr/local/bin/actions.mk
}

docker compose up -d

echo "Checking solr readiness..."
run_action check-ready max_try=25 delay_seconds=5
echo "OK"

echo "Initializing (creating default collection)..."
run_action init 
echo "OK"

echo "Checking repeated initialization..."
run_action init
echo "OK"

echo "Checking authenticated collection creation action..."
run_action create-collection collection=action-test num_shards=1 config=_default
echo "OK"

echo "Checking implicit actions makefile..."
docker run --rm "$IMAGE" make check-live
echo "OK"

echo "Checking standalone initialization..."
docker run --rm -d --name "${standalone_container}" -e SOLR_STANDALONE=1 "$IMAGE" >/dev/null
docker exec "${standalone_container}" wait-for-solr.sh \
    --solr-url http://localhost:8983 --max-attempts 25 --wait-seconds 1
docker exec "${standalone_container}" make init host=localhost -f /usr/local/bin/actions.mk
docker exec "${standalone_container}" make init host=localhost -f /usr/local/bin/actions.mk
docker stop "${standalone_container}" >/dev/null
echo "OK"
