import 'dart:math';
import 'dart:ui';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class SplineCustomization extends StatefulWidget {
  SplineCustomization({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _SplineVerticalState createState() => _SplineVerticalState(sample);
}

class _SplineVerticalState extends State<SplineCustomization> {
  _SplineVerticalState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getCustomizedSplineChart(false), sample);
  }
}

SfCartesianChart getCustomizedSplineChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Product sales prediction'),
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: 1.2,
        maximum: 2.4,
        interval: 0.2),
    series: getSplineCustomizedSeries(isTileView),
  );
}

List<CustomSplineSeries<ChartSampleData, num>> getSplineCustomizedSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 2016, y: 2),
    ChartSampleData(x: 2017, y: 1.5),
    ChartSampleData(x: 2018, y: 2),
    ChartSampleData(x: 2019, y: 1.75),
    ChartSampleData(x: 2020, y: 1.5),
    ChartSampleData(x: 2021, y: 2),
    ChartSampleData(x: 2022, y: 1.5),
    ChartSampleData(x: 2023, y: 2.2),
    ChartSampleData(x: 2024, y: 1.9),
  ];
  return <CustomSplineSeries<ChartSampleData, num>>[
    CustomSplineSeries<ChartSampleData, num>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2,
        dashArray: <double>[10, 5]),
  ];
}

class CustomSplineSeries<T, D> extends SplineSeries<T, D> {
  CustomSplineSeries(
      {@required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      String xAxisName,
      String yAxisName,
      Color color,
      double width,
      MarkerSettings marker,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabel,
      bool visible,
      bool enableToolTip,
      List<double> dashArray,
      double animationDuration})
      : super(
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width,
            markerSettings: marker,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabel,
            isVisible: visible,
            enableTooltip: enableToolTip,
            dashArray: dashArray,
            animationDuration: animationDuration);

  static Random randomNumber = Random();

  @override
  ChartSegment createSegment() {
    return SplineCustomPainter(randomNumber.nextInt(4));
  }
}

List<num> yVal;
List<num> xVal;

class SplineCustomPainter extends SplineSegment {
  SplineCustomPainter(int value) {
    //ignore: prefer_initializing_formals
    index = value;
    yVal = <num>[];
    xVal = <num>[];
  }

  double maximum, minimum;

  int index;

  List<Color> colors = <Color>[
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan
  ];

  @override
  int get currentSegmentIndex => super.currentSegmentIndex;

  @override
  Paint getStrokePaint() {
    final Paint customerStrokePaint = Paint();
    customerStrokePaint.color = currentSegmentIndex < 4
        ? const Color.fromRGBO(0, 168, 181, 1)
        : const Color.fromRGBO(246, 114, 128, 1);
    customerStrokePaint.strokeWidth = 2;
    customerStrokePaint.style = PaintingStyle.stroke;
    return customerStrokePaint;
  }

  @override
  Paint getFillPaint() {
    final Paint customerFillPaint = Paint();
    customerFillPaint.color = Colors.amber;
    customerFillPaint.style = PaintingStyle.fill;
    return customerFillPaint;
  }

  @override
  void onPaint(Canvas canvas) {
    final double x1 = this.x1, y1 = this.y1, x2 = this.x2, y2 = this.y2;
    yVal.add(y1);
    yVal.add(y2);
    xVal.add(x1);
    xVal.add(x2);
    final Path path = Path();
    path.moveTo(x1, y1);
    path.cubicTo(
        startControlX, startControlY, endControlX, endControlY, x2, y2);
    currentSegmentIndex < 4
        ? canvas.drawPath(path, getStrokePaint())
        : drawDashedLine(canvas, series, strokePaint, path, true);

    if (currentSegmentIndex == series.segments.length - 1) {
      double maximum;
      maximum = yVal.reduce(max);
      const TextSpan span = TextSpan(
        style: TextStyle(
            color: Color.fromRGBO(0, 168, 181, 1),
            fontSize: 12.0,
            fontFamily: 'Roboto'),
        text: 'Original data',
      );
      final TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(xVal[1], maximum + tp.size.height));
      const TextSpan span1 = TextSpan(
        style: TextStyle(
            color: Color.fromRGBO(246, 114, 128, 1),
            fontSize: 12.0,
            fontFamily: 'Roboto'),
        text: 'Imaginary data',
      );
      final TextPainter tp1 =
          TextPainter(text: span1, textDirection: TextDirection.ltr);
      tp1.layout();
      tp1.paint(canvas, Offset(xVal[10], maximum + tp.size.height));
    }
  }
}

void drawDashedLine(Canvas canvas, CartesianSeries<dynamic, dynamic> series,
    Paint paint, Path path, bool isSeries,
    [List<Path> pathList, List<Color> colorList]) {
  bool even = false;
  for (int i = 1; i < series.dashArray.length; i = i + 2) {
    if (series.dashArray[i] == 0) {
      even = true;
    }
  }
  if (even == false) {
    paint.isAntiAlias = true;
    canvas.drawPath(
        dashPath(
          path,
          dashArray: CircularIntervalList<double>(
              isSeries ? series.dashArray : <double>[12, 3, 3, 3]),
        ),
        paint);
  } else
    canvas.drawPath(path, paint);
}

Path dashPath(
  Path source, {
  @required CircularIntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double intialValue = 0.0;
  final Path path = Path();
  for (final PathMetric measurePath in source.computeMetrics()) {
    double distance = intialValue;
    bool draw = true;
    while (distance < measurePath.length) {
      final double length = dashArray.next;
      if (draw) {
        path.addPath(
            measurePath.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      draw = !draw;
    }
  }
  return path;
}

class CircularIntervalList<T> {
  CircularIntervalList(this._values);
  final List<T> _values;
  int _index = 0;
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}
