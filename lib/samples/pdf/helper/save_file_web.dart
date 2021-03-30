///Dart imports
import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

///To save the pdf file in the device
class FileSaveHelper {
  ///To save the pdf file in the device
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', fileName)
      ..click();
  }
}
