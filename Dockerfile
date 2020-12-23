FROM nginx:stable-alpine

# System dependencies
RUN apk add -U --no-cache curl grep && rm -rf /var/www/localhost

# Dumb init s6
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /
ENTRYPOINT ["/init"]

COPY files/ /

# Quality of life
HEALTHCHECK --interval=5s --timeout=2s CMD curl -f http://127.0.0.1/ || exit 1
