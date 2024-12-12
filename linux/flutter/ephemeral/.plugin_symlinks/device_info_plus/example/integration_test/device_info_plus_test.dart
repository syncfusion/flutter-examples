// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late IosDeviceInfo iosInfo;
  late AndroidDeviceInfo androidInfo;
  late WebBrowserInfo webBrowserInfo;
  late WindowsDeviceInfo windowsInfo;
  late LinuxDeviceInfo linuxInfo;
  late MacOsDeviceInfo macosInfo;
  late BaseDeviceInfo deviceInfo;

  setUpAll(() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (kIsWeb) {
      webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
    } else {
      if (Platform.isIOS) {
        iosInfo = await deviceInfoPlugin.iosInfo;
      } else if (Platform.isAndroid) {
        androidInfo = await deviceInfoPlugin.androidInfo;
      } else if (Platform.isWindows) {
        windowsInfo = await deviceInfoPlugin.windowsInfo;
      } else if (Platform.isLinux) {
        linuxInfo = await deviceInfoPlugin.linuxInfo;
      } else if (Platform.isMacOS) {
        macosInfo = await deviceInfoPlugin.macOsInfo;
      }
    }

    deviceInfo = await deviceInfoPlugin.deviceInfo;
  });

  testWidgets('Can get non-null device model', (WidgetTester tester) async {
    if (kIsWeb) {
      expect(webBrowserInfo.userAgent, isNotNull);
      expect(deviceInfo, same(webBrowserInfo));
    } else {
      if (Platform.isIOS) {
        expect(iosInfo.model, isNotNull);
        expect(deviceInfo, same(iosInfo));
      } else if (Platform.isAndroid) {
        expect(androidInfo.model, isNotNull);
        expect(deviceInfo, same(androidInfo));
      } else if (Platform.isWindows) {
        expect(windowsInfo.computerName, isNotNull);
        expect(deviceInfo, same(windowsInfo));
      } else if (Platform.isLinux) {
        expect(linuxInfo.name, isNotNull);
        expect(deviceInfo, same(linuxInfo));
      } else if (Platform.isMacOS) {
        expect(macosInfo.computerName, isNotNull);
        expect(deviceInfo, same(macosInfo));
      }
    }
  });

  testWidgets('Can get non-null iOS utsname fields',
      (WidgetTester tester) async {
    expect(iosInfo.utsname.machine, 'iPhone15,4');
    expect(iosInfo.utsname.nodename, isNotNull);
    expect(iosInfo.utsname.release, isNotNull);
    expect(iosInfo.utsname.sysname, isNotNull);
    expect(iosInfo.utsname.version, isNotNull);
  }, skip: !Platform.isIOS);

  testWidgets('Check all android info values are available',
      (WidgetTester tester) async {
    if (androidInfo.version.sdkInt >= 23) {
      expect(androidInfo.version.baseOS, isNotNull);
      expect(androidInfo.version.previewSdkInt, isNotNull);
      expect(androidInfo.version.securityPatch, isNotNull);
    }

    expect(androidInfo.version.codename, isNotNull);
    expect(androidInfo.version.incremental, isNotNull);
    expect(androidInfo.version.release, isNotNull);
    expect(androidInfo.version.sdkInt, isNotNull);
    expect(androidInfo.board, isNotNull);
    expect(androidInfo.bootloader, isNotNull);
    expect(androidInfo.brand, isNotNull);
    expect(androidInfo.device, isNotNull);
    expect(androidInfo.display, isNotNull);
    expect(androidInfo.fingerprint, isNotNull);
    expect(androidInfo.hardware, isNotNull);

    expect(androidInfo.host, isNotNull);
    expect(androidInfo.id, isNotNull);
    expect(androidInfo.manufacturer, isNotNull);
    expect(androidInfo.model, isNotNull);
    expect(androidInfo.product, isNotNull);

    expect(androidInfo.supported32BitAbis, isNotNull);
    expect(androidInfo.supported64BitAbis, isNotNull);
    expect(androidInfo.supportedAbis, isNotNull);

    expect(androidInfo.tags, isNotNull);
    expect(androidInfo.type, isNotNull);
    expect(androidInfo.isPhysicalDevice, isNotNull);
    expect(androidInfo.systemFeatures, isNotNull);
    expect(androidInfo.serialNumber, isNotNull);
  }, skip: !Platform.isAndroid);

  testWidgets('Check all macos info values are available',
      ((WidgetTester tester) async {
    expect(macosInfo.computerName, isNotNull);
    expect(macosInfo.hostName, isNotNull);
    expect(macosInfo.arch, isNotNull);
    expect(macosInfo.model, isNotNull);
    expect(macosInfo.kernelVersion, isNotNull);
    expect(macosInfo.osRelease, isNotNull);
    expect(macosInfo.activeCPUs, isNotNull);
    expect(macosInfo.memorySize, isNotNull);
    expect(macosInfo.cpuFrequency, isNotNull);
    expect(macosInfo.systemGUID, isNotNull);
  }), skip: !Platform.isMacOS);

  testWidgets('Check all Linux info values are available',
      ((WidgetTester tester) async {
    expect(linuxInfo.name, isNotNull);
    expect(linuxInfo.version, isNotNull);
    expect(linuxInfo.id, isNotNull);
    expect(linuxInfo.idLike, isNotNull);
    expect(linuxInfo.versionCodename, isNotNull);
    expect(linuxInfo.versionId, isNotNull);
    expect(linuxInfo.prettyName, isNotNull);
    expect(linuxInfo.buildId, isNull);
    expect(linuxInfo.variant, isNull);
    expect(linuxInfo.variantId, isNull);
  }), skip: !Platform.isLinux);

  testWidgets('Check all Windows info values are available',
      ((WidgetTester tester) async {
    expect(
      windowsInfo.numberOfCores,
      isPositive,
    );
    expect(
      windowsInfo.computerName,
      isNotEmpty,
    );
    expect(
      windowsInfo.systemMemoryInMegabytes,
      isPositive,
    );
    expect(
      windowsInfo.userName,
      isNotEmpty,
    );
    expect(
      windowsInfo.majorVersion,
      equals(10),
    );
    expect(
      windowsInfo.minorVersion,
      equals(0),
    );
    expect(
      windowsInfo.buildNumber,
      greaterThan(10240),
    );
    expect(
      windowsInfo.platformId,
      equals(2),
    );
    expect(
      windowsInfo.reserved,
      isZero,
    );
    expect(
      windowsInfo.buildLab,
      isNotEmpty,
    );
    expect(
      windowsInfo.buildLab,
      startsWith(
        windowsInfo.buildNumber.toString(),
      ),
    );
    expect(
      windowsInfo.buildLabEx,
      isNotEmpty,
    );
    expect(
      windowsInfo.buildLab,
      startsWith(windowsInfo.buildNumber.toString()),
    );
    expect(
      windowsInfo.digitalProductId,
      isNotEmpty,
    );
    expect(
      windowsInfo.editionId,
      isNotEmpty,
    );
    expect(
      windowsInfo.productId,
      isNotEmpty,
    );
    expect(
      RegExp(r'^([A-Z0-9]{5}-){4}[A-Z0-9]{5}$')
              .hasMatch(windowsInfo.productId) ||
          RegExp(r'^([A-Z0-9]{5}-){3}[A-Z0-9]{5}$')
              .hasMatch(windowsInfo.productId),
      isTrue,
    );
    expect(
      windowsInfo.productName,
      isNotEmpty,
    );
    expect(
      windowsInfo.productName,
      startsWith('Windows'),
    );
    expect(
      windowsInfo.releaseId,
      isNotEmpty,
    );
    expect(
      windowsInfo.deviceId,
      isNotEmpty,
    );
  }), skip: !Platform.isWindows);
}
