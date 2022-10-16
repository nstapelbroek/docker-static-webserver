FROM --platform=$BUILDPLATFORM nginx:stable

COPY --chown=root:root files/docker-entrypoint.d /docker-entrypoint.d
COPY --chown=root:root files/etc /etc
COPY --chown=nginx:nginx files/var/www /var/www

HEALTHCHECK --interval=5s --timeout=2s CMD curl -f http://127.0.0.1/ || exit 1