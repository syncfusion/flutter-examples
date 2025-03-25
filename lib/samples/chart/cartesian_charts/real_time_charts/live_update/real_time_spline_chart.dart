/// Dart imports.
import 'dart:async';
import 'dart:math' as math;

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the real time spline series chart sample.
class LiveUpdate extends SampleView {
  /// Creates real time spline series chart.
  const LiveUpdate(Key key) : super(key: key);

  @override
  _LiveUpdateState createState() => _LiveUpdateState();
}

class _LiveUpdateState extends SampleViewState {
  _LiveUpdateState() {
    _chartData1 = <ChartSampleData>[
      ChartSampleData(x: 0, y: 0),
      ChartSampleData(x: 1, y: -2),
      ChartSampleData(x: 2, y: 2),
      ChartSampleData(x: 3, y: 0),
    ];
    _chartData2 = <ChartSampleData>[
      ChartSampleData(x: 0, y: 0),
      ChartSampleData(x: 1, y: 2),
      ChartSampleData(x: 2, y: -2),
      ChartSampleData(x: 3, y: 0),
    ];
    _timer = Timer.periodic(const Duration(milliseconds: 50), _updateData);
  }
  Timer? _timer;
  List<ChartSampleData>? _chartData1;
  List<ChartSampleData>? _chartData2;
  int? _wave1;
  int? _wave2;

  @override
  void initState() {
    super.initState();
    _chartData1 = <ChartSampleData>[ChartSampleData(x: 0, y: 0)];
    _chartData2 = <ChartSampleData>[ChartSampleData(x: 0, y: 0)];
    _wave1 = 0;
    _wave2 = 180;
    if (_chartData1!.isNotEmpty && _chartData2!.isNotEmpty) {
      _chartData1!.clear();
      _chartData2!.clear();
    }
    _updateLiveData();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLiveUpdateChart();
  }

  /// Returns the real time cartesian spline series chart.
  SfCartesianChart _buildLiveUpdateChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildSplineSeries(),
    );
  }

  /// Returns the list of cartesian spline series.
  List<SplineSeries<ChartSampleData, num>> _buildSplineSeries() {
    return <SplineSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
        dataSource: [..._chartData1!],
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        animationDuration: 0,
      ),
      SplineSeries<ChartSampleData, num>(
        dataSource: [..._chartData2!],
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        animationDuration: 0,
      ),
    ];
  }

  void _updateData(Timer timer) {
    if (mounted) {
      setState(() {
        _chartData1!.removeAt(0);
        _chartData1!.add(
          ChartSampleData(x: _wave1, y: math.sin(_wave1! * (math.pi / 180.0))),
        );
        _chartData2!.removeAt(0);
        _chartData2!.add(
          ChartSampleData(x: _wave1, y: math.sin(_wave2! * (math.pi / 180.0))),
        );
        _wave1 = _wave1! + 1;
        _wave2 = _wave2! + 1;
      });
    }
  }

  void _updateLiveData() {
    for (int i = 0; i < 180; i++) {
      _chartData1!.add(
        ChartSampleData(x: i, y: math.sin(_wave1! * (math.pi / 180.0))),
      );
      _wave1 = _wave1! + 1;
    }

    for (int i = 0; i < 180; i++) {
      _chartData2!.add(
        ChartSampleData(x: i, y: math.sin(_wave2! * (math.pi / 180.0))),
      );
      _wave2 = _wave2! + 1;
    }

    _wave1 = _chartData1!.length;
  }

  @override
  void dispose() {
    _chartData1!.clear();
    _chartData2!.clear();
    _timer?.cancel();
    super.dispose();
  }
}
