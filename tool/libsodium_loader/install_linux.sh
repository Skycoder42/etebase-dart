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
