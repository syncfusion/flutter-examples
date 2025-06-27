/// Dart imports.
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Render the customized Bar Chart sample.
class BarCustomization extends SampleView {
  const BarCustomization(Key key) : super(key: key);

  @override
  _BarCustomizationState createState() => _BarCustomizationState();
}

/// Dashed array image renders inside of Bars.
ui.Image? image;

/// Set image loaded info
bool isImageLoaded = false;

/// State class of the customized Bar Chart.
class _BarCustomizationState extends SampleViewState {
  _BarCustomizationState();

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
    );
    _loadImage();
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Facebook', y: 4.119, pointColor: Colors.redAccent),
      ChartSampleData(x: 'FB Messenger', y: 3.408, pointColor: Colors.indigo),
      ChartSampleData(x: 'WhatsApp', y: 2.979, pointColor: Colors.grey),
      ChartSampleData(x: 'Instagram', y: 1.843, pointColor: Colors.orange),
      ChartSampleData(x: 'Skype', y: 1.039, pointColor: Colors.green),
      ChartSampleData(x: 'Subway Surfers', y: 1.025, pointColor: Colors.yellow),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Bar series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Popular Android apps in the Google play store',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Downloads in Billion'),
        minimum: 0,
        maximum: model.isWebFullView ? 4.5 : 5,
        interval: model.isWebFullView ? 0.5 : 1,
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries<ChartSampleData, String>>[
        BarSeries<ChartSampleData, String>(
          dataSource: _chartData,
          xValueMapper: (ChartSampleData sales, int index) => sales.x,
          yValueMapper: (ChartSampleData sales, int index) => sales.y,
          onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
            return _CustomBarSeriesRenderer();
          },
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      tooltipBehavior: _tooltipBehavior,
    );
  }

  void _loadImage() {
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    const ImageProvider imageProvider = AssetImage('images/dashline.png');
    imageProvider
        .resolve(ImageConfiguration.empty)
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) async {
            isImageLoaded = true;
            completer.complete(info);
            final ImageInfo imageInfo = await completer.future;

            image = imageInfo.image;
          }),
        );
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

/// Custom Bar series class that extend the original Bar series
/// to create customized Bar Chart.
class _CustomBarSeriesRenderer<T, D> extends BarSeriesRenderer<T, D> {
  _CustomBarSeriesRenderer();

  @override
  BarSegment<T, D> createSegment() {
    return BarCustomPainter<T, D>();
  }
}

/// Custom Bar painter for the customized Bar Chart series.
class BarCustomPainter<T, D> extends BarSegment<T, D> {
  @override
  void onPaint(Canvas canvas) {
    final Float64List deviceTransform = Float64List(16)
      ..[0] = 0.05
      ..[5] = 0.05
      ..[10] = 1.0
      ..[15] = 2.0;

    final Paint linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 40
      ..shader = image == null
          ? null
          : ImageShader(
              image!,
              TileMode.repeated,
              TileMode.repeated,
              deviceTransform,
            );

    final double devicePixelRatio =
        ui.PlatformDispatcher.instance.implicitView!.devicePixelRatio;

    if (isImageLoaded && devicePixelRatio > 0) {
      super.onPaint(canvas);
      if (segmentRect != null) {
        final Rect rect = Rect.fromLTRB(
          segmentRect!.left,
          segmentRect!.top,
          segmentRect!.right * animationFactor,
          segmentRect!.bottom,
        );
        canvas.drawRect(rect, linePaint);
      }
    }
  }
}
