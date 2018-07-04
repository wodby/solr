# Apache Solr Docker Container Image

[![Build Status](https://travis-ci.org/wodby/solr.svg?branch=master)](https://travis-ci.org/wodby/solr)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/solr.svg)](https://microbadger.com/images/wodby/solr)

## Docker Images

❗️For better reliability we release images with stability tags (`wodby/solr:7-X.X.X`) which correspond to [git tags](https://github.com/wodby/solr/releases). We strongly recommend using images only with stability tags. 

* All images are based on Alpine Linux
* Base image: [solr](https://hub.docker.com/r/_/solr)
* [Travis CI builds](https://travis-ci.org/wodby/solr) 
* [Docker Hub](https://hub.docker.com/r/wodby/solr)

[_(Dockerfile)_]: https://github.com/wodby/solr/tree/master/Dockerfile

Supported tags and respective `Dockerfile` links:

* `7.4`, `7`, `latest` [_(Dockerfile)_]
* `7.3` [_(Dockerfile)_]
* `7.2` [_(Dockerfile)_]
* `7.1` [_(Dockerfile)_]
* `6.6`, `6` [_(Dockerfile)_]
* `5.5`, `5` [_(Dockerfile)_]
* `5.4` [_(Dockerfile)_]

## Environment Variables

| Variable    | Default Value |
| ----------- | ------------- |
| `SOLR_HEAP` | `1024m `      |

## Orchestration actions

Usage:
```
make COMMAND [params ...]

commands:
    create (default) core [host config_set instance_dir] 
    init [host] 
    ping core [host]
    reload core [host]
    delete core [host]
    check-ready [host max_try wait_seconds]
 
default params values:
    host localhost
    config_set data_driven_schema_configs (or _default in newer versions)
    max_try 1
    wait_seconds 1
    delay_seconds 0
```

## Deployment

Deploy Solr to your server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://cloud.wodby.com/stackhub/dc8074a9-f27d-44a8-8f88-5922b4e16d2f).
