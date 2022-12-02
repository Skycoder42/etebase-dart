#!/bin/bash
# $1: patch file
set -ex

PATCH_FILE=$1
PREFIX=/tool/integration/libetebase
DESTDIR=$PWD

# build and install libetebase
libetebaseDir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b v0.5.3 "$libetebaseDir"
cd "$libetebaseDir"

if [ -n "$PATCH_FILE" ]; then
  git apply "$GITHUB_WORKSPACE/$PATCH_FILE"
fi

make PREFIX=$PREFIX
make install PREFIX=$PREFIX DESTDIR="$DESTDIR"
