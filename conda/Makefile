# Change at least these lines:
##############################
ORG ?= pcdshub
REPO ?= typhos
BRANCH ?= master
IMPORT_NAME ?= $(REPO)
CONDA_EXTRAS ?= pip pyqt=5 happi pcdsdevices
PYTHON_VERSION ?= 3.9
##############################

DOCKER_BUILDKIT ?= 1
IMAGE_NAME ?= $(ORG)-$(REPO)-$(BRANCH)
IMAGE_VERSION ?= latest
IMAGE ?= $(IMAGE_NAME):$(IMAGE_VERSION)
RUN_ARGS ?= ./test.sh
INSPECT_ARGS ?= /bin/bash --login
EXTRA_RUN_ARGS ?= 

all: run-test

build-image: Dockerfile
	DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) && \
				docker build --tag $(IMAGE) --file Dockerfile --progress=plain \
				--build-arg ORG=$(ORG) \
				--build-arg REPO=$(REPO) \
				--build-arg BRANCH=$(BRANCH) \
				--build-arg CONDA_EXTRAS="$(CONDA_EXTRAS)" \
				--build-arg PYTHON_VERSION="$(PYTHON_VERSION)" \
				.

run-test: build-image
	docker run --rm -it $(EXTRA_RUN_ARGS) $(IMAGE) "$(RUN_ARGS)"

inspect: build-image
	docker run --rm -it $(EXTRA_RUN_ARGS) $(IMAGE) "$(INSPECT_ARGS)"

.PHONY: all build-image run-test inspect
