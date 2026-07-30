#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

cleanup() {
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
