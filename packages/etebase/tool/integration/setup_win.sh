#!/bin/bash
# $1=libsodium version
# $2=msvc version
set -eo pipefail

version=${1:-1.0.20}
msvc_version=${2:-143}
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
# scoop install minisign

# Workaround for https://github.com/ScoopInstaller/Main/pull/6461
curl -sSLo "$RUNNER_TEMP/minisign.zip" 'https://github.com/jedisct1/minisign/releases/download/0.12/minisign-0.12-win64.zip'
unzip "$RUNNER_TEMP/minisign.zip" -d "$RUNNER_TOOL_CACHE"
echo ::endgroup::

echo "::group::Install libsodium"
curl \
  -fo "$RUNNER_TEMP/libsodium.zip" \
  "https://download.libsodium.org/libsodium/releases/libsodium-$version-stable-msvc.zip"
curl \
  -fo "$RUNNER_TEMP/libsodium.zip.minisig " \
  "https://download.libsodium.org/libsodium/releases/libsodium-$version-stable-msvc.zip.minisig"

"$RUNNER_TOOL_CACHE/minisign-win64/x86_64/minisign" \
  -VP RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3 \
  -m "$RUNNER_TEMP/libsodium.zip"
7z x -y "-o$RUNNER_TEMP" "$RUNNER_TEMP/libsodium.zip"

mkdir -p "$DEST_DIR"
mv "$RUNNER_TEMP/libsodium/x64/Release/v$msvc_version/dynamic/libsodium.dll" "$DEST_DIR/libsodium.dll"
echo "$version" > "$VERSION_FILE"
echo ::endgroup::
