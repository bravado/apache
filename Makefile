.PHONY: build push build-mailout push-mailout

default: build

build:
	docker build -t bravado/apache:php7 .

test: build
	bash test.sh

bash: build
	docker run -it --rm --entrypoint bash bravado/apache:php7
