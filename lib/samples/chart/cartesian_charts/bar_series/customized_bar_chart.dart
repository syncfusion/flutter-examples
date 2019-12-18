import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class BarCustomization extends StatefulWidget {
  BarCustomization({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _BarCustomizationState createState() => _BarCustomizationState(sample);
}

ui.Image image;
bool isImageloaded = false;

List<num> values;

class _BarCustomizationState extends State<BarCustomization> {
  _BarCustomizationState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.makeuseof.com/tag/most-popular-android-apps/';
    const String source = 'www.makeuseof.com';
    return getScopedModel(
        getCustomizedBarChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getCustomizedBarChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(
        text:
            isTileView ? '' : 'Popular Android apps in the Google play store'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Downloads in Billion'),
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getCustomizedBarSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, canShowMarker: false, header: ''),
  );
}

List<CustomBarSeries<ChartSampleData, String>> getCustomizedBarSeries(
    bool isTileView) {
  final dynamic chartData = <ChartSampleData>[
    ChartSampleData(x: 'Facebook', y: 4.119, pointColor: Colors.redAccent),
    ChartSampleData(x: 'FB Messenger', y: 3.408, pointColor: Colors.indigo),
    ChartSampleData(x: 'WhatsApp', y: 2.979, pointColor: Colors.grey),
    ChartSampleData(x: 'Instagram', y: 1.843, pointColor: Colors.orange),
    ChartSampleData(x: 'Skype', y: 1.039, pointColor: Colors.green),
    ChartSampleData(x: 'Subway Surfers', y: 1.025, pointColor: Colors.yellow),
  ];
  return <CustomBarSeries<ChartSampleData, String>>[
    CustomBarSeries<ChartSampleData, String>(
      enableTooltip: true,
      isTrackVisible: false,
      dataLabelSettings: DataLabelSettings(isVisible: true),
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    )
  ];
}

class CustomBarSeries<T, D> extends BarSeries<T, D> {
  CustomBarSeries({
    @required List<T> dataSource,
    @required ChartValueMapper<T, D> xValueMapper,
    @required ChartValueMapper<T, num> yValueMapper,
    ChartValueMapper<T, Color> pointColorMapper,
    String xAxisName,
    String yAxisName,
    Color color,
    double width,
    MarkerSettings markerSettings,
    EmptyPointSettings emptyPointSettings,
    DataLabelSettings dataLabelSettings,
    bool visible,
    bool enableTooltip,
    double animationDuration,
    Color trackColor,
    Color trackBorderColor,
    bool isTrackVisible,
  }) : super(
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            pointColorMapper: pointColorMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            isTrackVisible: isTrackVisible,
            trackColor: trackColor,
            trackBorderColor: trackBorderColor,
            width: width,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: visible,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration);

  @override
  ChartSegment createSegment() {
    return BarCustomPainter();
  }
}

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
