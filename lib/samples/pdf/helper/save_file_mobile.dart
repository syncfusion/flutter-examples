///Dart import
import 'dart:io';

///Package imports
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

///To save the pdf file in the device
class FileSaveHelper {
  static const MethodChannel _platformCall = MethodChannel('launchFile');

  ///To save the pdf file in the device
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    final Map<String, String> argument = <String, String>{
      'file_path': '$path/$fileName'
    };
    try {
      //ignore: unused_local_variable
      final Future<Map<String, String>> result =
          _platformCall.invokeMethod('viewPdf', argument);
    } catch (e) {
      throw Exception(e);
    }
  }
}
