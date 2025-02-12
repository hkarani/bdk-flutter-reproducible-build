## BDK Build Tool 🛠️  

**BDK Build Tool** is a CLI utility designed to **build and verify binaries** for:  

- **[bdk-flutter](https://github.com/LtbLightning/bdk-flutter.git)** – Bitcoin Dev Kit for Flutter  
- **[lwk-dart](https://github.com/SatoshiPortal/lwk-dart.git)** – Lightning Wallet Kit for Dart  
- **[boltz-dart](https://github.com/SatoshiPortal/boltz-dart.git)** – Boltz Swap integration for Dart  


## Why Use BDK Build Tool?

### Security Matters: Trust, but Verify

Binaries you downloaded online and are happily shipping might not steal your users' wallet seed phrases or run malware, but the fact is unaudited binaries are significantly harder to inspect, making supply chain attacks a real risk.

With BDK Build Tool, you can build and verify your own binaries, to ensure that what you ship is exactly what you expect. 

## How It Works
BDK Build Tool reverse-engineers Cargokit magic to run on top docker for Android and Linux targets. All this while handling all the 
cross-compiling troubles for you.

- Compiles your own binaries for specified targets on your machine.
- Verifies local binaries with published builds.
- Prepares artifacts for distribution with confidence.

## Get Started
## What you'll Need
For MacOS and iOS targets, you'll need a Mac host to build. Android and Linux targets can be built on any machine so long as Docker is installed.

**Android and Linux targets**
- Docker
- Dart and Flutter
- Git

**MacOS and iOS targets**
- Dart and Flutter
- Rustup(NOT INSTALLED via Homebrew) RUn `brew unlink rust` to unlink, Run `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` for Cargokit to detect rustup
- Git
- Xcode(for iOS)

## How to Use

> Clone the library you like to test into the SRC folder
> chmod +x bdk-rep-build

### Building your Own Binaries

For linux
  > ./bdk-rep-build build linux

For androdid
  > ./bdk-rep-build build android

For macos
  > ./bdk-rep-build build macos

For macos
  > ./bdk-rep-build build ios

### Verifying your Binaries

1. Download binary into release/$target folder
2. Run ./bdk-rep-build verify <target>

 > ./bdk-rep-build verify macos
