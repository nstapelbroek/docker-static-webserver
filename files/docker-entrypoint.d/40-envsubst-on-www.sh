#!/bin/bash

# A stripped down copy of https://github.com/nginxinc/docker-nginx/blob/master/entrypoint/20-envsubst-on-templates.sh

set -e

ME=$(basename "$0")

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

www_envsubst() {
  local www_dir filter defined_envs
  www_dir="${NGINX_ENVSUBST_WWW_DIR:-/var/www/}"
  filter="${NGINX_ENVSUBST_FILTER:-}"
  defined_envs=$(printf '${%s} ' $(awk "END { for (name in ENVIRON) { print ( name ~ /${filter}/ ) ? name : \"\" } }" < /dev/null ))

  if [ -n "$filter" ]; then
    entrypoint_log "$ME: envsubst filter is set to: $filter"
  fi

  [ -d "$www_dir" ] || return 0
  if [ ! -w "$www_dir" ]; then
    echo >&3 "$ME: ERROR: $www_dir is not writable"
    return 0
  fi

  grep --recursive --no-messages --files-with-matches "\${" "$www_dir" | while read -r file; do
    if [ -n "$filter" ]; then
      entrypoint_log "$ME: Running envsubst with filter on $file"
    else
      entrypoint_log "$ME: Running envsubst on $file"
    fi

    envsubst "$defined_envs" < "$file" > "$file.new" && cp --attributes-only --preserve "$file" "$file.new" && mv "$file.new" "$file"
  done
}

www_envsubst

exit 0
