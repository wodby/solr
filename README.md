# Generic Apache Solr docker image

[![Build Status](https://travis-ci.org/wodby/solr.svg?branch=master)](https://travis-ci.org/wodby/solr)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/solr.svg)](https://hub.docker.com/r/wodby/solr)

[![Wodby Slack](https://www.google.com/s2/favicons?domain=www.slack.com) Join us on Slack](https://slack.wodby.com/)

## Supported tags and respective `Dockerfile` links

- [`6.4`, `latest` (*6.4/Dockerfile*)](https://github.com/wodby/solr/tree/master/6.4/Dockerfile)
- [`6.3` (*6.3/Dockerfile*)](https://github.com/wodby/solr/tree/master/6.3/Dockerfile)
- [`5.5` (*5.5/Dockerfile*)](https://github.com/wodby/solr/tree/master/5.5/Dockerfile)

## Actions

Usage:
```
make COMMAND [host=localhost] [port=8983] [params ...]

commands:
    create (default)
    ping
    reload
    delete
    check-ready
    check-live
```

Examples:

```bash
# Check if Solr is ready
docker exec -ti [ID] make check-ready -f /usr/local/bin/Makefile

# Create new core1
docker exec -ti [ID] make core=core1 -f /usr/local/bin/Makefile

# Ping core1
docker exec -ti [ID] make ping core=core1 -f /usr/local/bin/Makefile

# Reload core1
docker exec -ti [ID] make reload core=core1 -f /usr/local/bin/Makefile

# Delete core1
docker exec -ti [ID] make delete core=core1 -f /usr/local/bin/Makefile
```

## Using in Production

Deploy Apache Solr to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://wodby.com).
