#!/bin/bash
set -eo pipefail

version=${1:-0.7.15}
DEST_DIR=$PWD/tool/integration/cache/sodium
VERSION_FILE="$DEST_DIR/version.txt"
DART_FILE="$DEST_DIR/sodium.js.dart"
TMP_DIR=${RUNNER_TEMP:-/tmp}

echo "::group::Restoring js_client"
npm --prefix tool/js_client install
npm --prefix tool/js_client run build
echo ::endgroup::

if [ "$CACHE_HIT" = "true" ]; then
  current_version=$(cat "$VERSION_FILE")
  if [[ "$version" != "$current_version" ]]; then
    echo "::error::Cache version mismatch! Expected $version, but was $current_version"
    exit 1
  fi
else
  echo "::group::Download libsodium.js"
  curl \
    -Lfo "$TMP_DIR/libsodium.js.tar.gz" \
    "https://github.com/jedisct1/libsodium.js/archive/refs/tags/$version.tar.gz"
  tar -xvf "$TMP_DIR/libsodium.js.tar.gz" -C "$TMP_DIR"

  mkdir -p "$DEST_DIR"
  echo 'const src = r"""' > "$DART_FILE"
  cat "$TMP_DIR/libsodium.js-$version/dist/browsers-sumo/sodium.js" >> "$DART_FILE"
  echo '""";' >> "$DART_FILE"
  echo "$version" > "$VERSION_FILE"
  echo ::endgroup::
fi

echo "::group::Start etesync server"
pushd tool/integration
docker compose up -d
popd
echo ::endgroup::
