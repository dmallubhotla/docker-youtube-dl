#!/usr/bin/env bash
set -Eeuxo pipefail

docker push "$REGISTRY_URL$IMAGE_BASE"
