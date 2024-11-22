#!/bin/bash
set -eo pipefail

version=${1:-0.7.15}
DEST_DIR=$PWD/tool/integration/cache/sodium
VERSION_FILE="$DEST_DIR/version.txt"
DART_FILE="$DEST_DIR/sodium.js.dart"

if [ "$CACHE_HIT" = "true" ]; then
  current_version=$(cat "$VERSION_FILE")
  if [[ "$version" == "$current_version" ]]; then
    exit 0
  else
    echo "::error::Cache version mismatch! Expected $version, but was $current_version"
    exit 1
  fi
fi

echo "::group::Download libsodium.js"
curl \
  -Lfo "$RUNNER_TEMP/libsodium.js.tar.gz" \
  "https://github.com/jedisct1/libsodium.js/archive/refs/tags/$version.tar.gz"
tar -xvf "$RUNNER_TEMP/libsodium.js.tar.gz" -C "$RUNNER_TEMP"

mkdir -p "$DEST_DIR"
echo 'const src = r"""' > "$DART_FILE"
cat "$RUNNER_TEMP/libsodium.js-$version/dist/browsers-sumo/sodium.js" >> "$DART_FILE"
echo '""";' >> "$DART_FILE"
echo "$version" > "$VERSION_FILE"
echo ::endgroup::

echo "::group::Start etesync server"
docker run -d --rm \
  --pull always \
  -e SUPER_USER=admin \
  -e AUTO_SIGNUP=true \
  -e 'ALLOWED_HOSTS=localhost,127.0.0.1,[::1]' \
  -p 127.0.0.1:3735:3735 \
  docker.io/victorrds/etesync
echo ::endgroup::
