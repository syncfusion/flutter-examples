/// Dart imports
import 'dart:typed_data';
import 'dart:ui' as ui;

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Render the customized bar chart sample.
class BarCustomization extends SampleView {
  const BarCustomization(Key key) : super(key: key);

  @override
  _BarCustomizationState createState() => _BarCustomizationState();
}

ui.Image image;
bool isImageloaded = false;

List<num> values;

/// State class of the customized bar chart.
class _BarCustomizationState extends SampleViewState {
  _BarCustomizationState();

  @override
  Widget build(BuildContext context) {
    return getCustomizedBarChart();
  }

  /// Returns the customized cartesian bar chart.
  SfCartesianChart getCustomizedBarChart() {
    return SfCartesianChart(
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Popular Android apps in the Google play store'),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Downloads in Billion'),
          majorGridLines: MajorGridLines(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: <ChartSeries<ChartSampleData, String>>[
        BarSeries<ChartSampleData, String>(
          onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
            return CustomBarSeriesRenderer();
          },
          enableTooltip: true,
          isTrackVisible: false,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          dataSource: <ChartSampleData>[
            ChartSampleData(
                x: 'Facebook', y: 4.119, pointColor: Colors.redAccent),
            ChartSampleData(
                x: 'FB Messenger', y: 3.408, pointColor: Colors.indigo),
            ChartSampleData(x: 'WhatsApp', y: 2.979, pointColor: Colors.grey),
            ChartSampleData(
                x: 'Instagram', y: 1.843, pointColor: Colors.orange),
            ChartSampleData(x: 'Skype', y: 1.039, pointColor: Colors.green),
            ChartSampleData(
                x: 'Subway Surfers', y: 1.025, pointColor: Colors.yellow),
          ],
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
        )
      ],
      tooltipBehavior:
          TooltipBehavior(enable: true, canShowMarker: false, header: ''),
    );
  }
}

/// Custom bar series class that extend the original bar series to create Customized bar chart.
class CustomBarSeriesRenderer extends BarSeriesRenderer {
  CustomBarSeriesRenderer();

  @override
  ChartSegment createSegment() {
    return BarCustomPainter();
  }
}

/// custom bar painter for the customized bar chart series.
class BarCustomPainter extends BarSegment {
  List<num> values = <num>[];

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
      ..shader = ImageShader(
          image, TileMode.repeated, TileMode.repeated, deviceTransform);

    final double devicePixelRatio = ui.window.devicePixelRatio;

    if (isImageloaded && devicePixelRatio > 0) {
      super.onPaint(canvas);
      final Rect rect = Rect.fromLTRB(segmentRect.left, segmentRect.top,
          segmentRect.right * animationFactor, segmentRect.bottom);
      canvas.drawRect(rect, linePaint);
    }
  }
}
