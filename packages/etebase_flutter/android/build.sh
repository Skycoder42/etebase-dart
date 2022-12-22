#!/bin/bash
set -ex

version=${1:-v0.5.3}
install_dir=${2:-$PWD}

armv7="armeabi-v7a armv7-linux-androideabi armv7a-linux-androideabi19-clang"
aarch64="arm64-v8a aarch64-linux-android aarch64-linux-android21-clang"
x86="x86 i686-linux-android i686-linux-android19-clang"
x86_64="x86_64 x86_64-linux-android x86_64-linux-android21-clang"
arches=( "$aarch64" "$x86_64" "$armv7" "$x86" )

build_dir=$(mktemp -d)
pushd "$build_dir"

git clone https://github.com/etesync/libetebase -b "$version" .
echo 'openssl = { version = "0.10.38", features = ["vendored"] }' >> Cargo.toml

for arch in "${arches[@]}"; do
    arch=($arch)
    jniLibArch=${arch[0]}
    target=${arch[1]}
    ccompiler=${arch[2]}

    jniDir="$install_dir/src/main/jniLibs/$jniLibArch"

    export CC="$ccompiler"
    export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="$ccompiler"

    cargo build --target "$target" --release

    mkdir -p "$jniDir"
    cp "target/$target/release/libetebase.so" "$jniDir"
done

popd
rm -rf "$build_dir"
