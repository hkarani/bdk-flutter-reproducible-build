#!/bin/sh

set -e  # Exit on failure

# Check if docker is installed

if [ ! -x "$(command -v docker)" ]; then
    echo "docker is not installed"
    echo "installation instructions might be here: https://docs.docker.com/engine/install/"
    exit 0
fi

# Define target architectures

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
docker cp -a $container_id:"/app/target/$architecture/release/libbdk_flutter.so" $full_path
echo "File copied"
docker kill $container_id
echo "build-$target container stoppped"

echo "Build completed! Libraries are in lib/android * folders."