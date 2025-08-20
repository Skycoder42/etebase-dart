#!/bin/bash
set -eo pipefail

# install libsodium
echo "::group::Install libsodium"
brew install libsodium
echo ::endgroup::
