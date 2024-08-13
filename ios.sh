#!/bin/sh
echo "Starting ios build....."

# Check the necessary libraries and binaries are installed
# Check for Rust and Cargo
if [ ! $(command -v rustc) ]; then
  echo "Rust compiler (rustc) not found. Please install Rust from https://www.rust-lang.org/"
  exit 1
fi

# Check for Xcode Command Line Tools
if [ ! $(command -v xcrun) ]; then
  echo "Xcode Command Line Tools not installed. Please install via Xcode Preferences or run 'xcode-select --install'."
  exit 1
fi

# Check for Xcode
if [ ! $(command -v xcodebuild) ]; then
  echo "Xcode not found (optional, but recommended for iOS development)."
fi



#add rust target for darwin/macos
cd src/bdk-flutter/rust

version_line=$(grep -E '^version = .*' Cargo.toml)

# Extract the version string after the  '='
if [ ! -z "$version_line" ]; then
    version=$(echo "$version_line" | cut -d '=' -f2 | tr -d '[:space:]')
    package_version=$(echo "$version" | sed 's/^"//' | sed 's/"$//')
else
    echo "Error: Could not find 'version' in Cargo.toml"
fi

# Print the version or handle errors
if [ ! -z "$package_version" ]; then
  echo "Package version: $package_version"
else
  echo "An error occurred while reading the version."
  exit 1  
fi

# Extract the package name
name_line=$(grep -E '^name = .*' Cargo.toml)
if [ ! -z "$name_line" ]; then
    name=$(echo "$name_line" | cut -d '=' -f2 | tr -d '[:space:]')
    package_name=$(echo "$name" | sed 's/^"//' | sed 's/"$//')
else
    echo "Error: Could not find 'name' in Cargo.toml"
    exit 1
fi


echo "Installing targets"

# Define targets
IOS_TARGETS="aarch64-apple-ios x86_64-apple-ios"

for target in $IOS_TARGETS; do
  if [ ! $(rustup target list | grep -q "$target") ]; then
    echo "Target $target not found in Rust toolchain. Downloading and installing..."
    rustup target add "$target"
    if [ $? -ne 0 ]; then
      echo "Error installing target '$target'. Please check your internet connection and try again."
      exit 1
    fi
  fi
done

cargo install cargo-lipo

cargo lipo --release

cd ../../../

folder_name="lib/ios"

if [ -d "$folder_name" ]; then
    rm -rf "$folder_name"
fi
mkdir "$folder_name"

current_dir=$(pwd)

full_path="/$current_dir/$folder_name"

cp -a "$current_dir/src/bdk-flutter/rust/target/universal/release/libbdk_flutter.a" "$full_path/lib$package_name-$package_version.a"

rm -rf src/bdk-flutter/rust/target
echo "Build completed! Library are in lib/ios folder."
