/// Dart import
import 'dart:async';
import 'dart:io';
import 'dart:ui' as dart_ui;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Chart import
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../pdf/helper/save_file_mobile.dart'
    if (dart.library.js_interop) '../../pdf/helper/save_file_web.dart';

///Renders default column chart sample
class ExportGauge extends SampleView {
  ///Renders default column chart sample
  const ExportGauge(Key key) : super(key: key);

  @override
  _ExportState createState() => _ExportState();
}

class _ExportState extends SampleViewState {
  _ExportState();
  final GlobalKey<SfRadialGaugeState> _key = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(child: _buildTemperatureMonitorExample()),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 4.0),
                        blurRadius: 4.0,
                      ),
                    ],
                    shape: BoxShape.circle,
                    color: model.primaryColor,
                  ),
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(milliseconds: 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          content: Text('Gauge has been exported as PNG image'),
                        ),
                      );
                      _renderImage();
                    },
                    icon: const Icon(Icons.image, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 4.0),
                        blurRadius: 4.0,
                      ),
                    ],
                    shape: BoxShape.circle,
                    color: model.primaryColor,
                  ),
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(milliseconds: 2000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          content: Text(
                            'Gauge is being exported as PDF document.',
                          ),
                        ),
                      );
                      _renderPdf();
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SfRadialGauge _buildTemperatureMonitorExample() {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SfRadialGauge(
      key: _key,
      backgroundColor: model.themeData.brightness == Brightness.light
          ? Colors.white
          : const Color.fromRGBO(33, 33, 33, 1),
      enableLoadingAnimation: true,
      title: GaugeTitle(
        text: isPortrait
            ? '\nHigh and low temperatures of London \nSep ‘20'
            : '\nHigh and low temperatures of London - Sep ‘20',
        textStyle: const TextStyle(
          fontSize: 20.0,
          fontFamily: 'Segoe UI',
          fontStyle: FontStyle.normal,
        ),
      ),
      axes: <RadialAxis>[
        RadialAxis(
          maximum: 30,
          interval: 5,
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          labelOffset: 8,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Added image widget as an annotation
                  Container(
                    width: isPortrait ? 50.00 : 40.00,
                    height: isPortrait ? 50.00 : 40.00,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('images/sun.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      'Temp °C',
                      style: TextStyle(
                        color: model.textColor,
                        fontSize: isPortrait ? 22 : 14,
                      ),
                    ),
                  ),
                ],
              ),
              angle: 270,
              positionFactor: 0.1,
            ),
          ],
          pointers: <GaugePointer>[
            MarkerPointer(
              color: Colors.grey,
              value: 11,
              markerOffset: isPortrait ? -20 : -10,
              markerHeight: 15,
              markerWidth: 15,
            ),
            MarkerPointer(
              color: Colors.orange,
              value: 20,
              markerOffset: isPortrait ? -20 : -10,
              markerHeight: 15,
              markerWidth: 15,
            ),
          ],
          axisLineStyle: AxisLineStyle(
            cornerStyle: CornerStyle.bothCurve,
            gradient: SweepGradient(
              colors: <Color>[Colors.grey.shade200, Colors.orange],
              stops: const <double>[0.25, 0.75],
            ),
            thickness: isPortrait ? 30 : 10,
          ),
        ),
      ],
    );
  }

  Future<void> _renderImage() async {
    final List<int> bytes = await _readImageData();
    if (bytes != null) {
      final Directory documentDirectory =
          await getApplicationDocumentsDirectory();
      final String path = documentDirectory.path;
      const String imageName = 'radialgauge.png';
      imageCache.clear();
      final File file = File('$path/$imageName');
      file.writeAsBytesSync(bytes);
      if (!mounted) {
        return;
      }
      await Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Container(color: Colors.white, child: Image.file(file)),
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> _renderPdf() async {
    final PdfDocument document = PdfDocument();
    final PdfBitmap bitmap = PdfBitmap(await _readImageData());
    if (!mounted) {
      return;
    }
    document.pageSettings.orientation =
        MediaQuery.of(context).orientation == Orientation.landscape
        ? PdfPageOrientation.landscape
        : PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 0;
    document.pageSettings.size = Size(
      bitmap.width.toDouble(),
      bitmap.height.toDouble(),
    );
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawImage(
      bitmap,
      Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        duration: Duration(milliseconds: 200),
        content: Text('Gauge has been exported as PDF document.'),
      ),
    );
    final List<int> bytes = document.saveSync();
    document.dispose();
    await FileSaveHelper.saveAndLaunchFile(bytes, 'radial_gauge.pdf');
  }

  Future<List<int>> _readImageData() async {
    final dart_ui.Image data = await _key.currentState!.toImage(
      pixelRatio: 3.0,
    );
    final ByteData? bytes = await data.toByteData(
      format: dart_ui.ImageByteFormat.png,
    );
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
