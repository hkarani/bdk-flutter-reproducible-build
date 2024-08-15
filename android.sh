#!/bin/sh

set +e  # Exit on failure

# Check if docker is installed

if [ ! -x "$(command -v docker)" ]; then
    echo "docker is not installed"
    echo "installation instructions might be here: https://docs.docker.com/engine/install/"
    exit 0
fi
# Function to extract the package version from Cargo.toml
  # Use grep to find the line containing 'version' in Cargo.toml
cd src/*/rust
version_line=$(grep -E '^version = .*' Cargo.toml)

# Extract the version string after the  '='
if [ ! -z "$version_line" ]; then
    version=$(echo "$version_line" | cut -d '=' -f2 | tr -d '[:space:]')
    package_version=$(echo "$version" | sed 's/^"//' | sed 's/"$//')
else
    echo "Error: Could not find 'version' in Cargo.toml"
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


cd ../../../


# Print the version or handle errors
if [ ! -z "$package_version" ]; then
  echo "Package version: $package_version"
else
  echo "An error occurred while reading the version."
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

# Assign lib name as package name if lib name exists
if [ ! -z "$lib_name" ]; then
  a_file="/app/target/$architecture/release//lib$lib_name.a"
else 
  a_file="/app/target/$architecture/release//lib$package_name.a"
fi


full_path="/$current_dir/$folder_name"
docker cp -a $container_id:"$a_file" "$full_path/lib$package_name-$package_version.a"
echo "File copied"
docker kill $container_id
echo "build-$target container stoppped"

echo "Build completed! Library in lib/android folder."