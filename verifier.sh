#!/bin/sh
library="$1"
target="$2"
downloaded_file="$3"
VERSION="$4"
platform="$5"

built_binary=$(find "release/$library/$VERSION/$platform/$target" -type f \( -name "*.so" -o -name "*.a" \) | head -n 1)
downloaded_file=$3

if [[ ! -f "$built_binary" ]]; then
    echo "❌Error: Built binary not found at "release/$library/$VERSION". Please build binary to verify against."
    exit 1
fi


if [[ ! -f "$downloaded_file" ]]; then
    echo "❌Error: Downloaded file not found at $downloaded_file"
    exit 1
fi

if cmp "$built_binary" "$downloaded_file" > /dev/null 2>&1; then
  echo "✅ Success! $target binary is byte by byte identical with published library ✅."
else
  echo "❌Fail. Mismatch detected ❌."
fi


