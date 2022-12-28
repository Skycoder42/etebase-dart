#!/bin/bash
#$1 libetebase version
#$2 install dir: $PWD
set -ex

version=${1:?First argument must be the libetebase version to build}
install_dir=${2:-$PWD}
cache_dir="$install_dir/tool/libetebase/lib"
cache_framework="$cache_dir/libetebase.xcframework"
lib_dir="$install_dir/ios/Libraries"
patch_file=$PWD/../etebase/tool/integration/libetebase-macos.patch

if [ "$CACHE_HIT" = "true" ]; then
  mkdir -p "$lib_dir"
  cp -a "$cache_framework" "$lib_dir/"
  exit 0
fi

rustup target add aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "v$version" "$build_dir"
cd "$build_dir"
git apply "$patch_file"

export IPHONEOS_DEPLOYMENT_TARGET=9.0
cargo build --target aarch64-apple-ios --release
cargo build --target x86_64-apple-ios --release
cargo build --target aarch64-apple-ios-sim --release

universal_dir=target/universal-ios/release/
universal_lib=$universal_dir/libetebase.dylib
universal_framework=$universal_dir/libetebase.xcframework
mkdir -p $universal_dir
mkdir -p $universal_dir/headers
cp -a target/etebase.h $universal_dir/headers/

lipo -create \
  target/aarch64-apple-ios/release/libetebase.dylib \
  target/x86_64-apple-ios/release/libetebase.dylib \
  -output $universal_lib

xcodebuild -create-xcframework \
  -library $universal_lib -headers $universal_dir/headers/ \
  -library target/aarch64-apple-ios-sim/release/libetebase.dylib -headers $universal_dir/headers/ \
  -output $universal_framework

mkdir -p "$cache_dir"
cp -a $universal_framework "$cache_framework"

mkdir -p "$lib_dir"
cp -a "$cache_framework" "$lib_dir/"
