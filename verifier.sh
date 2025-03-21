# #!/bin/sh
library="$1"
target="$2"
downloaded_file="$3"
VERSION="$4"

built_binary=$(find "release/$library/$VERSION" -type f -path "*/$target/$target.*" \( -name "*.so" -o -name "*.a" \) | head -n 1)
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
  echo "✅ Success! The binaries are byte by byte identical ✅."
else
  echo "❌Fail. Mismatch detected ❌."
fi
echo " "


