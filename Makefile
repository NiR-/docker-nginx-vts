.DEFAULT_GOAL := all

.PHONY: all
all: build push

.PHONY: build
build:
ifeq ($(VERSION),)
	@echo "You have to provide a VERSION to build this image.\n"
	@exit 1
endif
	docker build -t docker.io/akerouanton/nginx-vts:$(VERSION) .

.PHONY: push
push:
ifeq ($(VERSION),)
	@echo "You have to provide a VERSION to build this image.\n"
	@exit 1
endif
	docker push docker.io/akerouanton/nginx-vts:$(VERSION)
