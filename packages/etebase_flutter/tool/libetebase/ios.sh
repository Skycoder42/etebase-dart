#!/bin/bash
#$1 libetebase version
#$2 install dir: $PWD
set -ex

version=${1:?First argument must be the libetebase version to build}
install_dir=${2:-$PWD}
cache_dir="$install_dir/tool/libetebase/lib"
cache_dylib="$cache_dir/lib/libetebase.a"
lib_dir="$install_dir/ios/Libraries"
patch_file=$PWD/../etebase/tool/integration/libetebase-macos.patch

if [ "$CACHE_HIT" = "true" ]; then
  cp -a "$cache_dylib" "$lib_dir/"
  exit 0
fi

rustup target add aarch64-apple-ios x86_64-apple-ios
cargo install cargo-lipo

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "$version" "$build_dir"
cd "$build_dir"
git apply "$patch_file"
cargo lipo --release
cp -a "$cache_dylib" "$lib_dir/"
