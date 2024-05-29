#!/bin/sh
checkfolders() {
  #Check if the folder exists and is a directory
  folder_name=$1
  folder_name2=$2
  if [ -d "$folder_name" ]; then
    # Check if the folder has any files (using find)
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

# Function to check file existence and size equality (basic check)
check_file_basics () {

  if [ "$target" == "darwin" ]; then
    local file1="$folder_name/rust_bdk_ffi.xcframework"
    local file2="$folder_name2/rust_bdk_ffi.xcframework"
  else
    local file1="$folder_name/libbdk_flutter.so"
    local file2="$folder_name2/libbdk_flutter.so"
  fi

  if [ ! -f "$file1" ]; then
    echo "Error: File '$file1' does not exist"
    exit 1
  fi

  if [ ! -f "$file2" ]; then
    echo "Error: File '$2' does not exist"
    exit 1
  fi

  # Check file size equality (basic check)
  if [ $(stat -c %s "$file1") -ne $(stat -c %s "$file2") ]; then
    echo "❌Fail. Mismatch detected❌. The files differ in size"
    exit 1
  fi

  echo "Files match in size"
}

check_file_basics
# Main script execution

if [ "$target" == "darwin" ]; then
  file1="$folder_name/rust_bdk_ffi.xcframework"
  file2="$folder_name2/rust_bdk_ffi.xcframework"
else
  file1="$folder_name/libbdk_flutter.so"
  file2="$folder_name2/libbdk_flutter.so"
fi

# # Get file names as arguments
# file1="$folder_name/libbdk_flutter.so"
# file2="$folder_name2/libbdk_flutter.so"


# Checking 
result=$(cmp "$file1" "$file2")

# Check the outcome of cmp
if [ $? -eq 0 ]; then
  echo "✅ Success! The binaries are byte by byte identical✅."
else
  # If there's a difference, display details (optional)
  echo "❌Fail. Mismatch detected❌."
  if [[ "$result" != "" ]]; then
    echo "Files are not comparable" 
  fi
  exit 1  # Indicate non-identical files with an exit code (optional)
fi

