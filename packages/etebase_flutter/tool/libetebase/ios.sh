#!/bin/bash
#$1 libetebase version
set -ex

version=${1:?First argument must be the libetebase version to build}

patch_file=$GITHUB_WORKSPACE/packages/etebase/tool/integration/libetebase-macos.patch
lib_dir="$PWD/ios/Libraries"
cache_dir="$RUNNER_TEMP/cache"

if [ "$CACHE_HIT" = "true" ]; then
  mkdir -p "$lib_dir"
  rsync -av "$cache_dir/" "$lib_dir/"
  exit 0
fi

arches=(aarch64-apple-ios x86_64-apple-ios)

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "v$version" "$build_dir"
pushd "$build_dir"
git apply "$patch_file"

export IPHONEOS_DEPLOYMENT_TARGET=9.0
declare -a dylibs
for arch in "${arches[@]}"; do
  rustup target add "$arch"

  cargo build --target "$arch" --release

  dylibs+=("target/$arch/release/libetebase.dylib")
done

mkdir -p "$cache_dir"
universal_lib=$cache_dir/libetebase.dylib
lipo -create "${dylibs[@]}" -output "$universal_lib"
install_name_tool -id @rpath/libetebase.dylib "$universal_lib"

mkdir -p "$lib_dir"
rsync -av "$cache_dir/" "$lib_dir/"
