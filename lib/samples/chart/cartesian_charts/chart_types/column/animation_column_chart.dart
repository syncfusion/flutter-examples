/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Column Chart sample with dynamically updated data points.
class AnimationColumnDefault extends SampleView {
  const AnimationColumnDefault(Key key) : super(key: key);

  @override
  _AnimationColumnDefaultState createState() => _AnimationColumnDefaultState();
}

class _AnimationColumnDefaultState extends SampleViewState {
  _AnimationColumnDefaultState();

  List<_ChartData>? _chartData;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    _buildChartData();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _buildChartData();
      });
    });
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        majorTickLines: MajorTickLines(color: Colors.transparent),
        axisLine: AxisLine(width: 0),
        minimum: 0,
        maximum: 100,
      ),
      series: _buildColumnSeries(),
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<_ChartData, num>> _buildColumnSeries() {
    return <ColumnSeries<_ChartData, num>>[
      ColumnSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
      ),
    ];
  }

  /// Generate random value.
  int _buildRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  /// Generate random data points.
  void _buildChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i < 8; i++) {
      _chartData!.add(_ChartData(i, _buildRandomInt(0, 100)));
    }
    _timer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
    _chartData!.clear();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
