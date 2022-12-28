#!/bin/bash
#$1 libetebase version
#$2 install dir: $PWD
set -ex

version=${1:?First argument must be the libetebase version to build}
install_dir=${2:-$PWD}
cache_dir="$install_dir/tool/libetebase/lib"
cache_dylib="$cache_dir/libetebase.dylib"
lib_dir="$install_dir/ios/Libraries"
patch_file=$PWD/../etebase/tool/integration/libetebase-macos.patch

if [ "$CACHE_HIT" = "true" ]; then
  mkdir -p "$lib_dir"
  cp -a "$cache_dylib" "$lib_dir/"
  exit 0
fi

rustup target add aarch64-apple-ios x86_64-apple-ios

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "v$version" "$build_dir"
cd "$build_dir"
git apply "$patch_file"

cargo build --target aarch64-apple-ios --release
cargo build --target x86_64-apple-ios --release

universal_dir=target/universal-ios/release/
universal_lib=$universal_dir/libetebase.dylib
mkdir -p $universal_dir
lipo -create \
  target/aarch64-apple-ios/release/libetebase.dylib \
  target/x86_64-apple-ios/release/libetebase.dylib \
  -output $universal_lib

mkdir -p "$cache_dir"
cp -a $universal_lib "$cache_dylib"

mkdir -p "$lib_dir"
cp -a "$cache_dylib" "$lib_dir/"
