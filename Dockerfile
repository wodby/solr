ARG SOLR_VER

FROM solr:${SOLR_VER}-alpine

ARG SOLR_VER

ENV SOLR_HEAP="1024m" \
    SOLR_VER="${SOLR_VER}"

USER root

RUN set -ex; \
    \
    apk add --no-cache \
        curl \
        make \
        sudo; \
    \
    # Script to fix volumes permissions via sudo.
    echo "chown solr:solr /opt/solr/server/solr" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    echo 'solr ALL=(root) NOPASSWD:SETENV: /usr/local/bin/init_volumes' > /etc/sudoers.d/solr; \
    \
    # Move out from volume for persistency
    mv /opt/solr/server/solr/solr.xml /opt/docker-solr/solr.xml; \
    mv /opt/solr/server/solr/configsets /opt/docker-solr/configsets; \
    \
    rm -rf /var/cache/apk/*

COPY actions /usr/local/bin
COPY entrypoint.sh /

USER $SOLR_USER

VOLUME /opt/solr/server/solr
WORKDIR /opt/solr/server/solr

ENTRYPOINT ["/entrypoint.sh"]
CMD ["solr-foreground"]
