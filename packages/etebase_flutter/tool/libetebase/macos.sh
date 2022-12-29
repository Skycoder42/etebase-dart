#!/bin/bash
#$1 libetebase version
#$2 install dir: $PWD
set -ex

version=${1:?First argument must be the libetebase version to build}
install_dir=${2:-$PWD}
cache_dir="$install_dir/tool/libetebase/lib"
cache_dylib="$cache_dir/lib/libetebase.dylib"
lib_dir="$install_dir/macos/Libraries"
patch_file=$PWD/../etebase/tool/integration/libetebase-macos.patch

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "v$version" "$build_dir"
cd "$build_dir"
git apply "$patch_file"

export MACOSX_DEPLOYMENT_TARGET=10.11
make PREFIX=/
make install DESTDIR="$cache_dir" PREFIX=/

if [ "$CACHE_HIT" = "true" ]; then
  mkdir -p "$lib_dir"
  cp -a "$cache_dylib" "$lib_dir/"
  exit 0
fi

mkdir -p "$lib_dir"
cp -a "$cache_dylib" "$lib_dir/"
