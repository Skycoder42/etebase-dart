#!/bin/bash
#$1 libetebase version
set -ex

version=${1:?First argument must be the libetebase version to build}

patch_file=$GITHUB_WORKSPACE/packages/etebase/tool/integration/libetebase-macos.patch
lib_dir="$PWD/macos/Libraries"
cache_dir="$RUNNER_TEMP/cache"

if [ "$CACHE_HIT" = "true" ]; then
  mkdir -p "$lib_dir"
  rsync -av "$cache_dir/" "$lib_dir/"
  exit 0
fi

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "v$version" "$build_dir"
pushd "$build_dir"
git apply "$patch_file"

export MACOSX_DEPLOYMENT_TARGET=10.11
cargo build --release

mkdir -p "$cache_dir"
mv target/release/libetebase.so "$cache_dir/"
install_name_tool -id @rpath/libetebase.dylib "$cache_dir/libetebase.dylib"

mkdir -p "$lib_dir"
rsync -av "$cache_dir/" "$lib_dir/"
