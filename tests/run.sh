#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

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

echo "Initializing (creating default core)..."
run_action init 
echo "OK"

docker compose down
