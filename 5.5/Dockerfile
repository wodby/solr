FROM solr:5.5-alpine

ENV SOLR_HEAP 1024m

USER 0
RUN apk add --no-cache sudo curl make && \
    echo 'solr ALL=(root) NOPASSWD: /opt/docker-solr/scripts/solr-fix-permissions' > /etc/sudoers.d/solr

RUN mv /opt/solr/server/solr/solr.xml /opt/docker-solr/solr.xml && \
    mv /opt/solr/server/solr/configsets /opt/docker-solr/configsets

USER $SOLR_USER

COPY scripts /opt/docker-solr/scripts/

VOLUME /opt/solr/server/solr
WORKDIR /opt/solr/server/solr

ENTRYPOINT ["docker-entrypoint-solr.sh"]
CMD ["solr-foreground"]
