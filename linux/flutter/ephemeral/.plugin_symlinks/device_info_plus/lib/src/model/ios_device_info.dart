// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:device_info_plus_platform_interface/model/base_device_info.dart';
import 'package:meta/meta.dart';

/// Information derived from `UIDevice`.
///
/// See: https://developer.apple.com/documentation/uikit/uidevice
class IosDeviceInfo extends BaseDeviceInfo {
  /// IOS device info class.
  IosDeviceInfo._({
    required Map<String, dynamic> data,
    required this.name,
    required this.systemName,
    required this.systemVersion,
    required this.model,
    required this.modelName,
    required this.localizedModel,
    required this.freeDiskSize,
    required this.totalDiskSize,
    this.identifierForVendor,
    required this.isPhysicalDevice,
    required this.physicalRamSize,
    required this.availableRamSize,
    required this.isiOSAppOnMac,
    required this.utsname,
  }) : super(data);

  /// Device name.
  ///
  /// On iOS < 16 returns user-assigned device name
  /// On iOS >= 16 returns a generic device name if project has
  /// no entitlement to get user-assigned device name.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620015-name
  final String name;

  /// The name of the current operating system.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620054-systemname
  final String systemName;

  /// The current operating system version.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620043-systemversion
  final String systemVersion;

  /// Device model according to OS
  /// https://developer.apple.com/documentation/uikit/uidevice/1620044-model
  final String model;

  /// Commercial or user-known model name
  /// Examples: `iPhone 16 Pro`, `iPad Pro 11-Inch 3`
  final String modelName;

  /// Localized name of the device model.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620029-localizedmodel
  final String localizedModel;

  /// Unique UUID value identifying the current device.
  /// https://developer.apple.com/documentation/uikit/uidevice/1620059-identifierforvendor
  final String? identifierForVendor;

  /// `false` if the application is running in a simulator, `true` otherwise.
  final bool isPhysicalDevice;

  /// Total physical RAM size of the device in megabytes
  final int physicalRamSize;

  /// Current unallocated RAM size of the device in megabytes
  final int availableRamSize;

  /// that indicates whether the process is an iPhone or iPad app running on a Mac.
  /// https://developer.apple.com/documentation/foundation/nsprocessinfo/3608556-iosapponmac
  final bool isiOSAppOnMac;

  /// Operating system information derived from `sys/utsname.h`.
  final IosUtsname utsname;

  /// Free disk size in bytes
  final int freeDiskSize;

  /// Total disk size in bytes
  final int totalDiskSize;

  /// Deserializes from the map message received from [_kChannel].
  static IosDeviceInfo fromMap(Map<String, dynamic> map) {
    return IosDeviceInfo._(
      data: map,
      name: map['name'],
      systemName: map['systemName'],
      systemVersion: map['systemVersion'],
      model: map['model'],
      modelName: map['modelName'],
      localizedModel: map['localizedModel'],
      identifierForVendor: map['identifierForVendor'],
      freeDiskSize: map['freeDiskSize'],
      totalDiskSize: map['totalDiskSize'],
      isPhysicalDevice: map['isPhysicalDevice'],
      physicalRamSize: map['physicalRamSize'],
      availableRamSize: map['availableRamSize'],
      isiOSAppOnMac: map['isiOSAppOnMac'],
      utsname: IosUtsname._fromMap(
        map['utsname']?.cast<String, dynamic>() ?? {},
      ),
    );
  }

  /// Initializes the application metadata with mock values for testing.
  @visibleForTesting
  static IosDeviceInfo setMockInitialValues({
    required String name,
    required String systemName,
    required String systemVersion,
    required String model,
    required String modelName,
    required String localizedModel,
    required int freeDiskSize,
    required int totalDiskSize,
    String? identifierForVendor,
    required bool isPhysicalDevice,
    required bool isiOSAppOnMac,
    required int physicalRamSize,
    required int availableRamSize,
    required IosUtsname utsname,
  }) {
    final Map<String, dynamic> data = {
      'name': name,
      'systemName': systemName,
      'systemVersion': systemVersion,
      'model': model,
      'modelName': modelName,
      'localizedModel': localizedModel,
      'identifierForVendor': identifierForVendor,
      'freeDiskSize': freeDiskSize,
      'totalDiskSize': totalDiskSize,
      'isPhysicalDevice': isPhysicalDevice,
      'isiOSAppOnMac': isiOSAppOnMac,
      'physicalRamSize': physicalRamSize,
      'availableRamSize': availableRamSize,
      'utsname': {
        'sysname': utsname.sysname,
        'nodename': utsname.nodename,
        'release': utsname.release,
        'version': utsname.version,
        'machine': utsname.machine,
      },
    };
    return IosDeviceInfo._(
      data: data,
      name: name,
      systemName: systemName,
      systemVersion: systemVersion,
      model: model,
      modelName: modelName,
      localizedModel: localizedModel,
      identifierForVendor: identifierForVendor,
      freeDiskSize: freeDiskSize,
      totalDiskSize: totalDiskSize,
      isPhysicalDevice: isPhysicalDevice,
      isiOSAppOnMac: isiOSAppOnMac,
      physicalRamSize: physicalRamSize,
      availableRamSize: availableRamSize,
      utsname: utsname,
    );
  }
}

/// Information derived from `utsname`.
/// See http://pubs.opengroup.org/onlinepubs/7908799/xsh/sysutsname.h.html for details.
class IosUtsname {
  const IosUtsname._({
    required this.sysname,
    required this.nodename,
    required this.release,
    required this.version,
    required this.machine,
  });

  /// Operating system name.
  final String sysname;

  /// Network node name.
  final String nodename;

  /// Release level.
  final String release;

  /// Version level.
  final String version;

  /// Hardware type (e.g. 'iPhone7,1' for iPhone 6 Plus).
  final String machine;

  /// Deserializes from the map message received from [_kChannel].
  static IosUtsname _fromMap(Map<String, dynamic> map) {
    return IosUtsname._(
      sysname: map['sysname'],
      nodename: map['nodename'],
      release: map['release'],
      version: map['version'],
      machine: map['machine'],
    );
  }

  /// Initializes the application metadata with mock values for testing.
  @visibleForTesting
  static IosUtsname setMockInitialValues({
    required String sysname,
    required String nodename,
    required String release,
    required String version,
    required String machine,
  }) {
    return IosUtsname._(
      sysname: sysname,
      nodename: nodename,
      release: release,
      version: version,
      machine: machine,
    );
  }
}
