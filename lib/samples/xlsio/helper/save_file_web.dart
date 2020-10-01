///Dart imports
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

///To save the Excel file in the device
class FileSaveHelper {
  ///To save the Excel file in the device
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    js.context['exceldata'] = base64.encode(bytes);
    js.context['filename'] = fileName;
    Timer.run(() {
      js.context.callMethod('downloadExcel');
    });
  }
}
