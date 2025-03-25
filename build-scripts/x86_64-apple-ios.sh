#!/bin/bash

BASE_PATH="$(pwd)"
library=$1
VERSION=${2:-"latest"}

cd src/*/rust || { echo "Failed to change directory"; exit 1; }
export IPHONEOS_DEPLOYMENT_TARGET=10.0

package_name_line=$(grep -m 1 -E '^name = .*' Cargo.toml)

if [ ! -z "$package_name_line" ]; then
    package_name=$(echo "$package_name_line" | cut -d '=' -f2 | tr -d '[:space:]' | sed 's/^"//' | sed 's/"$//')
else
    echo "Error: Could not find 'name' in [package] section"
    exit 1
fi

cargo install cargo-lipo
rustup target add x86_64-apple-ios
cargo build --release --target x86_64-apple-ios


file=$(ls $BASE_PATH/src/*/rust/target/x86_64-apple-ios/release/*.a | head -n 1)  # Get the first `.a` file
mkdir -p "$BASE_PATH/release/$library/$VERSION/ios/x86_64-apple-ios"
mv "$file" "$BASE_PATH/release/$library/$VERSION/ios/x86_64-apple-ios/x86_64-apple-ios_lib$package_name.a"
echo "Build completed"