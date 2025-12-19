/// Dart imports.
import 'dart:async';
import 'dart:math' as math;

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the realtime line series chart sample.
class LiveLineChart extends SampleView {
  /// Creates the realtime line series chart.
  const LiveLineChart(Key key) : super(key: key);

  @override
  _LiveLineChartState createState() => _LiveLineChartState();
}

/// State class for the realtime line series chart.
class _LiveLineChartState extends SampleViewState {
  _LiveLineChartState() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      _updateDataSource,
    );
  }

  late int _count;

  List<_ChartSampleData>? _chartData;
  ChartSeriesController<_ChartSampleData, int>? _chartSeriesController;
  Timer? _timer;

  @override
  void initState() {
    _count = 19;
    _chartData = <_ChartSampleData>[
      _ChartSampleData(0, 42),
      _ChartSampleData(1, 47),
      _ChartSampleData(2, 33),
      _ChartSampleData(3, 49),
      _ChartSampleData(4, 54),
      _ChartSampleData(5, 41),
      _ChartSampleData(6, 58),
      _ChartSampleData(7, 51),
      _ChartSampleData(8, 98),
      _ChartSampleData(9, 41),
      _ChartSampleData(10, 53),
      _ChartSampleData(11, 72),
      _ChartSampleData(12, 86),
      _ChartSampleData(13, 52),
      _ChartSampleData(14, 94),
      _ChartSampleData(15, 92),
      _ChartSampleData(16, 86),
      _ChartSampleData(17, 72),
      _ChartSampleData(18, 94),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLiveLineChart();
  }

  /// Returns the realtime Cartesian line chart.
  SfCartesianChart _buildLiveLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: <LineSeries<_ChartSampleData, int>>[
        LineSeries<_ChartSampleData, int>(
          dataSource: _chartData,
          xValueMapper: (_ChartSampleData data, int index) => data.country,
          yValueMapper: (_ChartSampleData data, int index) => data.sales,
          color: const Color.fromRGBO(192, 108, 132, 1),
          animationDuration: 0,
          onRendererCreated:
              (ChartSeriesController<_ChartSampleData, int> controller) {
                _chartSeriesController = controller;
              },
        ),
      ],
    );
  }

  /// Updates the data source periodically based on the timer.
  void _updateDataSource(Timer timer) {
    if (isCardView != null) {
      _chartData!.add(
        _ChartSampleData(_count, _generateRandomInteger(10, 100)),
      );
      if (_chartData!.length == 20) {
        _chartData!.removeAt(0);
        _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[_chartData!.length - 1],
          removedDataIndexes: <int>[0],
        );
      } else {
        _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[_chartData!.length - 1],
        );
      }
      _count = _count + 1;
    }
  }

  /// Generates a random integer within the specified range.
  int _generateRandomInteger(int min, int max) {
    final math.Random random = math.Random.secure();
    return min + random.nextInt(max - min);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chartData!.clear();
    _chartSeriesController = null;
    super.dispose();
  }
}

/// Private class for storing the chart series data points.
class _ChartSampleData {
  _ChartSampleData(this.country, this.sales);
  final int country;
  final num sales;
}
