#!/bin/bash
#$1 libetebase version
set -e

function startServer {
  echo "::group::Start etesync server"
  docker run -d --rm \
    --pull always \
    -e SUPER_USER=admin \
    -e AUTO_SIGNUP=true \
    -p 127.0.0.1:3735:3735 \
    victorrds/etesync
  echo ::endgroup::
}

if [ "$CACHE_HIT" = "true" ]; then
  startServer
  exit 0
fi

# build and install libetebase
echo "::group::Build libetebase"
TAG=${1:-master}
PREFIX=/tool/integration/libetebase
DESTDIR=$PWD

libetebaseDir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "$TAG" "$libetebaseDir"
cd "$libetebaseDir"
rm Cargo.lock # delete lockfile to get up-to-date dependencies
make PREFIX=$PREFIX
make install PREFIX=$PREFIX DESTDIR="$DESTDIR"
echo ::endgroup::

# start docker server
startServer
