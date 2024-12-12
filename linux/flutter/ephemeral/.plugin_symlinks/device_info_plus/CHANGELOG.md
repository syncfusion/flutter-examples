## 10.1.2

 - **DOCS**(device_info_plus): Update plugin requirements in README ([#3162](https://github.com/fluttercommunity/plus_plugins/issues/3162)). ([6cfa950f](https://github.com/fluttercommunity/plus_plugins/commit/6cfa950f66fec649093b6c44755dc06a3a23319e))

## 10.1.1

 - **CHORE**(device_info_plus): Use `>=0.5.0 < 2.0.0` version range for package:web.
 - **FIX**(device_info_plus): fix integration_test iOS ([#2958](https://github.com/fluttercommunity/plus_plugins/issues/2958)). ([93ab854e](https://github.com/fluttercommunity/plus_plugins/commit/93ab854ee76a3de48387b6c54ddaeccb01cf49a9))
 - **REFACTOR**(all): Remove website files, configs, mentions ([#3018](https://github.com/fluttercommunity/plus_plugins/issues/3018)). ([ecc57146](https://github.com/fluttercommunity/plus_plugins/commit/ecc57146aa8c6b1c9c332169d3cc2205bc4a700f))
 - **FIX**(all): changed homepage url in pubspec.yaml ([#3099](https://github.com/fluttercommunity/plus_plugins/issues/3099)). ([66613656](https://github.com/fluttercommunity/plus_plugins/commit/66613656a85c176ba2ad337e4d4943d1f4171129))

## 10.1.0

 - **REFACTOR**(device_info_plus): Migrate Android example to use the new plugins declaration ([#2769](https://github.com/fluttercommunity/plus_plugins/issues/2769)). ([6103b155](https://github.com/fluttercommunity/plus_plugins/commit/6103b1559d6f9383bd66460bf7717afeeeb51d86))
 - **FIX**(device_info_plus): WASM-compatible conditional imports ([#2826](https://github.com/fluttercommunity/plus_plugins/issues/2826)). ([11200cf4](https://github.com/fluttercommunity/plus_plugins/commit/11200cf4eb38bfa6bc83e955a3ceff7b8fc72493))
 - **FEAT**(device_info_plus): Add isLowRamDevice property to AndroidDeviceInfo ([#2765](https://github.com/fluttercommunity/plus_plugins/issues/2765)). ([1376b035](https://github.com/fluttercommunity/plus_plugins/commit/1376b0359fd39172cfb54595178313c73f5d1942))
 - **DOCS**(device_info_plus): Add iOS name property entitlements info ([#2756](https://github.com/fluttercommunity/plus_plugins/issues/2756)). ([d21f285a](https://github.com/fluttercommunity/plus_plugins/commit/d21f285a1d26e7a512c4a9aea579de9680a6ca48))

## 10.0.1

> Note: This release has breaking changes.

In this release plugin migrated to package:web, meaning that it now supports WASM!

Plugin now requires the following:
- Flutter >=3.19.0
- Dart >=3.3.0
- compileSDK 34 for Android part
- Java 17 for Android part
- Gradle 8.4 for Android part
-
 - **BREAKING** **REFACTOR**(device_info_plus): bump MACOSX_DEPLOYMENT_TARGET from 10.11 to 10.14 ([#2589](https://github.com/fluttercommunity/plus_plugins/issues/2589)). ([1c586abf](https://github.com/fluttercommunity/plus_plugins/commit/1c586abf7ee351927242a70cb88e2e36140cec9e))
 - **BREAKING** **FIX**(device_info_plus): Remove Display Metrics from Android Device Info ([#2731](https://github.com/fluttercommunity/plus_plugins/issues/2731)). ([c5af3322](https://github.com/fluttercommunity/plus_plugins/commit/c5af332207e44902ac92765da72d2acb213fae91))
 - **BREAKING** **FEAT**(device_info_plus): migrate to package:web ([#2624](https://github.com/fluttercommunity/plus_plugins/issues/2624)). ([154e76ca](https://github.com/fluttercommunity/plus_plugins/commit/154e76ca2f9e8c1ccdaa6e2076426002c9d372a3))
 - **BREAKING** **BUILD**(device_info_plus): Target Java 17 on Android ([#2725](https://github.com/fluttercommunity/plus_plugins/issues/2725)). ([aa826dea](https://github.com/fluttercommunity/plus_plugins/commit/aa826deac5ef8136ce922f5823be2e7f90f828e9))
 - **BREAKING** **BUILD**(device_info_plus): Update to target and compile SDK 34 ([#2704](https://github.com/fluttercommunity/plus_plugins/pull/2704)). ([a3cd72f](https://github.com/fluttercommunity/plus_plugins/commit/a3cd72f86ba47f43c507f8b83f89aac7519404de))
 - **FIX**(device_info_plus): remove unnecessary print ([#2607](https://github.com/fluttercommunity/plus_plugins/issues/2607)). ([5d515816](https://github.com/fluttercommunity/plus_plugins/commit/5d5158169f75c50f15588c10e07af2e25f950c23))
 - **FIX**(device_info_plus): return type of isPhysicalDevice as boolean for ios ([#2508](https://github.com/fluttercommunity/plus_plugins/issues/2508)). ([e3a983bb](https://github.com/fluttercommunity/plus_plugins/commit/e3a983bbf0b0bb70c7c50835ddb7f3c4a46b7122))
 - **FIX**(device_info_plus): Add iOS Privacy Info ([#2582](https://github.com/fluttercommunity/plus_plugins/issues/2582)). ([34fe31eb](https://github.com/fluttercommunity/plus_plugins/commit/34fe31eb29e21fa9ea336e61d8df6858eb441a00))
 - **FEAT**(device_info_plus): Update min iOS target to 12 ([#2658](https://github.com/fluttercommunity/plus_plugins/issues/2658)). ([a3436100](https://github.com/fluttercommunity/plus_plugins/commit/a3436100fabd04a4d4db7ac09128b5b5962579d3))
 - **FEAT**(device_info_plus): LinuxDeviceInfo toString method ([#2652](https://github.com/fluttercommunity/plus_plugins/issues/2652)). ([f2fbcdb8](https://github.com/fluttercommunity/plus_plugins/commit/f2fbcdb813b62dcb76c18b00e51383e6643a93ed))

## 10.0.0

> Note: This release was retracted due to ([#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251)).

## 9.1.2

 - **FIX**(device_info_plus): fix crash on non-standard Digital Product IDs ([#2537](https://github.com/fluttercommunity/plus_plugins/issues/2537)). ([7b318b5c](https://github.com/fluttercommunity/plus_plugins/commit/7b318b5cd8496cf7d31c62314eb9bae17f9ef8d6))

## 9.1.1

 - **FIX**(device_info_plus): Fix deprecation warning on MacOS ([#2377](https://github.com/fluttercommunity/plus_plugins/issues/2377)). ([56a6d0ff](https://github.com/fluttercommunity/plus_plugins/commit/56a6d0ff3752570de89f00876eb7181d662a0465))

## 9.1.0

> Info: This release is a replacement for release 10.0.0, which was retracted due to issue ([#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251)). As breaking change was reverted the major release was also reverted in favor of this one.

 - **FIX**(device_info_plus): Change Kotlin version from 1.9.10 to 1.7.22 ([#2256](https://github.com/fluttercommunity/plus_plugins/issues/2256)). ([313ec2c3](https://github.com/fluttercommunity/plus_plugins/commit/313ec2c328f34b278f197ee1f2d896f8820ac789))
 - **FIX**(device_info_plus): Revert bump compileSDK to 34 ([#2230](https://github.com/fluttercommunity/plus_plugins/issues/2230)). ([2ba5b054](https://github.com/fluttercommunity/plus_plugins/commit/2ba5b054948f48a9aae72c8a63b39f6536ab678d))
 - **FIX**(device_info_plus): Update exports to avoid web compatibility issues ([#2028](https://github.com/fluttercommunity/plus_plugins/issues/2028)). ([6c216053](https://github.com/fluttercommunity/plus_plugins/commit/6c2160537dc51493adc5bf22cd480a52582845b0))
 - **FIX**(device_info_plus): Regenerate iOS and MacOS example apps ([#1868](https://github.com/fluttercommunity/plus_plugins/issues/1868)). ([6e1111ac](https://github.com/fluttercommunity/plus_plugins/commit/6e1111acff40fef6f77fe2561810d679bafe938c))
 - **FEAT**(device_info_plus): Remove deprecated VALID_ARCHS iOS property ([#2022](https://github.com/fluttercommunity/plus_plugins/issues/2022)). ([13053295](https://github.com/fluttercommunity/plus_plugins/commit/13053295137201b34a6bf52e494ccf77e0321b18))
 - **DOCS**(device_info_plus): Add note about arch returned value on MacOS ([#2220](https://github.com/fluttercommunity/plus_plugins/issues/2220)). ([80409e2a](https://github.com/fluttercommunity/plus_plugins/commit/80409e2ab13a6379b9101034ad453517151a719a))
 - **DOCS**(all): Fix example links on pub.dev ([#1863](https://github.com/fluttercommunity/plus_plugins/issues/1863)). ([d726035a](https://github.com/fluttercommunity/plus_plugins/commit/d726035ad7631d5a1397d0a2e5df23dc7e30a4f7))

## 9.0.3

 - **FIX**(device_info_plus): Regenerate iOS and MacOS example apps ([#1868](https://github.com/fluttercommunity/plus_plugins/issues/1868)). ([6e1111ac](https://github.com/fluttercommunity/plus_plugins/commit/6e1111acff40fef6f77fe2561810d679bafe938c))
 - **DOCS**(all): Fix example links on pub.dev ([#1863](https://github.com/fluttercommunity/plus_plugins/issues/1863)). ([d726035a](https://github.com/fluttercommunity/plus_plugins/commit/d726035ad7631d5a1397d0a2e5df23dc7e30a4f7))

## 9.0.2

 - **DOCS**(device_info_plus): Add links to Android and iOS docs to every field ([#1857](https://github.com/fluttercommunity/plus_plugins/issues/1857)). ([89eb5217](https://github.com/fluttercommunity/plus_plugins/commit/89eb52177c90d5453ba512e73472536fc8a03c9a))

## 9.0.1

 - **FIX**: Add jvm target compatibility to Kotlin plugins ([#1798](https://github.com/fluttercommunity/plus_plugins/issues/1798)). ([1b7dc432](https://github.com/fluttercommunity/plus_plugins/commit/1b7dc432ffb8d0474c9be6339d20b5a2cbcbab3f))
 - **DOCS**(all): Update READMEs ([#1828](https://github.com/fluttercommunity/plus_plugins/issues/1828)). ([57d9c884](https://github.com/fluttercommunity/plus_plugins/commit/57d9c8845edfc81fdbabcef9eb1d1ca450e62e7d))
 - **CHORE**(device_info_plus): Win32 dependency upgrade ([#1805](https://github.com/fluttercommunity/plus_plugins/pull/1805)). ([3f68800](https://github.com/fluttercommunity/plus_plugins/commit/c8f7b6342a7c51eafafae95792775505d2b52ce9))

## 9.0.0

> Note: This release has breaking changes.

 - **CHORE**(device_info_plus): Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0
 - **BREAKING** **FIX**(all): Add support of namespace property to support Android Gradle Plugin (AGP) 8 (#1727). Projects with AGP < 4.2 are not supported anymore. It is highly recommended to update at least to AGP 7.0 or newer.
 - **BREAKING** **CHORE**(device_info_plus): Bump min Android to 4.4 (API 19) and iOS to 11, update podspec file (#1781).
 - **REFACTOR**(device_info_plus): Refactor Windows implementation (#1772).
 - **REFACTOR**(device_info_plus): Remove redundant checks for PRODUCT strings with sdk (#1745).
 - **REFACTOR**(device_info_plus): Declare proper nullability for iOS properties (#1728).

## 8.2.2

 - **FIX**(all): Revert addition of namespace to avoid build fails on old AGPs (#1725).

## 8.2.1

 - **FIX**(device_info_plus): Add compatibility with AGP 8 (Android Gradle Plugin) (#1702).

## 8.2.0

 - **REFACTOR**(all): Remove all manual dependency_overrides (#1628).
 - **FEAT**(device_info_plus): add major, minor and patch versions to macos (#1649).

## 8.1.0

 - **FEAT**: Add serialNumber property to AndroidDeviceInfo (#1349).
 - **DOCS**: Updates for READMEs and website pages (#1389).
 - **DOCS**: Explain how to get serial number on Android (#1390).
 - **DOCS**: Add info about iOS 16 changes to device name (#1356).

## 8.0.0

> Note: This release has breaking changes.

 - **DOCS**: Document toMap deprecation (#1292).
 - **BREAKING** **FEAT**: refactor of device_info_plus platform implementation (#1293).

## 7.0.1

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 7.0.0

> Note: This release has breaking changes.

 - **REFACTOR**: Migrate Android part to Kotlin, update Android dependencies (#1245).
 - **FIX**: add `@Deprecated` annotation to `toMap` method (#1142).
 - **DOCS**: Add info about Android properties availability, update API docs links (#1243).
 - **BREAKING** **REFACTOR**: two-package federated architecture (#1228).

## 6.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: Add support of Android display metrics (#829).

## 5.0.5

 - Update a dependency to the latest release.

## 5.0.4

 - **FIX**: fixed wrong dependency version #1175.

## 5.0.3

 - **FIX**: fix version dependency.

## 5.0.2

 - **CHORE**: Version tagging using melos.

## 5.0.1

- Fixing federated plugin architecture versions.

## 5.0.0

- Re-introduce: Added more information to `WindowsDeviceInfo`.
- device_info_plus_platform_interface to 4.0.0

## 4.1.3

- Detects iOS simulator device id instead of simulator's underlying architecture.

## 4.1.2

- Redo changes in 4.1.0
- device_info_plus_platform_interface to 3.0.0

## 4.1.1

- Revert changes in 4.1.0

## 4.1.0

- Remove `androidId` (that already got removed from the method channel in 4.0.0, thus always returned null)
- There is a **new, separate [pub.dev package](https://pub.dev/packages/android_id) for getting the correct `androidId`**

## 4.0.3

- Reverted changes in 4.0.2

## 4.0.2

- Added more information to `WindowsDeviceInfo`.

## 4.0.1

- Update dependencies

## 4.0.0

- **Breaking change** Remove `AndroidId` getter to avoid Google Play policies violations
- Update flutter_lints to 2.0.1
- Remove explicit `test` dependency to use `flutter_test` from Flutter SDK

## 3.2.4

- Update the description of getAndroidId method

## 3.2.3

- Fix crash on macOS running on Apple M1

## 3.2.2

- Fix embedding issue in example
- Update Android dependencies in example

## 3.2.1

- iOS: fix `identifierForVendor` (can be `null` in rare circumstances)
- Use automatic plugin registration on Linux and Windows
- Fix warnings when building for macOS

## 3.2.0

- add `deviceInfo`

## 3.1.1

- add toMap to WebBrowserInfo

## 3.1.0

- add System GUID to MacOS

## 3.0.1

- Upgrade Android compile SDK version
- Several code improvements

## 3.0.0

- Remove deprecated method `registerWith` (of Android v1 embedding)

## 2.2.0

- migrate integration_test to flutter sdk

## 2.1.0

- add toMap to models

## 2.0.1

- Android: migrate to mavenCentral

## 2.0.0

- WebBrowserInfo properties are now nullable

## 1.0.1

- Improve documentation

## 1.0.0

- Migrated to null safety
- Update dependencies.

## 0.7.2

- Update dependencies.

## 0.7.1

- Fix macOS support.

## 0.7.0

- Add macOS support via `device_info_plus_macos`.

## 0.6.0

- Rename method channel to avoid conflicts.

## 0.5.0

- Transfer to plus-plugins monorepo

## 0.4.2+8

- Transfer package to Flutter Community under new name `device_info_plus`.

## 0.4.2+7

- Port device_info plugin to use platform interface.

## 0.4.2+6

- Moved everything from device_info to device_info/device_info

## 0.4.2+5

- Update package:e2e reference to use the local version in the flutter/plugins
  repository.

## 0.4.2+4

Update lower bound of dart dependency to 2.1.0.

## 0.4.2+3

- Declare API stability and compatibility with `1.0.0` (more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0).

## 0.4.2+2

- Fix CocoaPods podspec lint warnings.

## 0.4.2+1

- Bump the minimum Flutter version to 1.12.13+hotfix.5.
- Remove deprecated API usage warning in AndroidIntentPlugin.java.
- Migrates the Android example to V2 embedding.
- Bumps AGP to 3.6.1.

## 0.4.2

- Add systemFeatures to AndroidDeviceInfo.

## 0.4.1+5

- Make the pedantic dev_dependency explicit.

## 0.4.1+4

- Remove the deprecated `author:` field from pubspec.yaml
- Migrate the plugin to the pubspec platforms manifest.
- Require Flutter SDK 1.10.0 or greater.

## 0.4.1+3

- Fix pedantic errors. Adds some missing documentation and fixes unawaited
  futures in the tests.

## 0.4.1+2

- Remove AndroidX warning.

## 0.4.1+1

- Include lifecycle dependency as a compileOnly one on Android to resolve
  potential version conflicts with other transitive libraries.

## 0.4.1

- Support the v2 Android embedding.
- Update to AndroidX.
- Migrate to using the new e2e test binding.
- Add a e2e test.

## 0.4.0+4

- Define clang module for iOS.

## 0.4.0+3

- Update and migrate iOS example project.

## 0.4.0+2

- Bump minimum Flutter version to 1.5.0.
- Add missing template type parameter to `invokeMethod` calls.
- Replace invokeMethod with invokeMapMethod wherever necessary.

## 0.4.0+1

- Log a more detailed warning at build time about the previous AndroidX
  migration.

## 0.4.0

- **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 0.3.0

- Added ability to get Android ID for Android devices

## 0.2.1

- Updated Gradle tooling to match Android Studio 3.1.2.

## 0.2.0

- **Breaking change**. Set SDK constraints to match the Flutter beta release.

## 0.1.2

- Fixed Dart 2 type errors.

## 0.1.1

- Simplified and upgraded Android project template to Android SDK 27.
- Updated package description.

## 0.1.0

- **Breaking change**. Upgraded to Gradle 4.1 and Android Studio Gradle plugin
  3.0.1. Older Flutter projects need to upgrade their Gradle setup as well in
  order to use this version of the plugin. Instructions can be found
  [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).

## 0.0.5

- Added FLT prefix to iOS types

## 0.0.4

- Fixed Java/Dart communication error with empty lists

## 0.0.3

- Added support for utsname

## 0.0.2

- Fixed broken type comparison
- Added "isPhysicalDevice" field, detecting emulators/simulators

## 0.0.1

- Implements platform-specific device/OS properties
