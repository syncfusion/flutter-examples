import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

/// Convert to image format.
class ImageConverter {
  /// toImage
  static Future<Uint8List> toImage(
      {RenderSignaturePad renderSignaturePad}) async {
    final canvas = html.CanvasElement(
        width: renderSignaturePad.size.width.toInt(),
        height: renderSignaturePad.size.height.toInt());
    final context = canvas.context2D;
    renderSignaturePad.renderToContext2D(context);
    final blob = await canvas.toBlob('image/jpeg', 1.0);
    final completer = Completer<Uint8List>();
    final reader = html.FileReader();
    reader.readAsArrayBuffer(blob);
    reader.onLoad.listen((_) => completer.complete(reader.result));
    return await completer.future;
  }
}
