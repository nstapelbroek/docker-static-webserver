.PHONY: build

PROJECTNAME=nstapelbroek/static-webserver
TAGNAME=UNDEF

build:
	if [ "$(TAGNAME)" = "UNDEF" ]; then echo "please provide a valid TAGNAME" && exit 1; fi
	docker buildx build --push --pull --platform linux/arm64/v8,linux/amd64 --tag $(PROJECTNAME):$(TAGNAME) .

test:
	docker pull $(PROJECTNAME):$(TAGNAME)
	dgoss run $(PROJECTNAME):$(TAGNAME)
