# Change at least these lines:
##############################
ORG ?= pcdshub
REPO ?= typhos
BRANCH ?= master
IMPORT_NAME ?= $(REPO)
PIP_EXTRAS ?= PyQt5 pip happi .
##############################

DOCKER_BUILDKIT ?= 1
IMAGE_NAME ?= $(ORG)-$(REPO)-$(BRANCH)
IMAGE_VERSION ?= latest
IMAGE ?= $(IMAGE_NAME):$(IMAGE_VERSION)
RUN_ARGS ?= ./test.sh
INSPECT_ARGS ?= /bin/bash --login
PIP_CACHE ?= $(PWD)/pip_cache
EXTRA_RUN_ARGS ?= -v $(PIP_CACHE):/home/travis/.cache/pip

all: run-test

build-image: Dockerfile
	mkdir -p $(PIP_CACHE)
	DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) && \
				docker build --tag $(IMAGE) --file Dockerfile --progress=plain \
				--build-arg ORG=$(ORG) \
				--build-arg REPO=$(REPO) \
				--build-arg BRANCH=$(BRANCH) \
				--build-arg PIP_EXTRAS="$(PIP_EXTRAS)" \
				.

run-test: build-image
	docker run --rm -it $(EXTRA_RUN_ARGS) $(IMAGE) "$(RUN_ARGS)"

inspect: build-image
	docker run --rm -it $(EXTRA_RUN_ARGS) $(IMAGE) "$(INSPECT_ARGS)"

.PHONY: all build-image run-test inspect
