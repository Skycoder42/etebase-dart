#!/bin/bash
set -eo pipefail

echo "::group::Restoring js_client"
npm --prefix tool/js_client install
echo ::endgroup::

echo "::group::Start etesync server"
pushd tool/integration
podman compose up -d
popd
echo ::endgroup::
