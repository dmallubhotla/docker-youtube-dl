#!/usr/bin/env bash
set -Eeuxo pipefail

docker login "$REGISTRY_URL" -u "$GITHUB_PACKAGES_USR" -p "$GITHUB_PACKAGES_PSW"

docker push "$REGISTRY_URL$IMAGE_BASE"