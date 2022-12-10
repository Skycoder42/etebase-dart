#!/bin/bash
#$1 libetebase version
set -ex

function startServer {
  docker run -d --rm \
    --pull always \
    -e SUPER_USER=admin \
    -e AUTO_SIGNUP=true \
    -p 127.0.0.1:3735:3735 \
    victorrds/etesync
}

if [ "$CACHE_HIT" = "true" ]; then
  startServer
  exit 0
fi

TAG=${1:-master}
PREFIX=/tool/integration/libetebase
DESTDIR=$PWD

# build and install libetebase
libetebaseDir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "$TAG" "$libetebaseDir"
cd "$libetebaseDir"
make PREFIX=$PREFIX
make install PREFIX=$PREFIX DESTDIR="$DESTDIR"

# start docker server
startServer
