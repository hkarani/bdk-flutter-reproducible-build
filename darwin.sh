#!/bin/sh
echo "Starting Darwin build..."
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

echo "Installing targets"

# Define targets
MAC_TARGETS="x86_64-apple-darwin aarch64-apple-darwin"
IOS_TARGETS="aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim"

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


for target in $MAC_TARGETS; do
  if [ ! $(rustup target list | grep -q "$target") ]; then
    echo "Target $target not found in Rust toolchain. Downloading and installing..."
    rustup target add "$target"
    if [ $? -ne 0 ]; then
      echo "Error installing target '$target'. Please check your internet connection and try again."
      exit 1
    fi
  fi
done

# build compiled files into the thier respctive folders
for target in $IOS_TARGETS; do
  # Build for the current target
  echo "Building for target: $target"
  cargo build -release --target "$target"

  # Check the exit code of cargo build
  if [ $? -ne 0 ]; then
    echo "Error building for target '$target'. Please check your project and dependencies."
    exit 1
  fi
done


# build compiled files in the thier respctive folders
for target in $MAC_TARGETS; do
  # Build for the current target
  echo "Building for target: $target"
  cargo build --release --target "$target"

  # Check the exit code of cargo build
  if [ $? -ne 0 ]; then
    echo "Error building for target '$target'. Please check your project and dependencies."
    exit 1
  fi
done
cd ../../../

current_dir=$(pwd)
folder_name="lib/darwin"

if [ -d "$folder_name" ]; then
    rm -rf "$folder_name"
fi
mkdir "$folder_name"

#use lipo to merge the simulator and real version of the library
DIR_TO_CREATE="lib/darwin/mac"

if [ ! -d "$DIR_TO_CREATE" ]; then
  mkdir -p "$DIR_TO_CREATE"
  if [ $? -ne 0 ]; then
    echo "Error creating directory '$DIR_TO_CREATE'. Please check permissions."
    exit 1
  fi
else
  return 
fi


DIR_TO_CREATE2="lib/darwin/ios"

if [ ! -d "$DIR_TO_CREATE2" ]; then
  mkdir -p "$DIR_TO_CREATE2"
  if [ $? -ne 0 ]; then
    echo "Error creating directory '$DIR_TO_CREATE2'. Please check permissions."
    exit 1
  fi
else
  return
fi

lipo -create -output $DIR_TO_CREATE2 \
        src/bdk-flutter/rust/target/aarch64-apple-ios/release/libbdk_flutter.a\
        src/bdk-flutter/rust/target/x86_64-apple-ios/release/libbdk_flutter.a

lipo -create -output $DIR_TO_CREATE \
        src/bdk-flutter/rust/target/x86_64-apple-darwin/release/libbdk_flutter.a\
        src/bdk-flutter/rust/target/aarch64-apple-darwin/release/libbdk_flutter.a\
        

xcodebuild -create-xcframework \
        -library $DIR_TO_CREATE \
        -library $DIR_TO_CREATE2 \
        -library src/bdk-flutter/rust/target/aarch64-apple-ios-sim/release/libbdk_flutter.a \
        -output "lib/darwin/rust_bdk_ffi_$package_version.xcframework"

rm -rf src/bdk-flutter/rust/target
rm -rf $DIR_TO_CREATE
rm -rf $DIR_TO_CREATE2
echo "Build completed! Libraries are in lib/android * folders."