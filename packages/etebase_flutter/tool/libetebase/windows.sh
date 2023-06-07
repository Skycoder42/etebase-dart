#!/bin/bash
#$1 libetebase version
set -ex

version=${1:?First argument must be the libetebase version to build}
cache_dir=${CACHE_DIR:-$GITHUB_WORKSPACE/.cache}

lib_dir="$PWD/windows/lib"

if [ "$CACHE_HIT" = "true" ]; then
  mkdir -p "$lib_dir"
  cp -a "$cache_dir/etebase.dll" "$lib_dir/"
  exit 0
fi

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "v$version" "$build_dir"
pushd "$build_dir"
rm Cargo.lock

cargo build --release

mkdir -p "$cache_dir"
mv target/release/etebase.dll "$cache_dir/"

mkdir -p "$lib_dir"
cp -a "$cache_dir/etebase.dll" "$lib_dir/"
