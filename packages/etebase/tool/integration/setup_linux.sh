#!/bin/bash
set -eo pipefail

echo "::group::Installing libsodium"
sudo apt-get -y update
sudo apt-get -y install libsodium-dev
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
