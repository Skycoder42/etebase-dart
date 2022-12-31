#!/bin/bash
#$1 libetebase version
#$2 host architecture: linux-x86_64
#$3 NDK version: 22.1.7171670
set -ex

version=${1:?First argument must be the libetebase version to build}
host_arch=${3:-linux-x86_64}
ndk_version=${4:-22.1.7171670}

android_dir="$PWD/android"
jni_dir="$android_dir/src/main/jniLibs"
cache_dir="$RUNNER_TEMP/cache"

if [ "$CACHE_HIT" = "true" ]; then
  mkdir -p "$jni_dir/"
  rsync -av "$cache_dir/" "$jni_dir/"
  exit 0
fi

armv7="armeabi-v7a armv7-linux-androideabi armv7a-linux-androideabi21-clang armv7a-linux-androideabi21-clang++"
aarch64="arm64-v8a aarch64-linux-android aarch64-linux-android21-clang aarch64-linux-android21-clang++"
x86="x86 i686-linux-android i686-linux-android21-clang i686-linux-android21-clang++"
x86_64="x86_64 x86_64-linux-android x86_64-linux-android21-clang x86_64-linux-android21-clang"
arches=( "$aarch64" "$x86_64" "$armv7" "$x86" )

"$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --install "ndk;$ndk_version"

build_dir=$RUNNER_TEMP/libetebase
git clone https://github.com/etesync/libetebase -b "v$version" "$build_dir"
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
    --config "target.$target.linker=\"$android_dir/my-hacky-linker-cc\"" \
    --target "$target" \
    --release

  jni_arch_dir="$cache_dir/$jni_lib_arch"
  mkdir -p "$jni_arch_dir"
  mv "target/$target/release/libetebase.so" "$jni_arch_dir/"
done

mkdir -p "$jni_dir/"
rsync -av "$cache_dir/" "$jni_dir/"
