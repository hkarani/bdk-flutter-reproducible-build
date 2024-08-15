#!/bin/sh
set +e
echo "Starting MaoOS build..."
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
cd src/*/rust

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

# Extract the name from the [package] section
package_name_line=$(grep -m 1 -E '^name = .*' Cargo.toml)

# Extract the second name from the [lib] section
lib_name_line=$(grep -E '^\[lib\]' -A 5 Cargo.toml | grep -E '^name = .*')

# Extract the package name string after the '='
if [ ! -z "$package_name_line" ]; then
    package_name=$(echo "$package_name_line" | cut -d '=' -f2 | tr -d '[:space:]' | sed 's/^"//' | sed 's/"$//')
else
    echo "Error: Could not find 'name' in [package] section"
    exit 1
fi

# Extract the lib name string after the '=' if it exists
if [ ! -z "$lib_name_line" ]; then
    lib_name=$(echo "$lib_name_line" | cut -d '=' -f2 | tr -d '[:space:]' | sed 's/^"//' | sed 's/"$//')
else
    lib_name=""
fi


# Print the final package name
echo "Package name: $package_name"


echo "Installing macos targets....."

# Define targets
MAC_TARGETS="x86_64-apple-darwin aarch64-apple-darwin"

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

echo "Building targets....."
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
folder_name="lib/macos"

if [ -d "$folder_name" ]; then
    rm -rf "$folder_name"
fi
mkdir "$folder_name"

full_path="/$current_dir/$folder_name"

# Assign lib name as package name if lib name exists
if [ ! -z "$lib_name" ]; then
  a_file="$current_dir/src/*/rust/target/x86_64-apple-darwin/release/lib$lib_name.a"
  a_file1="$current_dir/src/*/rust/target/aarch64-apple-darwin/release/lib$lib_name.a"
else 

  a_file="$current_dir/src/*/rust/target/x86_64-apple-darwin/release/lib$package_name.a"
  a_file1="$current_dir/src/*/rust/target/aarch64-apple-darwin/release/lib$package_name.a"
fi


echo $lib_name
echo $package_name

lipo -create -output "$full_path/lib$package_name-$package_version.a" $a_file $a_file1
rm -rf src/*/rust/target
echo "Build completed! Library are in lib/ios folder."