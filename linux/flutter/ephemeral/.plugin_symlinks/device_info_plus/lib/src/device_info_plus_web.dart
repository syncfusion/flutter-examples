import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as html show window, Navigator;

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'model/web_browser_info.dart';

/// The web implementation of the BatteryPlusPlatform of the BatteryPlus plugin.
class DeviceInfoPlusWebPlugin extends DeviceInfoPlatform {
  /// Constructs a DeviceInfoPlusPlugin.
  DeviceInfoPlusWebPlugin(navigator) : _navigator = navigator;

  final html.Navigator _navigator;

  /// Factory method that initializes the DeviceInfoPlus plugin platform
  /// with an instance of the plugin for the web.
  static void registerWith(Registrar registrar) {
    DeviceInfoPlatform.instance = DeviceInfoPlusWebPlugin(
      html.window.navigator,
    );
  }

  @override
  Future<BaseDeviceInfo> deviceInfo() {
    return Future<WebBrowserInfo>.value(
      WebBrowserInfo.fromMap({
        'appCodeName': _navigator.appCodeName,
        'appName': _navigator.appName,
        'appVersion': _navigator.appVersion,
        'deviceMemory': _navigator.safeDeviceMemory,
        'language': _navigator.language,
        'languages': _navigator.languages.toDart,
        'platform': _navigator.platform,
        'product': _navigator.product,
        'productSub': _navigator.productSub,
        'userAgent': _navigator.userAgent,
        'vendor': _navigator.vendor,
        'vendorSub': _navigator.vendorSub,
        'hardwareConcurrency': _navigator.hardwareConcurrency,
        'maxTouchPoints': _navigator.maxTouchPoints,
      }),
    );
  }
}

/// Some Navigator properties are not fully supported in all browsers.
/// However, package:web does not provide a safe way to access these properties,
/// and assumes they are always not null.
///
/// This extension provides a safe way to access these properties.
///
/// See: https://github.com/dart-lang/web/issues/326
///      https://github.com/fluttercommunity/plus_plugins/issues/3391
extension SafeNavigationGetterExtensions on html.Navigator {
  @JS('deviceMemory')
  external double? get safeDeviceMemory;
}
