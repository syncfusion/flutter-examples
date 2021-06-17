/// Dart imports
import 'dart:math';
import 'dart:ui';

/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the customized spline chart sample.
class SplineCustomization extends SampleView {
  /// Creates the customized spline chart.
  const SplineCustomization(Key key) : super(key: key);

  @override
  _SplineVerticalState createState() => _SplineVerticalState();
}

/// State class of customized spline chart.
class _SplineVerticalState extends SampleViewState {
  _SplineVerticalState();

  @override
  Widget build(BuildContext context) {
    return _buildCustomizedSplineChart();
  }

  /// Returns the customized spline chart.
  SfCartesianChart _buildCustomizedSplineChart() {
    return SfCartesianChart(
      title: ChartTitle(text: isCardView ? '' : 'Product sales prediction'),
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          minimum: 1.2,
          maximum: 2.4,
          interval: 0.2),
      series: <ChartSeries<ChartSampleData, num>>[
        SplineSeries<ChartSampleData, num>(
            onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
              return _CustomSplineSeriesRenderer(
                  series as SplineSeries<ChartSampleData, num>);
            },
            dataSource: <ChartSampleData>[
              ChartSampleData(x: 2016, y: 2),
              ChartSampleData(x: 2017, y: 1.5),
              ChartSampleData(x: 2018, y: 2),
              ChartSampleData(x: 2019, y: 1.75),
              ChartSampleData(x: 2020, y: 1.5),
              ChartSampleData(x: 2021, y: 2),
              ChartSampleData(x: 2022, y: 1.5),
              ChartSampleData(x: 2023, y: 2.2),
              ChartSampleData(x: 2024, y: 1.9),
            ],
            xValueMapper: (ChartSampleData sales, _) => sales.x as num,
            yValueMapper: (ChartSampleData sales, _) => sales.y,
            width: 2,
            dashArray: const <double>[10, 5]),
      ],
    );
  }
}

/// custom spline series class overriding the original spline series class.
class _CustomSplineSeriesRenderer extends SplineSeriesRenderer {
  _CustomSplineSeriesRenderer(this.series);

  final SplineSeries<dynamic, dynamic> series;

  static Random randomNumber = Random();

  @override
  ChartSegment createSegment() {
    return _SplineCustomPainter(randomNumber.nextInt(4), series);
  }
}

late List<double> _yVal;
late List<double> _xVal;
late double? _textXOffset, _textYOffset;
late double? _text1XOffset, _text1YOffset;

/// custom spline painter class for customized spline series.
class _SplineCustomPainter extends SplineSegment {
  _SplineCustomPainter(int value, this.series) {
    //ignore: prefer_initializing_formals
    index = value;
    _yVal = <double>[];
    _xVal = <double>[];
  }

  final SplineSeries<dynamic, dynamic> series;

  late double maximum, minimum;

  late int index;

  List<Color> colors = <Color>[
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan
  ];

  @override
  int get currentSegmentIndex => super.currentSegmentIndex!;

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
    final double x1 = points[0].dx,
        y1 = points[0].dy,
        x2 = points[1].dx,
        y2 = points[1].dy;
    _yVal.add(y1);
    _yVal.add(y2);
    _xVal.add(x1);
    _xVal.add(x2);
    final Path path = Path();
    path.moveTo(x1, y1);
    path.cubicTo(
        startControlX!, startControlY!, endControlX!, endControlY!, x2, y2);
    currentSegmentIndex < 4
        ? canvas.drawPath(path, getStrokePaint())
        : _drawDashedLine(canvas, series, strokePaint!, path, true);

    if (currentSegmentIndex == 5) {
      _textXOffset = _xVal[0];
      _textYOffset = _yVal[1];
    }
    if (currentSegmentIndex == 1) {
      _text1XOffset = _xVal[0];
      _text1YOffset = _yVal[0];
    }

    if (currentSegmentIndex == series.dataSource.length - 2) {
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
      tp.paint(canvas, Offset(_text1XOffset!, _text1YOffset! + tp.size.height));
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
      tp1.paint(canvas, Offset(_textXOffset!, _textYOffset! + tp.size.height));
    }
  }
}

void _drawDashedLine(Canvas canvas, CartesianSeries<dynamic, dynamic> series,
    Paint paint, Path path, bool isSeries) {
  bool _even = false;
  for (int i = 1; i < series.dashArray.length; i = i + 2) {
    if (series.dashArray[i] == 0) {
      _even = true;
    }
  }
  if (_even == false) {
    paint.isAntiAlias = true;
    canvas.drawPath(
        _dashPath(
          path,
          dashArray: _CircularIntervalList<double>(
              isSeries ? series.dashArray : <double>[12, 3, 3, 3]),
        )!,
        paint);
  } else {
    canvas.drawPath(path, paint);
  }
}

Path? _dashPath(
  Path source, {
  required _CircularIntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double _intialValue = 0.0;
  final Path _path = Path();
  for (final PathMetric measurePath in source.computeMetrics()) {
    double _distance = _intialValue;
    bool _draw = true;
    while (_distance < measurePath.length) {
      final double length = dashArray.next;
      if (_draw) {
        _path.addPath(measurePath.extractPath(_distance, _distance + length),
            Offset.zero);
      }
      _distance += length;
      _draw = !_draw;
    }
  }
  return _path;
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
