#!/bin/bash
current_dir=$(pwd)

# Check and update .cargo/config.toml for release builds
CARGO_CONFIG="$current_dir/src/*/rust/.cargo/config.toml"
CARGOKIT_YAML="$current_dirsrc/*/rust/cargokit.yaml"
CARGOKIT_OPTIONS="$current_dir/src/*/cargokit_options.yaml"

echo $CARGO_CONFIG
echo $CARGOKIT_YAML
echo $CARGOKIT_OPTIONS

if [ -f "$CARGO_CONFIG" ]; then
  # Check if the [profile.release] section already exists
  if ! grep -q '\[profile.release\]' "$CARGO_CONFIG"; then
    echo "[profile.release]
opt-level = 'z'
lto = true
codegen-units = 1
panic = 'abort'" >> "$CARGO_CONFIG"
    echo "Added release profile settings to $CARGO_CONFIG"
  else
    echo "Release profile settings already exist in $CARGO_CONFIG"
  fi
else
  echo "$CARGO_CONFIG does not exist."
fi

# Check and update cargokit.yaml for stable toolchain
if [ -f "$CARGOKIT_YAML" ]; then
  # Check if the toolchain entry exists and update it
  if ! grep -q 'toolchain:' "$CARGOKIT_YAML"; then
    echo "cargo:
  release:
    toolchain: stable" >> "$CARGOKIT_YAML"
    echo "Added toolchain configuration to $CARGOKIT_YAML"
  else
    # Update the toolchain to stable
    sed -i '/toolchain:/s/:\s*[^ ]*/: stable/' "$CARGOKIT_YAML"
    echo "Updated toolchain to stable in $CARGOKIT_YAML"
  fi
else
  echo "$CARGOKIT_YAML does not exist."
fi

# Check and update cargokit_options.yaml for use_precompiled_binaries
if [ -f "$CARGOKIT_OPTIONS" ]; then
  # Check if the use_precompiled_binaries setting exists and update it
  if ! grep -q 'use_precompiled_binaries:' "$CARGOKIT_OPTIONS"; then
    echo "use_precompiled_binaries: false" >> "$CARGOKIT_OPTIONS"
    echo "Added use_precompiled_binaries setting to $CARGOKIT_OPTIONS"
  else
    # Update the use_precompiled_binaries setting
    sed -i '/use_precompiled_binaries:/s/:\s*[^ ]*/: false/' "$CARGOKIT_OPTIONS"
    echo "Updated use_precompiled_binaries to false in $CARGOKIT_OPTIONS"
  fi
else
  echo "$CARGOKIT_OPTIONS does not exist."
fi

