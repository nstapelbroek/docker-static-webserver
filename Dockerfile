FROM alpine:3.7

RUN apk -U upgrade && apk add --no-cache curl grep nginx \
 && curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz \
  | tar xvzf - -C / \
 && rm -rf /var/cache/apk/*

COPY files/ /

ENTRYPOINT ["/init"]

HEALTHCHECK --interval=5s --timeout=5s CMD curl -f http://127.0.0.1/ || exit 1
