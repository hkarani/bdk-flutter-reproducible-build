#!/bin/sh
echo "Starting macos build..."
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

echo "Installing targets"

# Define targets (replace with your actual targets)
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
  cargo build --target "$target"

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
  cargo build --target "$target"

  # Check the exit code of cargo build
  if [ $? -ne 0 ]; then
    echo "Error building for target '$target'. Please check your project and dependencies."
    exit 1
  fi
done
cd ../.../../../../
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
# cp -f src/bdk-flutter/rust/target/aarch64-linux-android/release/libbdk_flutter.so lib/darwin/mac/libbdk_flutter_x64.so
# cp -f src/bdk-flutter/rust/target/aarch64-linux-android/release/libbdk_flutter.so lib/darwin/mac/libbdk_flutter_aarch.so

lipo -create -output $DIR_TO_CREATE2 \
        src/bdk-flutter/rust/target/aarch64-linux-android/release/libbdk_flutter.so\
        src/bdk-flutter/rust/target/aarch64-linux-android/release/libbdk_flutter.so

lipo -create -output $DIR_TO_CREATE1 \
        src/bdk-flutter/rust/target/aarch64-linux-android/release/libbdk_flutter.so\
        src/bdk-flutter/rust/target/aarch64-linux-android/release/libbdk_flutter.so\
        src/bdk-flutter/rust/target/aarch64-linux-android/release/libbdk_flutter.so

xcodebuild -create-xcframework \
        -library $DIR_TO_CREATE1 \
        -library $DIR_TO_CREATE2 \
        -library src/bdk-flutter/rust/target/aarch64-linux-android/release/libbdk_flutter.so \
        -output lib/darwin/rust_bdk_ffi.xcframework