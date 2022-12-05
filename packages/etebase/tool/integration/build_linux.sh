#!/bin/bash
#$1 libetebase version
set -ex

TAG=${1:-master}
PREFIX=/tool/integration/libetebase
DESTDIR=$PWD

# build and install libetebase
libetebaseDir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "$TAG" "$libetebaseDir"
cd "$libetebaseDir"
make PREFIX=$PREFIX
make install PREFIX=$PREFIX DESTDIR="$DESTDIR"
