#!/bin/bash

# A stripped down copy of https://github.com/nginxinc/docker-nginx/blob/master/entrypoint/20-envsubst-on-templates.sh

set -e

ME=$(basename "$0")

www_envsubst() {
  local www_dir="${NGINX_ENVSUBST_WWW_DIR:-/var/www/}"

  [ -d "$www_dir" ] || return 0
  if [ ! -w "$www_dir" ]; then
    echo >&3 "$ME: ERROR: $www_dir is not writable"
    return 0
  fi

  grep --recursive --no-messages --files-with-matches "\${" "$www_dir" | while read -r file; do
    envsubst < "$file" > "$file.new" && cp --attributes-only --preserve "$file" "$file.new" && mv "$file.new" "$file"
  done
}

www_envsubst

exit 0
