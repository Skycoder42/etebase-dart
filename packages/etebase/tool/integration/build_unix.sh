#!/bin/bash
set -ex

curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="$PATH:$HOME/.cargo/bin"

buildDir=$(mktemp -d)
pushd "$buildDir"
git clone https://github.com/etesync/libetebase.git -b v0.5.3 .
make
sudo make install
popd

rm -rf "$buildDir"
