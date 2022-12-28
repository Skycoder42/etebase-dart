#!/bin/bash
#$1 libetebase version
#$2 install dir: $PWD
#$3 host architecture: linux-x86_64
#$4 NDK version: 22.1.7171670
set -ex

version=${1:?First argument must be the libetebase version to build}
install_dir=${2:-$PWD}
host_arch=${3:-linux-x86_64}
ndk_version=${4:-22.1.7171670}
jni_dir="$install_dir/android/src/main/jniLibs"
cache_dir="$install_dir/tool/libetebase/lib"

if [ "$CACHE_HIT" = "true" ]; then
  cp -a "$cache_dir" "$jni_dir"
  exit 0
fi

armv7="armeabi-v7a armv7-linux-androideabi armv7a-linux-androideabi19-clang armv7a-linux-androideabi19-clang++"
aarch64="arm64-v8a aarch64-linux-android aarch64-linux-android21-clang aarch64-linux-android21-clang++"
x86="x86 i686-linux-android i686-linux-android19-clang i686-linux-android19-clang++"
x86_64="x86_64 x86_64-linux-android x86_64-linux-android21-clang x86_64-linux-android21-clang"
arches=( "$aarch64" "$x86_64" "$armv7" "$x86" )

build_dir=$RUNNER_TEMP/libetebase
git clone https://github.com/etesync/libetebase -b "$version" "$build_dir"
cd "$build_dir"

openssl_version=$(cat Cargo.lock | grep 'name = "openssl"' -A 3 | grep "version" | cut -d '"' -f 2)
echo "openssl = { version = \"$openssl_version\", features = [\"vendored\"] }" >> Cargo.toml

export PATH="$ANDROID_HOME/ndk/$ndk_version/toolchains/llvm/prebuilt/$host_arch/bin/:$PATH"
for arch in "${arches[@]}"; do
  cargo clean

  arch=($arch)
  jni_lib_arch=${arch[0]}
  target=${arch[1]}
  export CC=${arch[2]}
  export CXX=${arch[3]}

  rustup target add "$target"

  cargo build \
    --config "target.$target.linker=\"$install_dir/android/my-hacky-linker-cc\"" \
    --target "$target" \
    --release

  jni_arch_dir="$jni_dir/$jni_lib_arch"
  mkdir -p "$jni_arch_dir"
  cp -a "target/$target/release/libetebase.so" "$jni_arch_dir"
done

cp -a "$jni_dir" "$cache_dir"
