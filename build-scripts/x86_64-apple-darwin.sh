#!/bin/bash

BASE_PATH="$(pwd)"
library=$1
VERSION=${2:-"latest"}
cd src/*/cargokit/build_tool/bin

export CARGOKIT_ROOT_PROJECT_DIR="$BASE_PATH/src/$library"
export CARGOKIT_DARWIN_ARCHS="x86_64"
export CARGOKIT_CONFIGURATION="release"
export CARGOKIT_TARGET_TEMP_DIR="$BASE_PATH/lib/$library/$VERSION/macos/x86_64-apple-darwin"
export CARGOKIT_DARWIN_PLATFORM_NAME="macosx"
export CARGOKIT_MANIFEST_DIR="$BASE_PATH/src/$library/rust"
export CARGOKIT_OUTPUT_DIR="$BASE_PATH/release/$library/$VERSION/macos/x86_64-apple-darwin"

dart run build_tool build-pod
