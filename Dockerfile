FROM nginx:stable-alpine

RUN apk -U upgrade --no-cache && apk add -U --no-cache curl grep \
    && curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz \
    | tar xvzf - -C / \
    && rm -rf /var/www/localhost

COPY files/ /

ENTRYPOINT ["/init"]

EXPOSE 80

HEALTHCHECK --interval=5s --timeout=5s CMD curl -f http://127.0.0.1/ || exit 1
