#!/bin/bash

BASE_PATH="$(pwd)"
library=$1
cd src/*/cargokit/build_tool/bin || { echo "Failed to change directory"; exit 1; }

export IPHONEOS_DEPLOYMENT_TARGET=10.0
exec env \
  CARGOKIT_ROOT_PROJECT_DIR="$BASE_PATH/src/$library" \
  CARGOKIT_DARWIN_ARCHS="x86_64" \
  CARGOKIT_CONFIGURATION="release" \
  CARGOKIT_TARGET_TEMP_DIR="$BASE_PATH/lib/macos/x86_64-apple-ios" \
  CARGOKIT_DARWIN_PLATFORM_NAME="iphonesimulator" \
  CARGOKIT_MANIFEST_DIR="$BASE_PATH/src/$library/rust" \
  CARGOKIT_OUTPUT_DIR="$BASE_PATH/release/ios/x86_64-apple-ios" \
  dart run build_tool build-pod

echo "Build completed"