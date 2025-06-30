/// Dart import
import 'dart:async';
import 'dart:io';
import 'dart:ui' as dart_ui;

/// Package imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../../pdf/helper/save_file_mobile.dart'
    if (dart.library.js_interop) '../../pdf/helper/save_file_web.dart';

///Renders default column chart sample
class Export extends SampleView {
  ///Renders default column chart sample
  const Export(Key key) : super(key: key);

  @override
  _ExportState createState() => _ExportState();
}

class _ExportState extends SampleViewState {
  _ExportState();
  late GlobalKey<SfCartesianChartState> _chartKey;
  // ScaffoldState _scaffoldState;

  late GlobalKey<ScaffoldState> scaffoldKey;
  late List<ChartSampleData> chartData;

  @override
  void initState() {
    _chartKey = GlobalKey();
    scaffoldKey = GlobalKey<ScaffoldState>();
    chartData = <ChartSampleData>[
      ChartSampleData(x: "Jan '19", y: 184.9, yValue: 17),
      ChartSampleData(x: "Feb '19", y: 160.3, yValue: 18),
      ChartSampleData(x: "Mar '19", y: 70.6, yValue: 13),
      ChartSampleData(x: "Apr '19", y: 201.4, yValue: 17),
      ChartSampleData(x: "May '19", y: 86.7, yValue: 15),
      ChartSampleData(x: "Jun '19", y: 151.5, yValue: 23),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(child: _buildDefaultColumnChart()),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          duration: Duration(milliseconds: 100),
                          content: Text('Chart has been exported as PNG image'),
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
                            'Chart is being exported as PDF document',
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

  @override
  void dispose() {
    chartData.clear();
    super.dispose();
  }

  /// Get default column chart
  SfCartesianChart _buildDefaultColumnChart() {
    return SfCartesianChart(
      legend: const Legend(isVisible: true),
      key: _chartKey,
      plotAreaBackgroundColor: model.sampleOutputCardColor,
      backgroundColor: model.sampleOutputCardColor,
      plotAreaBorderWidth: 0,
      plotAreaBorderColor: Colors.grey.withValues(alpha: 0.7),
      title: const ChartTitle(
        text: 'Average rainfall amount (mm) and rainy days',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: 0,
        maximum: 250,
        interval: 50,
      ),
      axes: const <ChartAxis>[
        NumericAxis(
          name: 'YAxis',
          opposedPosition: true,
          majorGridLines: MajorGridLines(width: 0),
          minimum: 0,
          maximum: 30,
          interval: 5,
        ),
      ],
      series: _getDefaultColumnSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Get default column series
  List<CartesianSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    return <CartesianSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        name: 'Rainy days',
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        yAxisName: 'YAxis',
      ),
      LineSeries<ChartSampleData, String>(
        name: 'Rainfall amount',
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  Future<void> _renderImage() async {
    final List<int> bytes = await _readImageData();
    if (bytes != null) {
      final Directory documentDirectory =
          await getApplicationDocumentsDirectory();
      final String path = documentDirectory.path;
      const String imageName = 'cartesianchart.png';
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
        content: Text('Chart has been exported as PDF document.'),
      ),
    );
    final List<int> bytes = document.saveSync();
    document.dispose();
    await FileSaveHelper.saveAndLaunchFile(bytes, 'cartesian_chart.pdf');
  }

  Future<List<int>> _readImageData() async {
    final dart_ui.Image? data = await _chartKey.currentState!.toImage(
      pixelRatio: 3.0,
    );
    final ByteData? bytes = await data?.toByteData(
      format: dart_ui.ImageByteFormat.png,
    );
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
