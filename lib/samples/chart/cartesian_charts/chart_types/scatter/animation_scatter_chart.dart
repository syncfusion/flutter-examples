/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Scatter Chart sample with dynamically updated data points.
class AnimationScatterDefault extends SampleView {
  const AnimationScatterDefault(Key key) : super(key: key);

  @override
  _AnimationScatterDefaultState createState() =>
      _AnimationScatterDefaultState();
}

class _AnimationScatterDefaultState extends SampleViewState {
  _AnimationScatterDefaultState();

  Timer? _timer;
  List<_ChartData>? _chartData;

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

  /// Return the Cartesian Chart with Scatter series.
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
      series: _buildScatterSeries(),
    );
  }

  /// Returns the list of Cartesian Scatter series.
  List<ScatterSeries<_ChartData, num>> _buildScatterSeries() {
    return <ScatterSeries<_ChartData, num>>[
      ScatterSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
        markerSettings: const MarkerSettings(height: 15, width: 15),
      ),
    ];
  }

  int _buildRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  void _buildChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 10; i++) {
      _chartData!.add(_ChartData(i, _buildRandomInt(5, 95)));
    }
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chartData!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
