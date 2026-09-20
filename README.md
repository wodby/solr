# Apache Solr Docker Container Image

[![Build Status](https://github.com/wodby/solr/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/solr/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)

## Docker Images

This Solr image runs in Solr Cloud mode by default, set `SOLR_STANDALONE=1` to run in standalone.

Use image revision tags such as `wodby/solr:<major>-rN` to select a Wodby image revision.
Major and minor tags use the repository release number. Full-version tags such as
`wodby/solr:10.0.0-r0` start at `r0` for each exact upstream version.
Every published versioned revision tag has a matching annotated Git tag pointing to its release commit.
Existing tags remain available after support for their major or minor version ends.
See [release tags](https://github.com/wodby/solr/tags) for available revisions and the [image revision policy](https://github.com/wodby/images#image-revisions) for upgrade guidance.
Previously published image tags remain available.

- All images based on Alpine Linux
- Base image: [eclipse-temurin](https://github.com/adoptium/containers)
- [GitHub actions builds](https://github.com/wodby/solr/actions) 
- [Docker Hub](https://hub.docker.com/r/wodby/solr)

[_(Dockerfile)_]: https://github.com/wodby/solr/tree/master/Dockerfile

Supported tags and respective `Dockerfile` links:

* `10.0`, `10`, `latest` [_(Dockerfile)_]
* `9.10`, `9` [_(Dockerfile)_]

### Supported architectures

All images built for `linux/amd64` and `linux/arm64`

## Environment Variables

| Variable              | Default Value | Description                                          |
|-----------------------|---------------|------------------------------------------------------|
| `SOLR_HEAP`           | `1024m `      |                                                      |
| `ZK_HOST`             |               |                                                      |
| `SOLR_CLOUD_PASSWORD` |               |                                                      |
| `SOLR_STANDALONE`     |               | Set to any non-empty value to run in standalone mode |

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
