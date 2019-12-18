import 'dart:math';
import 'dart:ui';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class CustomizedLine extends StatefulWidget {
  CustomizedLine({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _LineDefaultState createState() => _LineDefaultState(sample);
}

List<num> xValues;
List<num> yValues;

class _LineDefaultState extends State<CustomizedLine> {
  _LineDefaultState(this.sample);
  final SubItem sample;
  @override
  Widget build(BuildContext context) {
    return getScopedModel(getCustomizedLineChart(false), sample);
  }
}

SfCartesianChart getCustomizedLineChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(
        text: isTileView ? '' : 'Capital investment as a share of exports'),
    primaryXAxis: DateTimeAxis(
      edgeLabelPlacement: EdgeLabelPlacement.shift,
      dateFormat: DateFormat.yMMM(),
      intervalType: DateTimeIntervalType.months,
      interval: 3,
    ),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
        minimum: 1,
        maximum: 3.5,
        interval: 0.5,
        majorGridLines: MajorGridLines(color: Colors.transparent)),
    series: getCustomizedLineSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<CustomLineSeries<_ChartData, DateTime>> getCustomizedLineSeries(
    bool isTileView) {
  final dynamic chartData = <_ChartData>[
    _ChartData(DateTime(2018, 7), 2.9),
    _ChartData(DateTime(2018, 8), 2.7),
    _ChartData(DateTime(2018, 9), 2.3),
    _ChartData(DateTime(2018, 10), 2.5),
    _ChartData(DateTime(2018, 11), 2.2),
    _ChartData(DateTime(2018, 12), 1.9),
    _ChartData(DateTime(2019, 1), 1.6),
    _ChartData(DateTime(2019, 2), 1.5),
    _ChartData(DateTime(2019, 3), 1.9),
    _ChartData(DateTime(2019, 4), 2),
  ];
  return <CustomLineSeries<_ChartData, DateTime>>[
    CustomLineSeries<_ChartData, DateTime>(
        animationDuration: 2500,
        enableToolTip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        width: 2,
        markerSettings: MarkerSettings(isVisible: true)),
  ];
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class CustomLineSeries<T, D> extends LineSeries<T, D> {
  CustomLineSeries({
    @required List<T> dataSource,
    @required ChartValueMapper<T, D> xValueMapper,
    @required ChartValueMapper<T, num> yValueMapper,
    String xAxisName,
    String yAxisName,
    Color color,
    double width,
    MarkerSettings markerSettings,
    EmptyPointSettings emptyPointSettings,
    DataLabelSettings dataLabel,
    bool visible,
    bool enableToolTip,
    List<double> dashArray,
    double animationDuration,
  }) : super(
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabel,
            isVisible: visible,
            enableTooltip: enableToolTip,
            dashArray: dashArray,
            animationDuration: animationDuration);

  static Random randomNumber = Random();

  @override
  ChartSegment createSegment() {
    return LineCustomPainter(randomNumber.nextInt(4));
  }
}

class LineCustomPainter extends LineSegment {
  LineCustomPainter(int value) {
    //ignore: prefer_initializing_formals
    index = value;
    xValues = <num>[];
    yValues = <num>[];
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
  Paint getStrokePaint() {
    final Paint customerStrokePaint = Paint();
    customerStrokePaint.color = const Color.fromRGBO(53, 92, 125, 1);
    customerStrokePaint.strokeWidth = 2;
    customerStrokePaint.style = PaintingStyle.stroke;
    return customerStrokePaint;
  }

  @override
  void onPaint(Canvas canvas) {
    final double x1 = this.x1, y1 = this.y1, x2 = this.x2, y2 = this.y2;
    xValues.add(x1);
    xValues.add(x2);
    yValues.add(y1);
    yValues.add(y2);

    final Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    canvas.drawPath(path, getStrokePaint());

    if (currentSegmentIndex == series.segments.length - 1) {
      const double labelPadding = 10;
      final Paint topLinePaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final Paint bottomLinePaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      maximum = yValues.reduce(max);
      minimum = yValues.reduce(min);
      final Path bottomLinePath = Path();
      final Path topLinePath = Path();
      bottomLinePath.moveTo(xValues[0], maximum + 5);
      bottomLinePath.lineTo(xValues[xValues.length - 1], maximum + 5);

      topLinePath.moveTo(xValues[0], minimum - 5);
      topLinePath.lineTo(xValues[xValues.length - 1], minimum - 5);
      canvas.drawPath(
          _dashPath(
            bottomLinePath,
            dashArray: _CircularIntervalList<double>(<double>[15, 3, 3, 3]),
          ),
          bottomLinePaint);

      canvas.drawPath(
          _dashPath(
            topLinePath,
            dashArray: _CircularIntervalList<double>(<double>[15, 3, 3, 3]),
          ),
          topLinePaint);

      final TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.red[800], fontSize: 12.0, fontFamily: 'Roboto'),
        text: 'Low point',
      );
      final TextPainter tp =
          TextPainter(text: span, textDirection: prefix0.TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas, Offset(xValues[xValues.length - 4], maximum + labelPadding));
      final TextSpan span1 = TextSpan(
        style: TextStyle(
            color: Colors.green[800], fontSize: 12.0, fontFamily: 'Roboto'),
        text: 'High point',
      );
      final TextPainter tp1 =
          TextPainter(text: span1, textDirection: prefix0.TextDirection.ltr);
      tp1.layout();
      tp1.paint(
          canvas,
          Offset(xValues[0] + labelPadding / 2,
              minimum - labelPadding - tp1.size.height));
      yValues.clear();
    }
  }
}

Path _dashPath(
  Path source, {
  @required _CircularIntervalList<double> dashArray,
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

class _CircularIntervalList<T> {
  _CircularIntervalList(this._values);
  final List<T> _values;
  int _index = 0;
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}
