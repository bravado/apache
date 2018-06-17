.PHONY: build push build-mailout push-mailout

default: build

init:
	$(eval GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD))

build: init
	docker build -t bravado/apache:${GIT_BRANCH} .

test: build
	bash test.sh ${GIT_BRANCH}

bash:
	docker run -it --rm --entrypoint bash bravado/apache:${GIT_BRANCH}
