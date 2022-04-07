# Apache Solr Docker Container Image

[![Build Status](https://github.com/wodby/solr/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/solr/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)

## Docker Images

❗️For better reliability we release images with stability tags (`wodby/solr:8-X.X.X`) which correspond to [git tags](https://github.com/wodby/solr/releases). We strongly recommend using images only with stability tags. 

- All images based on Alpine Linux
- Base image: [wodby/base-solr](https://github.com/wodby/base-solr)
- [GitHub actions builds](https://github.com/wodby/solr/actions) 
- [Docker Hub](https://hub.docker.com/r/wodby/solr)

[_(Dockerfile)_]: https://github.com/wodby/solr/tree/master/Dockerfile

Supported tags and respective `Dockerfile` links:

* `8`, `latest` [_(Dockerfile)_]
* `7.7`, `7` [_(Dockerfile)_]
* `6.6`, `6` [_(Dockerfile)_]
* `5.5`, `5` [_(Dockerfile)_]
* `8-alpine3.13`, `alpine3.13` [_(Dockerfile)_]
* `7.7-alpine3.13`, `7-alpine3.13` [_(Dockerfile)_]
* `6.6-alpine3.13`, `6-alpine3.13` [_(Dockerfile)_]
* `5.5-alpine3.13`, `5-alpine3.13` [_(Dockerfile)_]

## Environment Variables

| Variable                  | Default Value | Description                     |
|---------------------------|---------------|---------------------------------|
| `SOLR_HEAP`               | `1024m `      |                                 |
| `SOLR_DEFAULT_CONFIG_SET` |               | See [config sets](#config-sets) |
| `ZK_HOSTS`                |               |                                 |
| `SOLR_CLOUD_PASSWORD`     |               |                                 |

## Config sets

### Drupal Search API Solr

We recommend running Solr with Zookeeper (Solr Cloud mode) and uploading config sets directly from the Search API Solr Admin UI.

Read [old approach instructions](docs/search_api_solr_old.md)

## Orchestration actions

Usage:
```
make COMMAND [params ...]

commands:
    create (default) core [host config_set instance_dir]
    create-collection collection num_shards config [host] 
    init [host] 
    upgrade 
    ping core [host]
    reload core [host]
    delete core [host]
    update-password username password new_password [host]
    add-admin-user admin_username admin_password user password [host]
    check-ready [host max_try wait_seconds]
 
default params values:
    host localhost
    config_set data_driven_schema_configs (or _default in newer versions)
    max_try 1
    wait_seconds 1
    delay_seconds 0
```

## Deployment

Deploy Solr to your server via ![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby: 

* [Generic Solr](https://wodby.com/stacks/solr)
* [Solr for Drupal](https://wodby.com/stacks/solr-drupal)
