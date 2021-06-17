/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

/// Renders the Scatter chart sample with dynamically updated data points.
class AnimationScatterDefault extends SampleView {
  /// Creates the Scatter chart sample with dynamically updated data points.
  const AnimationScatterDefault(Key key) : super(key: key);

  @override
  _AnimationScatterDefaultState createState() =>
      _AnimationScatterDefaultState();
}

class _AnimationScatterDefaultState extends SampleViewState {
  _AnimationScatterDefaultState();
  Timer? _timer;
  late List<_ChartData> _chartData;

  @override
  Widget build(BuildContext context) {
    _getChartData();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
      });
    });
    return _buildAnimationScatterChart();
  }

  /// Get the Scatter chart sample with dynamically updated data points.
  SfCartesianChart _buildAnimationScatterChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0),
            minimum: 0,
            maximum: 100),
        series: getDefaultScatterSeries());
  }

  /// It will return the scatter series with its functionality to chart.
  List<ScatterSeries<_ChartData, num>> getDefaultScatterSeries() {
    return <ScatterSeries<_ChartData, num>>[
      ScatterSeries<_ChartData, num>(
          dataSource: _chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          markerSettings: const MarkerSettings(height: 15, width: 15))
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 10; i++) {
      _chartData.add(_ChartData(i, _getRandomInt(5, 95)));
    }
    _timer?.cancel();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
