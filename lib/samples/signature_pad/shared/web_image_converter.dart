import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:web/web.dart' as web;

// ignore: avoid_classes_with_only_static_members
/// Convert to image format.
class ImageConverter {
  /// toImage
  static Future<Uint8List> toImage({
    required RenderSignaturePad renderSignaturePad,
  }) async {
    final int signaturePadWidth = renderSignaturePad.size.width.toInt();
    final int signaturePadHeight = renderSignaturePad.size.height.toInt();
    final web.HTMLCanvasElement canvas = web.HTMLCanvasElement()
      ..width = signaturePadWidth
      ..height = signaturePadHeight;

    final web.CanvasRenderingContext2D context = canvas.context2D;
    renderSignaturePad.renderToContext2D(context);

    final imageData = canvas.context2D
        .getImageData(0, 0, signaturePadWidth, signaturePadHeight)
        .data
        .toDart
        .buffer
        .asUint8List();

    final imageDescriptor = ui.ImageDescriptor.raw(
      await ui.ImmutableBuffer.fromUint8List(imageData),
      width: signaturePadWidth,
      height: signaturePadHeight,
      pixelFormat: ui.PixelFormat.rgba8888,
    );

    final codec = await imageDescriptor.instantiateCodec();
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
