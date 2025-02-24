#!/bin/bash

BASE_PATH="$(pwd)"
library=$1
VERSION=${2:-"latest"}
cd src/*/cargokit/build_tool/bin

export CARGOKIT_ROOT_PROJECT_DIR="$BASE_PATH/src/$library"
export CARGOKIT_DARWIN_ARCHS="arm64"
export CARGOKIT_CONFIGURATION="release"
export CARGOKIT_TARGET_TEMP_DIR="$BASE_PATH/lib/$library/$VERSION/macos/aarch64-apple-darwin"
export CARGOKIT_DARWIN_PLATFORM_NAME="macosx"
export CARGOKIT_MANIFEST_DIR="$BASE_PATH/src/$library/rust"
export CARGOKIT_OUTPUT_DIR="$BASE_PATH/release/$library/$VERSION/macos/aarch64-apple-darwin"

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