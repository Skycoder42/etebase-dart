#!/bin/bash
set -ex

PREFIX=/tool/integration/libetebase
DESTDIR=$PWD

# build and install libetebase
libetebaseDir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b v0.5.3 "$libetebaseDir"
cd "$libetebaseDir"
make PREFIX=$PREFIX
make install PREFIX=$PREFIX DESTDIR="$DESTDIR"
