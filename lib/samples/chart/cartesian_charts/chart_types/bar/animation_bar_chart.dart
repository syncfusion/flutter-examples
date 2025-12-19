/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Bar Chart sample with dynamically updated data points.
class AnimationBarDefault extends SampleView {
  const AnimationBarDefault(Key key) : super(key: key);

  @override
  _AnimationBarDefaultState createState() => _AnimationBarDefaultState();
}

class _AnimationBarDefaultState extends SampleViewState {
  _AnimationBarDefaultState();

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

  /// Return the Cartesian Chart with Bar series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: 0,
        maximum: 100,
      ),
      series: _buildBarSeries(),
    );
  }

  /// Returns the list of Cartesian Bar series.
  List<BarSeries<_ChartData, num>> _buildBarSeries() {
    return <BarSeries<_ChartData, num>>[
      BarSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
      ),
    ];
  }

  int _buildRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  void _buildChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 7; i++) {
      _chartData!.add(_ChartData(i, _buildRandomInt(10, 95)));
    }
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer!.cancel();
    _chartData!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
