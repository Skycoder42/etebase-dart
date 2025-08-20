#!/bin/bash
set -eo pipefail

version=${1:-0.7.15}
DART_FILE=${GITHUB_WORKSPACE:-$PWD}/tool/libsodium_loader/sodium.js
TMP_DIR=${RUNNER_TEMP:-$(mktemp -d)}

echo "::group::Download libsodium.js"
curl \
  -Lfo "$TMP_DIR/libsodium.js.tar.gz" \
  "https://github.com/jedisct1/libsodium.js/archive/refs/tags/$version.tar.gz"
tar -xvf "$TMP_DIR/libsodium.js.tar.gz" -C "$TMP_DIR"
mv "$TMP_DIR/libsodium.js-$version/dist/browsers-sumo/sodium.js" "$DART_FILE"
echo ::endgroup::
