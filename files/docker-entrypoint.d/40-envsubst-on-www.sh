#!/bin/sh

# A stripped down copy paste of https://github.com/nginxinc/docker-nginx/blob/master/entrypoint/20-envsubst-on-templates.sh

set -e

ME=$(basename $0)

www_envsubst() {
  local www_dir="${NGINX_ENVSUBST_WWW_DIR:-/var/www/}"
  local template defined_envs

  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
  
  [ -d "$www_dir" ] || return 0
  if [ ! -w "$www_dir" ]; then
    echo >&3 "$ME: ERROR: $www_dir is not writable"
    return 0
  fi

  find "$www_dir" -follow -type f -print | while read -r file; do
    tmpfile=$(mktemp)
    cp --attributes-only --preserve "$file" "$tmpfile"
    envsubst "$defined_envs" < "$file" > "$tmpfile" && mv "$tmpfile" "$file"
  done
}

www_envsubst

exit 0