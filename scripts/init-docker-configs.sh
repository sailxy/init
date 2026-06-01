#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
docker_dir="$repo_root/docker"
app_root="${APP_ROOT:-/opt/apps}"

copy_file() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

copy_dir_contents() {
  local src="$1"
  local dest="$2"

  mkdir -p "$dest"
  cp -R "$src"/. "$dest"/
}

mkdir -p "$app_root/mysql/conf.d"
mkdir -p "$app_root/nginx/log"

copy_dir_contents "$docker_dir/nginx/html" "$app_root/nginx/html"
copy_file "$docker_dir/nginx/nginx.conf" "$app_root/nginx/nginx.conf"
copy_file "$docker_dir/nginx/conf.d/default.conf" "$app_root/nginx/conf.d/default.conf"
copy_file "$docker_dir/loki/loki-config.yaml" "$app_root/loki/loki-config.yaml"
copy_file "$docker_dir/alloy/config.alloy" "$app_root/alloy/config.alloy"
copy_file "$docker_dir/grafana/provisioning/datasources/loki.yaml" "$app_root/grafana/provisioning/datasources/loki.yaml"

echo "Docker config files are ready under $app_root"
