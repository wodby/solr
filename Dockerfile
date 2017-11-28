ARG SOLR_VER

FROM solr:${SOLR_VER}-alpine

ENV SOLR_HEAP="1024m" \
    SOLR_VER="${SOLR_VER}"

USER root

RUN apk add --no-cache \
        curl \
        make \
        sudo && \

    echo 'solr ALL=(root) NOPASSWD: /usr/local/bin/fix-permissions.sh' > /etc/sudoers.d/solr && \

    # Move out from volume for persistency
    mv /opt/solr/server/solr/solr.xml /opt/docker-solr/solr.xml && \
    mv /opt/solr/server/solr/configsets /opt/docker-solr/configsets && \

    rm -rf /var/cache/apk/*

COPY actions /usr/local/bin
COPY entrypoint.sh /

USER $SOLR_USER

VOLUME /opt/solr/server/solr
WORKDIR /opt/solr/server/solr

ENTRYPOINT ["/entrypoint.sh"]
CMD ["solr-foreground"]
