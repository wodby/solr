-include env_make

SOLR_VER ?= 8.11.1
SOLR_MINOR_VER=$(shell echo "${SOLR_VER}" | grep -oE '^[0-9]+\.[0-9]+')

ALPINE_VER ?= 3.15
TAG ?= $(SOLR_MINOR_VER)-alpine$(ALPINE_VER)

REPO = wodby/solr
NAME = solr-$(SOLR_VER)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) --build-arg SOLR_VER=$(SOLR_VER) --build-arg ALPINE_VER=$(ALPINE_VER) ./

test:
	cd ./tests && IMAGE=$(REPO):$(TAG) NAME=$(NAME) ./run.sh

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) -e DEBUG=1 $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push
