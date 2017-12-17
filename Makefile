.PHONY: build

PROJECTNAME=nstapelbroek/static-webserver
TAGNAME=UNDEF

build:
	if [ "$(TAGNAME)" = "UNDEF" ]; then echo "please provide a valid TAGNAME" && exit 1; fi
	docker build --tag $(PROJECTNAME):$(TAGNAME) --pull .

run:
	docker run --rm --name static-webserver-test -p 8080:80 -e HOSTNAME=SOME-TEST-VARIABLE -d $(PROJECTNAME):$(TAGNAME)