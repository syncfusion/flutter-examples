/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the column chart sample with dynamically updated data points.
class AnimationColumnDefault extends SampleView {
  /// Creates the column chart sample with dynamically updated data points.
  const AnimationColumnDefault(Key key) : super(key: key);

  @override
  _AnimationColumnDefaultState createState() => _AnimationColumnDefaultState();
}

class _AnimationColumnDefaultState extends SampleViewState {
  _AnimationColumnDefaultState();

  late List<_ChartData> _chartData;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    _getChartData();
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
      });
    });
    return _buildAnimationColumnChart();
  }

  /// Get the cartesian chart
  SfCartesianChart _buildAnimationColumnChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0),
            minimum: 0,
            maximum: 100),
        series: _getDefaultColumnSeries());
  }

  /// Get the column series
  List<ColumnSeries<_ChartData, num>> _getDefaultColumnSeries() {
    return <ColumnSeries<_ChartData, num>>[
      ColumnSeries<_ChartData, num>(
          dataSource: _chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  ///Generate random value
  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  ///Generate random data points
  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i < 8; i++) {
      _chartData.add(_ChartData(i, _getRandomInt(0, 100)));
    }
    _timer?.cancel();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
