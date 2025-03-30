#!/bin/bash

if ! command -v rustup &> /dev/null; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ ! $(command -v rustc) ]; then
  echo "Rust compiler (rustc) not found. Please install Rust from https://www.rust-lang.org/"
  exit 1
fi

if [ ! -x "$(command -v git)" ]; then
    echo "Git is not installed."
    echo "Installation instructions might be here: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"
    exit 0
fi

# Check for Xcode Command Line Tools
if [ ! $(command -v xcrun) ]; then
  echo "Xcode Command Line Tools not installed. Please install via Xcode Preferences or run 'xcode-select --install'."
  exit 1
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

rustup target add x86_64-apple-darwin
cargo build --release --target x86_64-apple-darwin

file=$(ls $BASE_PATH/src/*/rust/target/x86_64-apple-darwin/release/*.a | head -n 1)  # Get the first `.a` file
mkdir -p "$BASE_PATH/release/$library/$VERSION/ios/x86_64-apple-darwin"
mv "$file" "$BASE_PATH/release/$library/$VERSION/ios/x86_64-apple-darwin/x86_64-apple-darwin_lib$package_name.a"
cd ../../../
echo "✅ x86_64-apple-darwin build completed. Binary in release/$library/$VERSION/ios/x86_64-apple-ios/ folder. "
