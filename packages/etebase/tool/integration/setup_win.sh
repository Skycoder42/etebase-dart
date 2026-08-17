#!/bin/bash
set -eo pipefail

echo "::group::Restoring js_client"
pushd tool/js_client
npm install
popd
echo ::endgroup::
