#!/bin/bash
# $1=libsodium version
set -eo pipefail

version=${1:-1.0.20}
DEST_DIR=$PWD/tool/integration/cache/sodium
VERSION_FILE="$DEST_DIR/version.txt"

if [ "$CACHE_HIT" = "true" ]; then
  current_version=$(cat "$VERSION_FILE")
  if [[ "$version" == "$current_version" ]]; then
    exit 0
  else
    echo "::error::Cache version mismatch! Expected $version, but was $current_version"
    exit 1
  fi
fi

echo "::group::Install minisign"
scoop install minisign
echo ::endgroup::

echo "::group::Install libsodium"
curl \
  -fo "$RUNNER_TEMP/libsodium.zip" \
  "https://download.libsodium.org/libsodium/releases/libsodium-$version-stable-msvc.zip"
curl \
  -fo "$RUNNER_TEMP/libsodium.zip.minisig " \
  "https://download.libsodium.org/libsodium/releases/libsodium-$version-stable-msvc.zip.minisig"

minisign \
  -VP RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3 \
  -m "$RUNNER_TEMP/libsodium.zip"

mkdir -p "$(dirname "$SERVER_DIR")"
7z x -y "-o$DEST_DIR" "$RUNNER_TEMP/libsodium.zip"
echo "$version" > "$VERSION_FILE"
echo ::endgroup::
