/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the range column chart sample with dynamically updated data points.
class AnimationRangeColumnDefault extends SampleView {
  /// Renders the range column chart with dynamically updated data points.
  const AnimationRangeColumnDefault(Key key) : super(key: key);

  @override
  _AnimationRangeColumnDefaultState createState() =>
      _AnimationRangeColumnDefaultState();
}

class _AnimationRangeColumnDefaultState extends SampleViewState {
  _AnimationRangeColumnDefaultState();
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
    return _buildAnimationRangeColumnChart();
  }

  /// Get range column chart animation.
  SfCartesianChart _buildAnimationRangeColumnChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0),
            minimum: 0,
            maximum: 100),
        series: _getDefaultRangeColumnSeries());
  }

  /// Get range column series with animation.
  List<RangeColumnSeries<_ChartData, num>> _getDefaultRangeColumnSeries() {
    return <RangeColumnSeries<_ChartData, num>>[
      RangeColumnSeries<_ChartData, num>(
          dataSource: _chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          lowValueMapper: (_ChartData sales, _) => sales.y,
          highValueMapper: (_ChartData sales, _) => sales.z)
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
    for (int i = 1; i <= 7; i++) {
      _chartData
          .add(_ChartData(i, _getRandomInt(5, 45), _getRandomInt(46, 95)));
    }
    _timer?.cancel();
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.z);
  final int x;
  final int y;
  final int z;
}
