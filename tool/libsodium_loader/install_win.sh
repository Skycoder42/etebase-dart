#!/bin/bash
# $1=libsodium version
# $2=msvc version
set -eo pipefail

version=${1:-1.0.20}
msvc_version=${2:-143}
DEST_FILE=${GITHUB_WORKSPACE:-$PWD}/tool/libsodium_loader/libsodium.dll
TMP_DIR=${RUNNER_TEMP:-$(mktemp -d)}
MINISIGN_KEY=RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3

echo "::group::Install minisign"
scoop install minisign
echo ::endgroup::

echo "::group::Install libsodium"
curl \
  -fo "$TMP_DIR/libsodium.zip" \
  "https://download.libsodium.org/libsodium/releases/libsodium-$version-stable-msvc.zip"
curl \
  -fo "$TMP_DIR/libsodium.zip.minisig " \
  "https://download.libsodium.org/libsodium/releases/libsodium-$version-stable-msvc.zip.minisig"

minisign \
  -VP "$MINISIGN_KEY" \
  -m "$TMP_DIR/libsodium.zip"
7z x -y "-o$TMP_DIR" "$TMP_DIR/libsodium.zip"

mv "$TMP_DIR/libsodium/x64/Release/v$msvc_version/dynamic/libsodium.dll" "$DEST_FILE"
echo ::endgroup::
