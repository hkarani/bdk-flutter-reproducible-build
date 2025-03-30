#!/bin/bash

if ! command -v rustup &> /dev/null; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    export PATH="$HOME/.cargo/bin:$PATH"
fi

RUST_VERSION="1.80.0"

echo "Installing Rust $RUST_VERSION..."
rustup install "$RUST_VERSION"

echo "Setting Rust $RUST_VERSION as the default..."
rustup default "$RUST_VERSION"

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
rustup target add aarch64-apple-ios
cargo build --release --target aarch64-apple-ios

file=$(ls $BASE_PATH/src/*/rust/target/aarch64-apple-ios/release/*.a | head -n 1)  # Get the first `.a` file
mkdir -p "$BASE_PATH/release/$library/$VERSION/ios/aarch64-apple-ios"
mv "$file" "$BASE_PATH/release/$library/$VERSION/ios/aarch64-apple-ios/aarch64-apple-ios_lib$package_name.a"
cd ../../../
echo "✅ aarch64-apple-ios build completed! Binary in release/$library/$VERSION/ios/x86_64-apple-ios/ folder."