#!/bin/bash

BASE_PATH="$(pwd)"
cd src/*/cargokit/build_tool/bin



export CARGOKIT_ROOT_PROJECT_DIR="$BASE_PATH/src/lwk-dart"
export CARGOKIT_DARWIN_ARCHS="arm64"
export CARGOKIT_CONFIGURATION="release"
export CARGOKIT_TARGET_TEMP_DIR="$BASE_PATH/lib/macos"
export CARGOKIT_DARWIN_PLATFORM_NAME="macosx"
export CARGOKIT_MANIFEST_DIR="$BASE_PATH/src/lwk-dart/rust"
export CARGOKIT_OUTPUT_DIR="$BASE_PATH/release/mac/aarch64-apple-darwin"

dart run build_tool build-pod
