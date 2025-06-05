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
pushd tool/integration
docker compose up -d
popd
echo ::endgroup::
