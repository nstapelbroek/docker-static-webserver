 FROM --platform=$BUILDPLATFORM nginx:stable

COPY files/ /

HEALTHCHECK --interval=5s --timeout=2s CMD curl -f http://127.0.0.1/ || exit 1
