ARG BASE_IMAGE_TAG

FROM solr:${BASE_IMAGE_TAG}

ARG SOLR_VER

ENV SOLR_HEAP="1024m" \
    SOLR_VER="${SOLR_VER}"

USER root

COPY search-api-solr.sh .

RUN set -ex; \
    \
    apk add --no-cache \
        bash \
        curl \
        make \
        sudo; \
    \
    apk add --update --no-cache -t .solr-build-deps \
        jq \
        python3; \
    \
    pip3 install yq; \
    \
    echo "chown solr:solr /opt/solr/server/solr" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    echo 'solr ALL=(root) NOPASSWD:SETENV: /usr/local/bin/init_volumes' > /etc/sudoers.d/solr; \
    \
    bash search-api-solr.sh; \
    # Move out from volume to always keep them inside of the image.
    mv /opt/solr/server/solr/configsets/* /opt/docker-solr/configsets/; \
    mv /opt/solr/server/solr/solr.xml /opt/docker-solr/solr.xml; \
    \
    apk del --purge .solr-build-deps; \
    rm -rf \
        /opt/solr/server/solr/mycores \
        search-api-solr.sh \
        /var/cache/apk/*

COPY bin /usr/local/bin
COPY entrypoint.sh /

USER solr

VOLUME /opt/solr/server/solr
WORKDIR /opt/solr/server/solr

ENTRYPOINT ["/entrypoint.sh"]
CMD ["solr-foreground"]
