/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the bar chart sample with dynamically updated data points.
class AnimationBarDefault extends SampleView {
  /// Creates the bar chart sample with dynamically updated data points.
  const AnimationBarDefault(Key key) : super(key: key);

  @override
  _AnimationBarDefaultState createState() => _AnimationBarDefaultState();
}

class _AnimationBarDefaultState extends SampleViewState {
  _AnimationBarDefaultState();
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

    return _buildAnimationBarChart();
  }

  SfCartesianChart _buildAnimationBarChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            minimum: 0,
            maximum: 100),
        series: _getDefaultBarSeries());
  }

  /// The method has retured the bar series.
  List<BarSeries<_ChartData, num>> _getDefaultBarSeries() {
    return <BarSeries<_ChartData, num>>[
      BarSeries<_ChartData, num>(
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

  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 7; i++) {
      _chartData.add(_ChartData(i, _getRandomInt(10, 95)));
    }
    _timer?.cancel();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
