#!/bin/bash
#$1 libetebase version
set -ex

version=${1:?First argument must be the libetebase version to build}
cache_dir=${CACHE_DIR:-$GITHUB_WORKSPACE/.cache}

if [ "$CACHE_HIT" = "true" ]; then
  sudo rsync -av "$cache_dir/" /
  exit 0
fi

# build and install libetebase
build_dir="$RUNNER_TEMP/libetebase"
git clone https://github.com/etesync/libetebase.git -b "v$version" "$build_dir"
cd "$build_dir"
make
make install DESTDIR="$cache_dir"

pushd "$cache_dir/usr/lib"
segments=( ${version//./ } )
major=${segments[0]}
minor=${segments[1]}
mv libetebase.so "libetebase.so.$version"
ln -s "libetebase.so.$version" "libetebase.so.$major.$minor"
ln -s "libetebase.so.$version" "libetebase.so.$major"
ln -s "libetebase.so.$version" libetebase.so
popd

sudo rsync -av "$cache_dir/" /
