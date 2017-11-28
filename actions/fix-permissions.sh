#!/bin/bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [ "$#" -lt 3 ]; then
    echo "Illegal number of parameters"
fi

chown "${1}:${2}" "${@:3}"
