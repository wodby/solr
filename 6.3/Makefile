-include env_make

VERSION ?= 6.3

REPO = wodby/solr
NAME = solr-6.3

.PHONY: build test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(VERSION) ./

test:
	make VOLUMES="-v /opt/solr/server/solr" start
	NAME=$(NAME) IMAGE=$(REPO):$(VERSION) ./test.sh
	make clean

push:
	docker push $(REPO):$(VERSION)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release:
	build push
