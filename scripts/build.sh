#!/usr/bin/env bash
set -Eeuxo pipefail

full=`cat .version | tr -d [:space:]`

major="${full%%.*}"
minor="${full#$major.}"
minor="${minor%%.*}"
mm="$major.$minor"

echo "tags to deploy:"
echo "$major"
echo "$mm"
echo "$full"
echo "latest"

docker build \
  -t "$REGISTRY_URL$IMAGE_BASE:$full" \
  -t "$REGISTRY_URL$IMAGE_BASE:$mm" \
  -t "$REGISTRY_URL$IMAGE_BASE:$major" \
  -t "$REGISTRY_URL$IMAGE_BASE:latest" \
  .