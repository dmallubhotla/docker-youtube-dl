#!/usr/bin/env bash
set -Eeuxo pipefail

docker login "$REGISTRY_URL" -u '$REGISTRY_USER' -p '$REGISTRY_PW'

docker push "$REGISTRY_URL$IMAGE_BASE"