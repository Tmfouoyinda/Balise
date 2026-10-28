#!/usr/bin/env bash
# One-time setup of the local Garage S3 (dev only): layout, access key, bucket.
# Safe to run again: each step is skipped when already done.
# Usage: ./scripts/garage-init.sh [bucket-name]
set -euo pipefail

BUCKET="${1:-balise-dev}"
KEY_NAME="balise-dev"

# Git Bash rewrites "/garage" into a Windows path without this
export MSYS_NO_PATHCONV=1

garage() {
  docker compose exec -T bucket /garage "$@"
}

if ! garage status >/dev/null 2>&1; then
  echo "The bucket service is not running: docker compose up -d bucket" >&2
  exit 1
fi

if garage status 2>/dev/null | grep -q "NO ROLE ASSIGNED"; then
  node_id="$(garage node id -q 2>/dev/null | cut -d@ -f1)"
  garage layout assign -z dc1 -c 1G "$node_id"
  garage layout apply --version 1
else
  echo "Layout already applied"
fi

if garage key info "$KEY_NAME" >/dev/null 2>&1; then
  echo "Key $KEY_NAME already exists (secret: garage key info --show-secret $KEY_NAME)"
else
  garage key create "$KEY_NAME"
  echo "Copy the Key ID and Secret key above into .env: S3_ACCESS_KEY_ID, S3_SECRET_ACCESS_KEY"
fi

if garage bucket info "$BUCKET" >/dev/null 2>&1; then
  echo "Bucket $BUCKET already exists"
else
  garage bucket create "$BUCKET"
fi

garage bucket allow --read --write --owner "$BUCKET" --key "$KEY_NAME"
