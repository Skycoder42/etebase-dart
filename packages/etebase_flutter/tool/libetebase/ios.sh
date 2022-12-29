#!/bin/bash
#$1 libetebase version
#$2 install dir: $PWD
set -ex

version=${1:?First argument must be the libetebase version to build}
install_dir=${2:-$PWD}
cache_dir="$install_dir/tool/libetebase/lib"
cache_lib="$cache_dir/libetebase.dylib"
lib_dir="$install_dir/ios/Libraries"
patch_file=$PWD/../etebase/tool/integration/libetebase-macos.patch

if [ "$CACHE_HIT" = "true" ]; then
  mkdir -p "$lib_dir"
  cp -a "$cache_lib" "$lib_dir/"
  exit 0
fi

rustup target add aarch64-apple-ios x86_64-apple-ios

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "v$version" "$build_dir"
pushd "$build_dir"
git apply "$patch_file"

export IPHONEOS_DEPLOYMENT_TARGET=9.0
cargo build --target aarch64-apple-ios --release
cargo build --target x86_64-apple-ios --release

universal_lib=target/libetebase.dylib
lipo -create \
  target/aarch64-apple-ios/release/libetebase.dylib \
  target/x86_64-apple-ios/release/libetebase.dylib \
  -output $universal_lib

mkdir -p "$cache_dir"
cp -a $universal_lib "$cache_lib"
otool -L "$cache_lib"

popd
rm -rf "$build_dir"

mkdir -p "$lib_dir"
cp -a "$cache_lib" "$lib_dir/"
otool -L "$lib_dir/libetebase.dylib"
