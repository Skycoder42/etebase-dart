#!/bin/bash
#$1 libetebase version
#$2 artifact-dir
set -ex

version=${1:?First argument must be the libetebase version to build}
artifact_dir=${2:?Second argument must be the artifact directory}

platforms=(android ios macos windows)

export CACHE_HIT=true
for platform in "${platforms[@]}"; do
  export CACHE_DIR="$artifact_dir/libetebase-$platform-$version"
  "$PWD/tool/libetebase/$platform.sh" "$version" "$@"
done
