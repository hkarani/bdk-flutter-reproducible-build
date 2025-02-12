# BDK-REP-BUILD

BDK Build Tool is a CLI utility designed to build and verify binaries for: bdk-flutter (Bitcoin Dev Kit for Flutter), lwk-dart (Lightning Wallet Kit for Dart, Boltz-dart (Boltz Swap integration for Dart)

## Why Use BDK Build Tool?

### Security Matters: Trust, but Verify

Binaries you downloaded online and are happily shipping might not steal your users' wallet seed phrases or run malware, but the fact is unaudited binaries are significantly harder to inspect, making supply chain attacks a real risk.

With BDK Build Tool, you can build and verify your own binaries, to be ensure that what you ship is exactly what you expect.

  * 🔍 Ensures reproducible builds – Prevents unexpected changes in compiled binaries.
  * 🔑 Verifies integrity – Confirms that binaries match expected hashes.
  * 📦 Cross-platform support – Builds for multiple architectures and OS targets.

# How It Works

    * Compiles source code into binaries for specified targets.
    * Verifies hashes against known good values.
    * Prepares artifacts for distribution with confidence.

# Get Started

 ____  ____  _  __     ____  _____ ____       ____  _   _ ___ _     ____  
| __ )|  _ \| |/ /    |  _ \| ____|  _ \     | __ )| | | |_ _| |   |  _ \ 
|  _ \| | | | ' /_____| |_) |  _| | |_) |____|  _ \| | | || || |   | | | |
| |_) | |_| | . \_____|  _ <| |___|  __/_____| |_) | |_| || || |___| |_| |
|____/|____/|_|\_\    |_| \_\_____|_|        |____/ \___/|___|_____|____/ 

        Cross-compile and verify reproducible builds for bdk-rust library.
            * To use with : BDK-Flutter, LWK-Dart, BOLTZ-dart
            * Targeting: Linux, Android, MacOS, iOS  
USAGE
    $ bdk-rep-build [COMMAND]
    $ bdk-rep-build help [COMMAND]

COMMANDS
    help                show help
    
    verify          verify build against release
    build           build artifacts for a target  


## USAGE

> Clone the library you like to test into the SRC folder
> chmod +x bdk-rep-build

# BUILDING

For linux
  > ./bdk-rep-build build linux

For androdid
  > ./bdk-rep-build build android

For macos
  > ./bdk-rep-build build macos

For macos
  > ./bdk-rep-build build ios

## Verify

1. Download binary into release/$target folder
2. Run ./bdk-rep-build verify <target>

 > ./bdk-rep-build verify macos
