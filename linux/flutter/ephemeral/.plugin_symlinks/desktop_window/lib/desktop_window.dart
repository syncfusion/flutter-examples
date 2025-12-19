import 'dart:async';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class DesktopWindow {
  static const MethodChannel _channel = const MethodChannel('desktop_window');

  static Future<Size> getWindowSize() async {
    final arr = await _channel.invokeMethod('getWindowSize');
    if (arr is List && arr.length == 2) {
      return Size(arr[0], arr[1]);
    }
    throw arr;
  }

  static Future<void> setWindowSize(Size size, {bool animate = false}) async {
    return await _channel.invokeMethod('setWindowSize',
        {'width': size.width, 'height': size.height, 'animate': animate});
  }

  static Future<void> setMinWindowSize(Size size) async {
    return await _channel.invokeMethod(
        'setMinWindowSize', {'width': size.width, 'height': size.height});
  }

  static Future<void> setMaxWindowSize(Size size) async {
    return await _channel.invokeMethod(
        'setMaxWindowSize', {'width': size.width, 'height': size.height});
  }

  static Future<void> resetMaxWindowSize() async {
    return await _channel.invokeMethod('resetMaxWindowSize');
  }

  static Future<void> toggleFullScreen() async {
    return await _channel.invokeMethod('toggleFullScreen');
  }

  static Future<void> setFullScreen(bool fullscreen) async {
    return await _channel
        .invokeMethod('setFullScreen', {'fullscreen': fullscreen});
  }

  static Future<bool> getFullScreen() async {
    final fullscreen = await _channel.invokeMethod('getFullScreen');
    if (fullscreen is bool) return fullscreen;
    throw fullscreen;
  }

  static Future<bool> get hasBorders async {
    final hasBorders = await _channel.invokeMethod('hasBorders');
    if (hasBorders is bool) return hasBorders;
    throw hasBorders;
  }

  static Future<void> toggleBorders() async {
    return await _channel.invokeMethod('toggleBorders');
  }

  static Future<void> setBorders(bool border) async {
    return await _channel.invokeMethod('setBorders', {'border': border});
  }

  static Future<void> stayOnTop(
      [bool stayOnTop = true, bool throwOnUnsupportedPlatform = false]) async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS))
      return await _channel.invokeMethod('stayOnTop', {'stayOnTop': stayOnTop});
    else if (throwOnUnsupportedPlatform)
      throw UnsupportedError(
          "only Linux and Windows support windows staying focused");
  }

  static Future<void> focus() async {
    return await _channel.invokeMethod('focus');
  }
}
