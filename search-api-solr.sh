#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

cd /opt/docker-solr/

api_url="https://updates.drupal.org/release-history/search_api_solr"
search_api_url="https://ftp.drupal.org/files/projects/search_api_solr"
latest=""

for drupal in "8.x" "7.x"; do
    versions=($(curl -s "${api_url}/${drupal}" | xq -r '.project.releases[] | .[] | select (has("version_extra") | not).version'))

    for version in "${versions[@]}"; do
        if [[ -z "${latest}" ]]; then
            latest="${version}"
        fi

        tmp_dir="search_api_solr_${version}"
        mkdir -p "${tmp_dir}"
        wget -qO- "${search_api_url}-${version}.tar.gz" | tar xz -C "${tmp_dir}"

        dir="${tmp_dir}/search_api_solr/solr-conf/${SOLR_VER:0:1}.x"

        echo -n "Search Api Solr ${version}: "

        if [[ -d "${dir}" ]]; then
            echo "adding config set for ${SOLR_VER:0:1}.x"
            conf_dir="configsets/search_api_solr_${version}"
            mkdir -p "${conf_dir}"
            mv "${dir}" "${conf_dir}/conf"; \
        else
            echo "does not support Solr ${SOLR_VER:0:1}.x"
        fi

        rm -rf "${tmp_dir}"
    done
done

echo "${latest}"
