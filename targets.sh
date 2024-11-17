#1
x86_64-unknown-linux-gnu[rust] = 'x86_64-unknown-linux-gnu'
x86_64-unknown-linux-gnu[flutter] = 'linux-x64'

#2
aarch64-unknown-linux-gnu[rust] = 'aarch64-unknown-linux-gnu'
aarch64-unknown-linux-gnu[flutter] = 'linux-arm64'

#3
armv7-linux-androideabi[rust] = 'armv7-linux-androideabi'
armv7-linux-androideabi[flutter] = 'android-arm'
armv7-linux-androideabi[android] = 'armeabi-v7a'
armv7-linux-androideabi[androidMinSdkVersion] = 16

#4
aarch64-linux-android[rust] = 'aarch64-linux-android'
aarch64-linux-android[flutter] = 'android-arm64'
aarch64-linux-android[android] = 'arm64-v8a'
aarch64-linux-android[androidMinSdkVersion] = 21

#5
i686-linux-android[rust] = 'i686-linux-android'
i686-linux-android[flutter] = 'android-x86'
i686-linux-android[android] = 'x86'
i686-linux-android[androidMinSdkVersion] = 21

#6
x86_64-linux-android[rust] = 'x86_64-linux-android'
x86_64-linux-android[flutter] = 'android-x64'
x86_64-linux-android[android] = 'x86_64'
x86_64-linux-android[androidMinSdkVersion] = 21

#7
x86_64-pc-windows-msvc[rust] = 'x86_64-pc-windows-msvc'
x86_64-pc-windows-msvc[flutter] = 'windows-x64'

#8
x86_64-apple-darwin[rust] = 'x86_64-apple-darwin'
x86_64-apple-darwin[darwinPlatform] = 'macosx'
x86_64-apple-darwin[darwinArch] = 'x86_64'

#9
aarch64-apple-darwin[rust] = 'aarch64-apple-darwin'
aarch64-apple-darwin[darwinPlatform] = 'macosx'
aarch64-apple-darwin[darwinArch] = 'arm64'

#10
aarch64-apple-ios[rust] = 'aarch64-apple-ios'
aarch64-apple-ios[darwinPlatform] = 'iphoneos'
aarch64-apple-ios[darwinArch] = 'arm64'

#11
aarch64-apple-ios-sim[rust] = 'aarch64-apple-ios-sim'
aarch64-apple-ios-sim[darwinPlatform] = 'iphonesimulator'
aarch64-apple-ios-sim[darwinArch] = 'arm64'

#12
x86_64-apple-ios[rust] = 'x86_64-apple-ios'
x86_64-apple-ios[darwinPlatform] = 'iphonesimulator'
x86_64-apple-ios[darwinArch] = 'x86_64'






