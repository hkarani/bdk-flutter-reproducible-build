#!/bin/bash

BASE_PATH="$(pwd)"
library=$1
VERSION=${2:-"latest"}
cd src/*/cargokit/build_tool/bin || { echo "Failed to change directory"; exit 1; }
export RUSTUP_TOOLCHAIN=1.75.0
export IPHONEOS_DEPLOYMENT_TARGET=10.0
env \
  CARGOKIT_ROOT_PROJECT_DIR="$BASE_PATH/src/$library" \
  CARGOKIT_DARWIN_ARCHS="x86_64" \
  CARGOKIT_CONFIGURATION="release" \
  CARGOKIT_TARGET_TEMP_DIR="$BASE_PATH/lib/$library/$VERSION/ios/x86_64-apple-ios" \
  CARGOKIT_DARWIN_PLATFORM_NAME="iphonesimulator" \
  CARGOKIT_MANIFEST_DIR="$BASE_PATH/src/$library/rust" \
  CARGOKIT_OUTPUT_DIR="$BASE_PATH/release/$library/$VERSION/ios/x86_64-apple-ios" \
  dart run build_tool build-pod


cd $BASE_PATH/src/$library/rust
package_name_line=$(grep -m 1 -E '^name = .*' Cargo.toml)

if [ ! -z "$package_name_line" ]; then
    package_name=$(echo "$package_name_line" | cut -d '=' -f2 | tr -d '[:space:]' | sed 's/^"//' | sed 's/"$//')
else
    echo "Error: Could not find 'name' in [package] section"
    exit 1
fi

echo "You package name is "$package_name

file=$(ls $BASE_PATH/release/$library/$VERSION/ios/aarch64-apple-ios/*.a | head -n 1)  # Get the first `.a` file
mv "$file" "$BASE_PATH/release/$library/$VERSION/ios/aarch64-apple-ios/aarch64-apple-ios_$package_name.a"
echo "Build completed"
