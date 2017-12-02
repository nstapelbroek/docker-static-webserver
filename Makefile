.PHONY: build

PROJECTNAME=nstapelbroek/static-webserver
TAGNAME=UNDEF

build:
	if [ "$(TAGNAME)" = "UNDEF" ]; then echo "please provide a valid TAGNAME" && exit 1; fi
	docker build --tag $(PROJECTNAME):$(TAGNAME) --pull .
