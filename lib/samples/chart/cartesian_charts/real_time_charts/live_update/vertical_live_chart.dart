/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the vertical live update chart sample.
class VerticalLineLiveUpdate extends SampleView {
  /// Creates the vertical live update chart sample.
  const VerticalLineLiveUpdate(Key key) : super(key: key);

  @override
  _LiveUpdateState createState() => _LiveUpdateState();
}

/// State class for the vertical live update chart.
class _LiveUpdateState extends SampleViewState {
  _LiveUpdateState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 0, y: -4),
      ChartSampleData(x: 1, y: 3),
      ChartSampleData(x: 2, y: -3),
      ChartSampleData(x: 3, y: 2),
      ChartSampleData(x: 4, y: -2),
      ChartSampleData(x: 5, y: 0),
      ChartSampleData(x: 6, y: -3),
      ChartSampleData(x: 7, y: 4),
      ChartSampleData(x: 8, y: 0),
      ChartSampleData(x: 9, y: 0),
      ChartSampleData(x: 10, y: 0),
    ];
  }
  late int _count;

  Timer? _timer;
  ChartSeriesController<ChartSampleData, num>? _chartSeriesController;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _count = 0;
    _chartData = <ChartSampleData>[ChartSampleData(x: 0, y: 0)];
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 10), _updateData);
  }

  @override
  Widget build(BuildContext context) {
    return _buildVerticalLineUpdateChart();
  }

  /// Returns the vertical live update cartesian
  /// line series chart.
  SfCartesianChart _buildVerticalLineUpdateChart() {
    return SfCartesianChart(
      isTransposed: true,
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Time(s)'),
        majorGridLines: const MajorGridLines(color: Colors.transparent),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Velocity(m/s)'),
        minimum: -15,
        maximum: 15,
      ),
      series: _buildLineSeries(),
    );
  }

  /// Returns the list of cartesian line series.
  List<LineSeries<ChartSampleData, num>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        animationDuration: 0,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        onRendererCreated:
            (ChartSeriesController<ChartSampleData, num> controller) {
              _chartSeriesController = controller;
            },
      ),
    ];
  }

  /// Updates the data points at regular intervals.
  void _updateData(Timer timer) {
    if (isCardView != null) {
      _chartData = _generateChartData();
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[_chartData!.length - 1],
      );
    }
  }

  /// Generates a random integer between the specified range.
  int _generateRandomInteger(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  // Generates the chart data points based on the current count.
  List<ChartSampleData> _generateChartData() {
    _count = _count + 1;

    if (_count > 350 || _chartData!.length > 350) {
      _timer?.cancel();
    } else if (_count > 300) {
      _chartData!.add(
        ChartSampleData(x: _chartData!.length, y: _generateRandomInteger(0, 1)),
      );
    } else if (_count > 250) {
      _chartData!.add(
        ChartSampleData(
          x: _chartData!.length,
          y: _generateRandomInteger(-2, 1),
        ),
      );
    } else if (_count > 180) {
      _chartData!.add(
        ChartSampleData(
          x: _chartData!.length,
          y: _generateRandomInteger(-3, 2),
        ),
      );
    } else if (_count > 100) {
      _chartData!.add(
        ChartSampleData(
          x: _chartData!.length,
          y: _generateRandomInteger(-7, 6),
        ),
      );
    } else if (_count < 50) {
      _chartData!.add(
        ChartSampleData(
          x: _chartData!.length,
          y: _generateRandomInteger(-3, 3),
        ),
      );
    } else {
      _chartData!.add(
        ChartSampleData(
          x: _chartData!.length,
          y: _generateRandomInteger(-9, 9),
        ),
      );
    }
    return _chartData!;
  }

  @override
  void dispose() {
    _count = 0;
    _timer?.cancel();
    _chartSeriesController = null;
    _chartData!.clear();
    super.dispose();
  }
}
