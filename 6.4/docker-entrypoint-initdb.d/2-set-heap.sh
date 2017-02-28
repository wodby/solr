#!/bin/bash

set -e

if [[ ! -z $DEBUG ]]; then
  set -x
fi

sed -i 's@^SOLR_HEAP=".*"@'"SOLR_HEAP=${SOLR_HEAP}"'@' /opt/solr/bin/solr.in.sh
