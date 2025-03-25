///Dart imports
import 'dart:async';
import 'dart:convert';
import 'package:web/web.dart';

// ignore: avoid_classes_with_only_static_members
///To save the Excel file in the device
class FileSaveHelper {
  ///To save the Excel file in the device
  static Future<void> saveAndLaunchFile(
    List<int> bytes,
    String fileName,
  ) async {
    HTMLAnchorElement()
      ..href =
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}'
      ..setAttribute('download', fileName)
      ..click();
  }
}
