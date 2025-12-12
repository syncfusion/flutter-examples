/// Dart imports.
import 'dart:math';
import 'dart:ui';

/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the customized Spline Chart sample.
class SplineCustomization extends SampleView {
  const SplineCustomization(Key key) : super(key: key);

  @override
  _SplineVerticalState createState() => _SplineVerticalState();
}

/// State class of customized Spline Chart.
class _SplineVerticalState extends SampleViewState {
  _SplineVerticalState();

  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2016), y: 2),
      ChartSampleData(x: DateTime(2017), y: 1.5),
      ChartSampleData(x: DateTime(2018), y: 2),
      ChartSampleData(x: DateTime(2019), y: 1.75),
      ChartSampleData(x: DateTime(2020), y: 1.5),
      ChartSampleData(x: DateTime(2021), y: 2),
      ChartSampleData(x: DateTime(2022), y: 1.5),
      ChartSampleData(x: DateTime(2023), y: 2.2),
      ChartSampleData(x: DateTime(2024), y: 1.9),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Spline series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Product sales prediction'),
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        intervalType: DateTimeIntervalType.years,
        interval: model.isWebFullView ? 1 : 2,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: DateFormat.y(),
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: 1.2,
        maximum: 2.4,
        interval: 0.2,
      ),
      series: <CartesianSeries<ChartSampleData, DateTime>>[
        SplineSeries<ChartSampleData, DateTime>(
          dataSource: _chartData,
          xValueMapper: (ChartSampleData sales, int index) => sales.x,
          yValueMapper: (ChartSampleData sales, int index) => sales.y,
          onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
            return _CustomSplineSeriesRenderer(
              series as SplineSeries<ChartSampleData, DateTime>,
            );
          },
          dashArray: const <double>[10, 5],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

/// Custom Spline series class overriding the original Spline series class.
class _CustomSplineSeriesRenderer<T, D> extends SplineSeriesRenderer<T, D> {
  _CustomSplineSeriesRenderer(this.series);

  final SplineSeries<dynamic, dynamic> series;

  static Random randomNumber = Random.secure();

  @override
  SplineSegment<T, D> createSegment() {
    return _SplineCustomPainter(randomNumber.nextInt(4));
  }
}

late double? _textXOffset, _textYOffset;
late double? _text1XOffset, _text1YOffset;

/// custom Spline painter class for customized Spline series.
class _SplineCustomPainter<T, D> extends SplineSegment<T, D> {
  _SplineCustomPainter(int value) {
    //ignore: prefer_initializing_formals
    index = value;
  }

  late double maximum, minimum;
  late int index;

  List<Color> colors = <Color>[
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
  ];

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
    if (isEmpty) {
      return;
    }

    final double x1 = points[0].dx,
        y1 = points[0].dy,
        x2 = points[1].dx,
        y2 = points[1].dy;

    final Path path = Path();
    path.moveTo(x1, y1);
    path.cubicTo(
      startControlX!,
      startControlY!,
      endControlX!,
      endControlY!,
      x2,
      y2,
    );
    currentSegmentIndex < 4
        ? canvas.drawPath(path, getStrokePaint())
        : _drawDashedLine(canvas, series, getStrokePaint(), path, true);

    if (currentSegmentIndex == 5) {
      _textXOffset = x1;
      _textYOffset = y2;
    }
    if (currentSegmentIndex == 1) {
      _text1XOffset = x1;
      _text1YOffset = y1;
    }

    if (currentSegmentIndex == series.dataSource!.length - 2) {
      const TextSpan span = TextSpan(
        style: TextStyle(
          color: Color.fromRGBO(0, 168, 181, 1),
          fontSize: 12.0,
          fontFamily: 'Roboto',
        ),
        text: 'Original data',
      );
      final TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(_text1XOffset!, _text1YOffset! + tp.size.height));
      const TextSpan span1 = TextSpan(
        style: TextStyle(
          color: Color.fromRGBO(246, 114, 128, 1),
          fontSize: 12.0,
          fontFamily: 'Roboto',
        ),
        text: 'Imaginary data',
      );
      final TextPainter tp1 = TextPainter(
        text: span1,
        textDirection: TextDirection.ltr,
      );
      tp1.layout();
      tp1.paint(canvas, Offset(_textXOffset!, _textYOffset! + tp.size.height));
    }
  }
}

void _drawDashedLine(
  Canvas canvas,
  SplineSeriesRenderer<dynamic, dynamic> series,
  Paint paint,
  Path path,
  bool isSeries,
) {
  if (series.dashArray != null) {
    bool even = false;
    for (int i = 1; i < series.dashArray!.length; i = i + 2) {
      if (series.dashArray![i] == 0) {
        even = true;
      }
    }
    if (even == false) {
      paint.isAntiAlias = true;
      canvas.drawPath(
        _dashPath(
          path,
          dashArray: _CircularIntervalList<double>(
            series.dashArray != null
                ? series.dashArray!
                : <double>[12, 3, 3, 3],
          ),
        )!,
        paint,
      );
    } else {
      canvas.drawPath(path, paint);
    }
  }
}

Path? _dashPath(
  Path source, {
  required _CircularIntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double initialValue = 0.0;
  final Path path = Path();
  for (final PathMetric measurePath in source.computeMetrics()) {
    double distance = initialValue;
    bool draw = true;
    while (distance < measurePath.length) {
      final double length = dashArray.next;
      if (draw) {
        path.addPath(
          measurePath.extractPath(distance, distance + length),
          Offset.zero,
        );
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
