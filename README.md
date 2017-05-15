# Generic Apache Solr docker container image

[![Build Status](https://travis-ci.org/wodby/solr.svg?branch=master)](https://travis-ci.org/wodby/solr)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)

[![Wodby Slack](https://www.google.com/s2/favicons?domain=www.slack.com) Join us on Slack](https://slack.wodby.com/)

## Supported tags and respective `Dockerfile` links

- [`6.4`, `latest` (*6.4/Dockerfile*)](https://github.com/wodby/solr/tree/master/6.4/Dockerfile)
- [`6.3` (*6.3/Dockerfile*)](https://github.com/wodby/solr/tree/master/6.3/Dockerfile)
- [`5.5` (*5.5/Dockerfile*)](https://github.com/wodby/solr/tree/master/5.5/Dockerfile)
- [`5.4` (*5.4/Dockerfile*)](https://github.com/wodby/solr/tree/master/5.4/Dockerfile)

## Actions

Usage:
```
make COMMAND [params ...]

commands:
    create (default) core=<core-name> [host=<solr> config_set=<config_set>] 
    ping core=<core-name> [host=<solr>]
    reload core=<core-name> [host=<solr>]
    delete core=<core-name> [host=<solr>]
    check-ready [host=<solr> max_try=<10> wait_seconds=<5>]
 
default params values:
    host localhost
    config_set data_driven_schema_configs
    max_try 12
    wait_seconds 5
```

Examples:

```bash
# Check if Solr is ready
docker exec -ti [ID] make check-ready -f /usr/local/bin/actions.mk

# Create new core1
docker exec -ti [ID] make core=core1 -f /usr/local/bin/actions.mk

# Ping core1
docker exec -ti [ID] make ping core=core1 -f /usr/local/bin/actions.mk

# Reload core1
docker exec -ti [ID] make reload core=core1 -f /usr/local/bin/actions.mk

# Delete core1
docker exec -ti [ID] make delete core=core1 -f /usr/local/bin/actions.mk
```

You can skip -f option if you use run instead of exec.

## Using in Production

Deploy Apache Solr to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://wodby.com).
