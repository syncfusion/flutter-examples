import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;

class FileSaveHelper {
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    js.context['pdfdata'] = base64.encode(bytes);
    js.context['filename'] = fileName;
    Timer.run(() {
      js.context.callMethod('download');
    });
  }
}
