#!/bin/bash
set -eo pipefail

echo "::group::Installing libsodium"
if pkgconf --exists libsodium; then
  echo "libsodium is already installed"
else
  sudo apt-get -y update
  sudo apt-get -y install libsodium-dev
fi
echo ::endgroup::

echo "::group::Restoring js_client"
npm --prefix tool/js_client install
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
