/// Dart imports.
import 'dart:math';
import 'dart:ui';

/// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders customized Line Chart.
class CustomizedLine extends SampleView {
  const CustomizedLine(Key key) : super(key: key);

  @override
  _LineDefaultState createState() => _LineDefaultState();
}

late List<num> _xValues;
late List<num> _yValues;
List<double> _xPointValues = <double>[];
List<double> _yPointValues = <double>[];
TooltipBehavior? _tooltipBehavior;
List<_ChartData>? _chartData1;
List<_ChartData>? _chartData2;

class _LineDefaultState extends SampleViewState {
  _LineDefaultState();

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _chartData1 = <_ChartData>[
      _ChartData(DateTime(2018, 7), 3.5),
      _ChartData(DateTime(2019, 4), 3.5),
      _ChartData(DateTime(2019, 4), 1),
    ];
    _chartData2 = <_ChartData>[
      _ChartData(DateTime(2018, 7), 2.9),
      _ChartData(DateTime(2018, 8), 2.7),
      _ChartData(DateTime(2018, 9), 2.3),
      _ChartData(DateTime(2018, 10), 2.5),
      _ChartData(DateTime(2018, 11), 2.2),
      _ChartData(DateTime(2018, 12), 1.9),
      _ChartData(DateTime(2019), 1.6),
      _ChartData(DateTime(2019, 2), 1.5),
      _ChartData(DateTime(2019, 3), 1.9),
      _ChartData(DateTime(2019, 4), 2),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Capital investment as a share of exports',
      ),
      primaryXAxis: DateTimeAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        dateFormat: DateFormat.yMMM(),
        intervalType: DateTimeIntervalType.months,
        interval: 3,
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}%',
        minimum: 1,
        maximum: 3.5,
        interval: 0.5,
        majorGridLines: MajorGridLines(color: Colors.transparent),
      ),
      series: <CartesianSeries<_ChartData, DateTime>>[
        LineSeries<_ChartData, DateTime>(
          dataSource: _chartData1,
          xValueMapper: (_ChartData sales, int index) => sales.x,
          yValueMapper: (_ChartData sales, int index) => sales.y,
          animationDuration: 0,
          enableTooltip: false,
          color: model.themeData.colorScheme.brightness == Brightness.dark
              ? Colors.grey
              : Colors.black,
        ),
        LineSeries<_ChartData, DateTime>(
          dataSource: _chartData2,
          xValueMapper: (_ChartData sales, int index) => sales.x,
          yValueMapper: (_ChartData sales, int index) => sales.y,
          markerSettings: const MarkerSettings(isVisible: true),
          onCreateRenderer: (ChartSeries<dynamic, dynamic> series) {
            return _CustomLineSeriesRenderer(
              series as LineSeries<_ChartData, DateTime>,
            );
          },
        ),
      ],
      tooltipBehavior: _tooltipBehavior,
    );
  }

  @override
  void dispose() {
    _xValues.clear();
    _yValues.clear();
    _xPointValues.clear();
    _yPointValues.clear();
    _chartData1!.clear();
    _chartData2!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class _CustomLineSeriesRenderer<T, D> extends LineSeriesRenderer<T, D> {
  _CustomLineSeriesRenderer(this.series);

  final LineSeries<dynamic, dynamic> series;
  static Random randomNumber = Random.secure();

  @override
  LineSegment<T, D> createSegment() {
    return _LineCustomPainter(randomNumber.nextInt(4));
  }
}

class _LineCustomPainter<T, D> extends LineSegment<T, D> {
  _LineCustomPainter(int value) {
    //ignore: prefer_initializing_formals
    index = value;
    _xValues = <num>[];
    _yValues = <num>[];
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
    customerStrokePaint.color = const Color.fromRGBO(53, 92, 125, 1);
    customerStrokePaint.strokeWidth = 2;
    customerStrokePaint.style = PaintingStyle.stroke;
    return customerStrokePaint;
  }

  void _storeValues() {
    _xPointValues.add(points[0].dx);
    _xPointValues.add(points[1].dx);
    _yPointValues.add(points[0].dy);
    _yPointValues.add(points[1].dy);
    _xValues.add(points[0].dx);
    _xValues.add(points[1].dx);
    _yValues.add(points[0].dy);
    _yValues.add(points[1].dy);
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
    _storeValues();
    final Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    canvas.drawPath(path, getStrokePaint());

    if (currentSegmentIndex == series.dataSource!.length - 2) {
      const double labelPadding = 10;
      final Paint topLinePaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final Paint bottomLinePaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      maximum = _yPointValues.reduce(max);
      minimum = _yPointValues.reduce(min);
      final Path bottomLinePath = Path();
      final Path topLinePath = Path();
      bottomLinePath.moveTo(_xPointValues[0], maximum);
      bottomLinePath.lineTo(_xPointValues[_xPointValues.length - 1], maximum);

      topLinePath.moveTo(_xPointValues[0], minimum);
      topLinePath.lineTo(_xPointValues[_xPointValues.length - 1], minimum);
      canvas.drawPath(
        _dashPath(
          bottomLinePath,
          dashArray: _CircularIntervalList<double>(<double>[15, 3, 3, 3]),
        )!,
        bottomLinePaint,
      );

      canvas.drawPath(
        _dashPath(
          topLinePath,
          dashArray: _CircularIntervalList<double>(<double>[15, 3, 3, 3]),
        )!,
        topLinePaint,
      );

      final TextSpan span = TextSpan(
        style: TextStyle(
          color: Colors.red[800],
          fontSize: 12.0,
          fontFamily: 'Roboto',
        ),
        text: 'Low point',
      );
      final TextPainter tp = TextPainter(
        text: span,
        textDirection: prefix0.TextDirection.ltr,
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(_xPointValues[_xPointValues.length - 4], maximum + labelPadding),
      );
      final TextSpan span1 = TextSpan(
        style: TextStyle(
          color: Colors.green[800],
          fontSize: 12.0,
          fontFamily: 'Roboto',
        ),
        text: 'High point',
      );
      final TextPainter tp1 = TextPainter(
        text: span1,
        textDirection: prefix0.TextDirection.ltr,
      );
      tp1.layout();
      tp1.paint(
        canvas,
        Offset(
          _xPointValues[0] + labelPadding / 2,
          minimum - labelPadding - tp1.size.height,
        ),
      );
      _yValues.clear();
      _yPointValues.clear();
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
