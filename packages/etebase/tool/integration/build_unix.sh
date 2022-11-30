#!/bin/bash
set -ex

# setup rust
curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="$PATH:$HOME/.cargo/bin"

# build and install libetebase
libetebaseDir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b v0.5.3 "$libetebaseDir"
cd "$libetebaseDir"
make
sudo make install
