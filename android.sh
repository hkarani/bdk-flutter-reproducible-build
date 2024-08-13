#!/bin/sh

set -e  # Exit on failure

# Check if docker is installed

if [ ! -x "$(command -v docker)" ]; then
    echo "docker is not installed"
    echo "installation instructions might be here: https://docs.docker.com/engine/install/"
    exit 0
fi
# Function to extract the package version from Cargo.toml
  # Use grep to find the line containing 'version' in Cargo.toml
cd src/bdk-flutter/rust
version_line=$(grep -E '^version = .*' Cargo.toml)

# Extract the version string after the  '='
if [ ! -z "$version_line" ]; then
    version=$(echo "$version_line" | cut -d '=' -f2 | tr -d '[:space:]')
    package_version=$(echo "$version" | sed 's/^"//' | sed 's/"$//')
else
    echo "Error: Could not find 'version' in Cargo.toml"
fi

cd ../../../


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

echo "Starting  $target build..."
docker build -t build-$target -f Dockerfile.$target .
echo "Build completed!"
echo "Running build-$target docker"
container_id=$(docker run -d build-$target) || fail "Failed to run container"
current_dir=$(pwd)
folder_name="lib/$target"

if [ -d "$folder_name" ]; then
    rm -rf "$folder_name"
fi
mkdir "$folder_name"

architecture="aarch64-linux-android"


full_path="/$current_dir/$folder_name"
docker cp -a $container_id:"/app/target/$architecture/release/libbdk_flutter.a" "$full_path/lib$package_name-$package_version.a"
echo "File copied"
docker kill $container_id
echo "build-$target container stoppped"

echo "Build completed! Library in lib/android folder."