#!/bin/bash

BASE_PATH="$(pwd)"
cd src/*/cargokit/build_tool/bin || { echo "Failed to change directory"; exit 1; }

export IPHONEOS_DEPLOYMENT_TARGET=10.0
exec env \
  CARGOKIT_ROOT_PROJECT_DIR="$BASE_PATH/src/lwk-dart" \
  CARGOKIT_DARWIN_ARCHS="arm64" \
  CARGOKIT_CONFIGURATION="release" \
  CARGOKIT_TARGET_TEMP_DIR="$BASE_PATH/lib/macos/aarch64-apple-ios" \
  CARGOKIT_DARWIN_PLATFORM_NAME="iphoneos" \
  CARGOKIT_MANIFEST_DIR="$BASE_PATH/src/lwk-dart/rust" \
  CARGOKIT_OUTPUT_DIR="$BASE_PATH/release/ios/aarch64-apple-ios" \
  dart run build_tool build-pod

echo "Build completed"