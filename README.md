## BDK-Cross 🛠️  

**BDK-Cross** is a CLI utility designed to **build and verify binaries** for:  

- **[bdk-flutter](https://github.com/LtbLightning/bdk-flutter.git)** – Bitcoin Dev Kit for Flutter  
- **[lwk-dart](https://github.com/SatoshiPortal/lwk-dart.git)** – Lightning Wallet Kit for Dart  
- **[boltz-dart](https://github.com/SatoshiPortal/boltz-dart.git)** – Boltz Swap integration for Dart  


## Why BDK-Cross?

### Security Matters: Trust, but Verify

Unaudited binaries are significantly harder to inspect. Meaning binaries you download online might do things you don't expect or even run malware.

With BDK-Cross, you can build and verify reproduciblity of your own binaries, to ensure that binaries you ship do exactly what you expect. 

### How It Works
BDK-Cross magic runs on top docker for Android and Linux targets. All this while handling all the cross-compiling troubles for you.

## Get Started
### What you'll Need
For MacOS and iOS targets, you'll need a Mac host to build. Android and Linux targets can be built on any machine so long as Docker is installed.

| **Android and Linux Targets** | **MacOS and iOS Targets** |
|------------------------------|----------------------------|
| Docker                       | Rustup                     |
| Git                          | Git                        |
|                              | Xcode (for iOS)           |

## How to Use

Clone this repo and check in to it via CLI. Give bdk-cross.sh executable permissions by running
```
 chmod +x bdk-cross.sh
```
### Building your Own Binaries

For any target you'd like to build you need to build, pass the library and target you wish to compile for to the script.
You can specify the version of the release tag, without which bdk-cross resolves to building at the latest release tag of the repository.

> ./bdk-cross build <library> <target> <version>

- Build binaries for a supported target

```
 ./bdk-cross build boltz-dart x86_64-unknown-linux-gnu
```
- Build binaries for supported for a specific release tag

```
 ./bdk-cross build bdk-flutter x86_64-unknown-linux-gnu 0.1.6
```
- Build binaries for targets for a platform at a speciic release tag(ios, macos, android, linux)

```
 ./bdk-cross build lwk-dart ios 0.1.6
```
- Build binaries for all targets at a speciic release tag(ios, macos, android, linux)

```
 ./bdk-cross build lwk-dart all 0.1.6
```

After building your binaries, you will find them in the *release* folder under the specified version, inside a folder named after the target:
  - release/
    - latest/
      - linux
        - x86_64-unknown-linux-gnu
          - *YOUR-BINARIES*
    - 0.1.6/
      - ios/
        - aarch64-apple-ios
          - *YOUR-BINARIES*



### Verifying your Binaries
Verifing binaries follows the same format as building except you can only verify binaries you've built and exist in the release folder.

- Verifying binaries for a supported target at the latest release tag

```
 ./bdk-cross verify boltz-dart x86_64-unknown-linux-gnu
```
- Verify binaries for supported for a specific release tag

```
 ./bdk-cross verify bdk-flutter x86_64-unknown-linux-gnu 0.1.6
```
- Verify binaries for all targets for a platforms(ios, macos, android, linux)

```
 ./bdk-cross verify lwk-dart ios 0.1.6
```

## Gotchas
**💡 NB:**  
- Regularly prune Docker images to free up space.  
  To remove unused Docker images, run:  
```sh
 docker image prune -a -f
```
- Ensure a stable internet connection to avoid failed downloads or slow builds.
#### Acknowlegments:

<a href="https://www.bullbitcoin.com/">
  <img src="img/bullbitcoin.png" alt="Sponsor Logo" width="50">
</a>
