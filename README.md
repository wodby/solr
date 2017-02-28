# Generic Apache Solr docker image

[![Build Status](https://travis-ci.org/wodby/solr.svg?branch=master)](https://travis-ci.org/wodby/solr)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)

## Supported tags and respective `Dockerfile` links

- [`6.4`, `latest` (*6.4/Dockerfile*)](https://github.com/wodby/solr/tree/master/6.4/Dockerfile)
- [`6.3` (*6.3/Dockerfile*)](https://github.com/wodby/solr/tree/master/6.3/Dockerfile)
- [`5.5` (*5.5/Dockerfile*)](https://github.com/wodby/solr/tree/master/5.5/Dockerfile)

## Actions

```bash
docker exec $NAME make create core=core1
docker exec $NAME make delete core=core1
docker exec $NAME make reload core=core1
```
