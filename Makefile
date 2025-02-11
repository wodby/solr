-include env_make

SOLR_VER ?= 9.8.0
SOLR_VER_MINOR=$(shell echo "${SOLR_VER}" | grep -oE '^[0-9]+\.[0-9]+')

TAG ?= $(SOLR_VER_MINOR)

REPO = wodby/solr
NAME = solr-$(SOLR_VER)

PLATFORM ?= linux/arm64

ifneq ($(ARCH),)
	override TAG := $(TAG)-$(ARCH)
endif

.PHONY: test push shell run start stop logs clean release

default: buildx-build

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    --build-arg SOLR_VERSION=$(SOLR_VER) \
	    --load \
		./
.PHONY: buildx-build

buildx-push:
	docker buildx build --push --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    --build-arg SOLR_VERSION=$(SOLR_VER) \
	    ./

buildx-imagetools-create:
	docker buildx imagetools create -t $(REPO):$(TAG) \
				  $(REPO):$(SOLR_VER_MINOR)-amd64 \
				  $(REPO):$(SOLR_VER_MINOR)-arm64
.PHONY: buildx-imagetools-create 

test:
	cd ./tests && IMAGE=$(REPO):$(TAG) ./run.sh

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
	-IMAGE=$(REPO):$(TAG) docker compose -f tests/compose.yml down -v

release: build push
