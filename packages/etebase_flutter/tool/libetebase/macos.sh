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

export MACOSX_DEPLOYMENT_TARGET=10.11

# if [ "$CACHE_HIT" = "true" ]; then
#   mkdir -p "$lib_dir"
#   cp -a "$cache_dylib" "$lib_dir/"
#   ls -lsa "$lib_dir"
#   exit 0
# fi

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "v$version" "$build_dir"
pushd "$build_dir"
git apply "$patch_file"

make PREFIX=/
make install DESTDIR="$cache_dir" PREFIX=/
sha256sum "$cache_dylib"

popd
rm -rf "$build_dir"

mkdir -p "$lib_dir"
cp -a "$cache_dylib" "$lib_dir/"
ls -lsa "$lib_dir"
