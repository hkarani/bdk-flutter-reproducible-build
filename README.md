## BDK Build Tool 🛠️  

**BDK Build Tool** is a CLI utility designed to **build and verify binaries** for:  

- **[bdk-flutter](https://github.com/LtbLightning/bdk-flutter.git)** – Bitcoin Dev Kit for Flutter  
- **[lwk-dart](https://github.com/SatoshiPortal/lwk-dart.git)** – Lightning Wallet Kit for Dart  
- **[boltz-dart](https://github.com/SatoshiPortal/boltz-dart.git)** – Boltz Swap integration for Dart  


## Why Use BDK Build Tool?

### Security Matters: Trust, but Verify

Unaudited binaries are significantly harder to inspect. Meaning binaries you download online might do things you do expect or even run malware.

With BDK Build Tool, you can build and verify reproduciblity of your own binaries, to ensure that binaries you ship do exactly what you expect. 

### How It Works
BDK Build Tool reverse-engineers [Cargokit's](https://github.com/irondash/cargokit) magic to run on top docker for Android and Linux targets. All this while handling all the cross-compiling troubles for you.

## Get Started
### What you'll Need
For MacOS and iOS targets, you'll need a Mac host to build. Android and Linux targets can be built on any machine so long as Docker is installed.

| **Android and Linux Targets** | **MacOS and iOS Targets** |
|------------------------------|---------------------------|
| Docker                       | Dart and Flutter         |
| Dart and Flutter             | Rustup (NOT installed via Homebrew)|
| Git                          | Git                       |
|                              | Xcode (for iOS)          |

**💡 NB:** 
If Rust is installed via Homebrew
Run `brew unlink rust` to unlink.  
Run ```curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh``` for Cargokit to detect rustup.

## How to Use

Clone this repo and check in to it via CLI. Give it executable permissions by running
```
    chmod +x bdk-rep-build.sh
```
### Building your Own Binaries

Building binaries for any target needs you to pass the library, target wish to build.
You can specify the version of the release tag failure of which bdk-build-tool will resolve to build at the latest commit of repository .

> ./bdk-rep-build build <library> <target> <version>

Build binaries for a supported target

```
  ./bdk-rep-build build bolt-dart x86_64-unknown-linux-gnu
```
Build binaries for supported for a specific release tag

```
  ./bdk-rep-build build bdk-flutter x86_64-unknown-linux-gnu 0.1.6
```
Build binaries for all targets for a platforms(ios, macos, android, linux)

```
  ./bdk-rep-build build lwk-dart ios 0.1.6
```


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
