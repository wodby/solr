FROM eclipse-temurin:21-jre-alpine AS base

ARG SOLR_VERSION
# Override the default solr download location with a preferred mirror.
ARG SOLR_DOWNLOAD_SERVER="https://www.apache.org/dyn/closer.lua?action=download&filename=/solr/solr"

# Install tools to download and verify Solr, then clean up
RUN set -ex; \
    apk update; \
    apk add --no-cache wget gnupg dirmngr; \
    export SOLR_BINARY="solr-$SOLR_VERSION$SOLR_DIST.tgz"; \
    MAX_REDIRECTS=3; \
    case "${SOLR_DOWNLOAD_SERVER}" in \
      (*"apache.org"*) ;; \
      (*) MAX_REDIRECTS=4 && SKIP_GPG_CHECK=true ;; \
    esac; \
    export DOWNLOAD_URL="$SOLR_DOWNLOAD_SERVER/$SOLR_VERSION/$SOLR_BINARY"; \
    echo "downloading $DOWNLOAD_URL"; \
    if ! wget -t 10 --max-redirect $MAX_REDIRECTS --retry-connrefused -nv "$DOWNLOAD_URL" -O "/opt/$SOLR_BINARY"; then rm -f "/opt/$SOLR_BINARY"; fi; \
    if [ ! -f "/opt/$SOLR_BINARY" ]; then echo "failed download attempt for $SOLR_BINARY"; exit 1; fi; \
    tar -C /opt --extract --file "/opt/$SOLR_BINARY"; \
    rm "/opt/$SOLR_BINARY"*; \
    apk del gnupg dirmngr

# Metadata labels
LABEL org.opencontainers.image.title="Apache Solr" \
      org.opencontainers.image.description="Solr is the blazing-fast, open source, multi-modal search platform built on Apache Lucene. It powers full-text, vector, and geospatial search at many of the world's largest organizations." \
      org.opencontainers.image.authors="The Apache Solr Project" \
      org.opencontainers.image.url="https://solr.apache.org" \
      org.opencontainers.image.source="https://github.com/apache/solr" \
      org.opencontainers.image.documentation="https://solr.apache.org/guide/" \
      org.opencontainers.image.version="${SOLR_VERSION}" \
      org.opencontainers.image.licenses="Apache-2.0"

# Environment variables
ENV SOLR_USER="solr" \
    SOLR_UID="8983" \
    SOLR_GROUP="solr" \
    SOLR_GID="8983" \
    PATH="/opt/solr/bin:/opt/solr/docker/scripts:/opt/solr/prometheus-exporter/bin:/opt/solr/cross-dc-manager/bin:$PATH" \
    SOLR_INCLUDE=/etc/default/solr.in.sh \
    SOLR_HOME=/var/solr/data \
    SOLR_PID_DIR=/var/solr \
    SOLR_LOGS_DIR=/var/solr/logs \
    LOG4J_PROPS=/var/solr/log4j2.xml \
    SOLR_JETTY_HOST="0.0.0.0" \
    SOLR_ZK_EMBEDDED_HOST="0.0.0.0"

# Create solr system user and group
RUN set -ex; \
    addgroup -S -g "$SOLR_GID" "$SOLR_GROUP"; \
    adduser -S -u "$SOLR_UID" -G "$SOLR_GROUP" "$SOLR_USER"

# Symlink /opt/solr to the unpacked solr directory and remove extra files
RUN set -ex; \
    cd /opt && ln -s solr-*/ solr; \
    rm -Rf /opt/solr/docs /opt/solr/docker/Dockerfile

# Setup Solr configuration and permissions
RUN set -ex; \
    mkdir -p /opt/solr/server/solr/lib /docker-entrypoint-initdb.d /etc/default; \
    cp /opt/solr/bin/solr.in.sh /etc/default/solr.in.sh; \
    mv /opt/solr/bin/solr.in.sh /opt/solr/bin/solr.in.sh.orig; \
    mv /opt/solr/bin/solr.in.cmd /opt/solr/bin/solr.in.cmd.orig; \
    chmod 0664 /etc/default/solr.in.sh; \
    mkdir -p -m0770 /var/solr; \
    chown -R "$SOLR_USER:0" /var/solr; \
    test ! -e /opt/solr/modules || ln -s /opt/solr/modules /opt/solr/contrib; \
    test ! -e /opt/solr/prometheus-exporter || ln -s /opt/solr/prometheus-exporter /opt/solr/modules/prometheus-exporter

VOLUME /var/solr
EXPOSE 8983
WORKDIR /opt/solr
USER $SOLR_UID

####################################################################################################

FROM base

ARG SOLR_VERSION

ENV SOLR_HEAP="1024m" \
    TINI='no'

USER root

RUN set -ex; \
    \
    apk add --no-cache \
        bash \
        curl \
        jq \
        make \
        procps-ng \
        sudo; \
    \
    chown -R solr:solr /etc/default/ /opt/solr-${SOLR_VERSION}/server/solr; \
    \
    rm -rf /var/cache/apk/*

COPY bin /usr/local/bin
COPY entrypoint.sh /
COPY security.json /

USER solr

ENTRYPOINT ["/entrypoint.sh"]
CMD ["solr-foreground", "-c"]
