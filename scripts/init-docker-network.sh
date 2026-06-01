#!/usr/bin/env bash
set -euo pipefail

network_name="infra-network"

if docker network inspect "$network_name" >/dev/null 2>&1; then
  echo "Docker network already exists: $network_name"
  exit 0
fi

docker network create -d bridge "$network_name"
