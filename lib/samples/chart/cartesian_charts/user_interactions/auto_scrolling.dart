/// Dart imports.
import 'dart:async';
import 'dart:math' as math;

/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the column series chart with auto scrolling.
class AutoScrollingChart extends SampleView {
  /// Creates the column series chart with auto scrolling.
  const AutoScrollingChart(Key key) : super(key: key);

  @override
  _AutoScrollingChartState createState() => _AutoScrollingChartState();
}

/// State of the column series chart with auto scrolling.
class _AutoScrollingChartState extends SampleViewState {
  _AutoScrollingChartState();
  Timer? _timer;
  late List<Color> _palette1;
  late List<Color> _palette2;
  late List<Color> _palette3;
  late List<_ChartData> _chartData;
  late List<_ChartData> _chartDataTemp;
  late bool _isPointerMoved;

  bool _havingPanDataSource = false;

  @override
  void initState() {
    _initializeVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAutoScrollingLineChart();
  }

  void _initializeVariables() {
    _palette1 = const <Color>[
      Color.fromRGBO(75, 135, 185, 1),
      Color.fromRGBO(192, 108, 132, 1),
      Color.fromRGBO(246, 114, 128, 1),
      Color.fromRGBO(248, 177, 149, 1),
      Color.fromRGBO(116, 180, 155, 1),
      Color.fromRGBO(0, 168, 181, 1),
      Color.fromRGBO(73, 76, 162, 1),
      Color.fromRGBO(255, 205, 96, 1),
      Color.fromRGBO(255, 240, 219, 1),
      Color.fromRGBO(238, 238, 238, 1),
    ];
    _palette2 = const <Color>[
      Color.fromRGBO(6, 174, 224, 1),
      Color.fromRGBO(99, 85, 199, 1),
      Color.fromRGBO(49, 90, 116, 1),
      Color.fromRGBO(255, 180, 0, 1),
      Color.fromRGBO(150, 60, 112, 1),
      Color.fromRGBO(33, 150, 245, 1),
      Color.fromRGBO(71, 59, 137, 1),
      Color.fromRGBO(236, 92, 123, 1),
      Color.fromRGBO(59, 163, 26, 1),
      Color.fromRGBO(236, 131, 23, 1),
    ];
    _palette3 = const <Color>[
      Color.fromRGBO(255, 245, 0, 1),
      Color.fromRGBO(51, 182, 119, 1),
      Color.fromRGBO(218, 150, 70, 1),
      Color.fromRGBO(201, 88, 142, 1),
      Color.fromRGBO(77, 170, 255, 1),
      Color.fromRGBO(255, 157, 69, 1),
      Color.fromRGBO(178, 243, 46, 1),
      Color.fromRGBO(185, 60, 228, 1),
      Color.fromRGBO(48, 167, 6, 1),
      Color.fromRGBO(207, 142, 14, 1),
    ];
    _isPointerMoved = false;
    _chartData = <_ChartData>[
      _ChartData(DateTime(2020), 42),
      _ChartData(DateTime(2020, 01, 1, 00, 00, 01), 47),
    ];
    _chartDataTemp = <_ChartData>[];
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {
      if (!_isPointerMoved) {
        if (_chartDataTemp.isNotEmpty) {
          _chartData.addAll(_chartDataTemp);
          _chartDataTemp.clear();
          _havingPanDataSource = true;
        }
        setState(() {
          _chartData = _updateDataSource();
          _havingPanDataSource = false;
        });
      } else {
        _chartDataTemp = _updateTempDataSource();
      }
    });
  }

  /// Returns the cartesian column chart with auto scrolling.
  SfCartesianChart _buildAutoScrollingLineChart() {
    final ThemeData themeData = model.themeData;
    _palette1 = themeData.useMaterial3
        ? (themeData.brightness == Brightness.light ? _palette2 : _palette3)
        : _palette1;
    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
      onChartTouchInteractionMove: (ChartTouchInteractionArgs args) {
        _isPointerMoved = true;
      },
      onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
        _isPointerMoved = false;
      },
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        dateFormat: DateFormat.Hms(),
        intervalType: DateTimeIntervalType.seconds,
        autoScrollingDelta: 10,
        autoScrollingDeltaType: DateTimeIntervalType.seconds,
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: <ColumnSeries<_ChartData, DateTime>>[
        ColumnSeries<_ChartData, DateTime>(
          dataSource: _chartData,
          xValueMapper: (_ChartData data, int index) => data.x,
          yValueMapper: (_ChartData data, int index) => data.y,
          color: const Color.fromRGBO(192, 108, 132, 1),
          pointColorMapper: (_ChartData data, int index) =>
              _palette1[index % 10],
          animationDuration: 0,
        ),
      ],
    );
  }

  List<_ChartData> _updateDataSource() {
    if (!_havingPanDataSource) {
      final lastDataPoint = _chartData.last;

      _chartData.add(
        _ChartData(
          lastDataPoint.x.add(const Duration(seconds: 1)),
          _generateRandomInt(30, 60),
        ),
      );
    }

    return _chartData;
  }

  List<_ChartData> _updateTempDataSource() {
    // Determine the x value based on whether _chartDataTemp is empty
    final newXValue = _chartDataTemp.isEmpty
        ? _chartData.last.x.add(const Duration(seconds: 1))
        : _chartDataTemp.last.x.add(const Duration(seconds: 1));

    // Create and add the new data point to _chartDataTemp
    _chartDataTemp.add(_ChartData(newXValue, _generateRandomInt(30, 60)));

    return _chartDataTemp;
  }

  int _generateRandomInt(int min, int max) {
    final math.Random random = math.Random.secure();
    return min + random.nextInt(max - min);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chartData.clear();
    _chartDataTemp.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final num y;
}
