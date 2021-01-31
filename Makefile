GIT_COMMIT       := $$(git rev-parse HEAD)
GIT_COMMIT_SHORT := $$(git rev-parse --short HEAD)
# GIT_TAG          := $$(git describe --exact-match)

REPOSITORY       ?= panta/gmvault
IMAGE            := $(REPOSITORY):latest

OK_COLOR=\033[32;01m
NO_COLOR=\033[0m

.PHONY: all
all: build push

.PHONY: build
build:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Building $(IMAGE)"
	@docker build --rm -t $(IMAGE) .

.PHONY: push
push:
	@echo "$(OK_COLOR)==>$(NO_COLOR) Pushing $(IMAGE)"
	@docker push $(REPOSITORY)
