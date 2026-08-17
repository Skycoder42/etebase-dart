#!/bin/bash
# $1=libsodium version
# $2=msvc version
set -eo pipefail

version=${1:-1.0.20}
DEST_DIR=$PWD/tool/integration/cache/sodium
VERSION_FILE="$DEST_DIR/version.txt"

echo "::group::Restoring js_client"
pushd tool/js_client
npm install
popd
echo ::endgroup::

if [ "$CACHE_HIT" = "true" ]; then
  current_version=$(cat "$VERSION_FILE")
  if [[ "$version" == "$current_version" ]]; then
    exit 0
  else
    echo "::error::Cache version mismatch! Expected $version, but was $current_version"
    exit 1
  fi
fi
