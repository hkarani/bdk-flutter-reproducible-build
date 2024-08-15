#!/bin/sh
checkfolders() {
  #Check if the folder exists and is a directory
  folder_name=$1
  folder_name2=$2
  if [ -d "$folder_name" ]; then
    # Check if the folder has any files
    if [ "$(find "$folder_name" -mindepth 1 -maxdepth 1 -type f -print -quit)" ]; then
      return
    else
empty_folder="
The lib folder '$folder_name' exists but is empty.

     Build with:

          $ ./bdk-rep-build build <target> 
              to add build file to test.
"  

      echo "$empty_folder"
      exit 1
    fi
  else
missing_folder="
The lib folder '$folder_name' is missing.

     Build with:

          $ ./bdk-rep-build build <target> 
              to add build file to test.
"  
    echo "$missing_folder"
  fi

   if [ -d "$folder_name2" ]; then
    # Check if the folder has any files (using find)
    if [ "$(find "$folder_name2" -mindepth 1 -maxdepth 1 -type f -print -quit)" ]; then
      return
    else
empty_folder="
The release folder '$folder_name2' exists but does have a binary file.

     Download and add the respective binary file to $folder_name2 to verify against your build.
"
      echo "$empty_folder"
      exit 1
    fi
  else
missing_folder="
The release folder '$folder_name2' is missing.

     Download and add the respective binary file to $folder_name2 to verify against your build.
"
    echo "$missing_folder"
    exit 1
  fi
}

checkfolders "lib/$target"  "release/$target"

# Function to check file existence and size equality
check_file_basics () {
  

  if [ "$target" = "darwin" ]; then
    file1_pattern="$folder_name/rust_bdk_ffi_*.xcframework"
    file1_pattern2="$folder_name2/rust_bdk_ffi_*.xcframework"
    local file1=$(find "$folder_name" -wholename "$file1_pattern" -type f | head -n 1)
    local file2=$(find "$folder_name2" -wholename "$file1_pattern2" -type f | head -n 1)
    # local file1="$folder_name/rust_bdk_ffi.xcframework"
    # local file2="$folder_name2/rust_bdk_ffi.xcframework"
  else
    file1_pattern="$folder_name/*.a"
    file1_pattern2="$folder_name2/*.a"
    local file1=$(find "$folder_name" -wholename "$file1_pattern" -type f | head -n 1)
    local file2=$(find "$folder_name2" -wholename "$file1_pattern2" -type f | head -n 1)
  fi

  if [ ! -f "$file1" ]; then
    echo "🔴Error: Build binary has not been build to lib/$target folder🔴"
    exit 1
  fi

  if [ ! -f "$file2" ]; then
    echo "🔴Error: Release binary had not been downloaded to release/$target folder🔴"
    exit 1
  fi

  # # Check file size equality (basic check)
  # if [ $(stat -c %s "$file1") -ne $(stat -c %s "$file2") ]; then
  #   echo "❌Fail. Mismatch detected❌. The files differ in size"
  #   exit 1
  # fi

  # echo "Files size check passed ✅"
}

check_file_basics
# Main script execution

 if [ "$target" = "darwin" ]; then
    file1_pattern="$folder_name/rust_bdk_ffi_*.xcframework"
    file1_pattern2="$folder_name2/rust_bdk_ffi_*.xcframework"
    file1=$(find "$folder_name" -wholename "$file1_pattern" -type f | head -n 1)
    file2=$(find "$folder_name2" -wholename "$file1_pattern2" -type f | head -n 1)
    # local file1="$folder_name/rust_bdk_ffi.xcframework"
    # local file2="$folder_name2/rust_bdk_ffi.xcframework"
  else
    file1_pattern="$folder_name/*.a"
    file1_pattern2="$folder_name2/*.a"
    file1=$(find "$folder_name" -wholename "$file1_pattern" -type f | head -n 1)
    file2=$(find "$folder_name2" -wholename "$file1_pattern2" -type f | head -n 1)
   
  fi

# if [ "$(basename "$file1")" != "$(basename "$file2")" ]; then
#   echo "🟡 You might be verifying two different bdk-rust versions 🟡"
  
# fi


if cmp "$file1" "$file2" > /dev/null 2>&1; then
  echo "✅ Success! The binaries are byte by byte identical ✅."
else
  echo "❌ Fail. Mismatch detected ❌."
fi


