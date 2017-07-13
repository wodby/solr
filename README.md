# Apache Solr Docker Container Image

[![Build Status](https://travis-ci.org/wodby/solr.svg?branch=master)](https://travis-ci.org/wodby/solr)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Docker Images

Images are built via [Travis CI](https://travis-ci.org/wodby/solr) and published on [Docker Hub](https://hub.docker.com/r/wodby/solr). 

## Versions

| Solr | Alpine Linux |
| --- | ------------ |
| [6.6.0](https://github.com/wodby/solr/tree/master/6.6/Dockerfile) | 3.6 |  
| [6.5.1](https://github.com/wodby/solr/tree/master/6.5/Dockerfile) | 3.6 |  
| [6.4.2](https://github.com/wodby/solr/tree/master/6.4/Dockerfile) | 3.6 |  
| [6.3.0](https://github.com/wodby/solr/tree/master/6.3/Dockerfile) | 3.6 |  
| [5.5.0](https://github.com/wodby/solr/tree/master/5.5/Dockerfile) | 3.6 |  
| [5.4.1](https://github.com/wodby/solr/tree/master/5.4/Dockerfile) | 3.6 |  

## Environment Variables

| Variable | Default Value |
| -------- | ------------- | 
| SOLR_HEAP | 1024m |

## Orchestration Actions

Usage:
```
make COMMAND [params ...]

commands:
    create (default) core [host config_set] 
    ping core [host]
    reload core [host]
    delete core [host]
    check-ready [host max_try wait_seconds]
 
default params values:
    host localhost
    config_set data_driven_schema_configs
    max_try 1
    wait_seconds 1
    delay_seconds 1
```

## Deployment

Deploy Solr to your server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://cloud.wodby.com/stackhub/dc8074a9-f27d-44a8-8f88-5922b4e16d2f).
