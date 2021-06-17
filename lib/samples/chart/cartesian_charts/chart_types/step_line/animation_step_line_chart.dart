/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

/// Renders the stepline chart sample with dynamically updated data points.
class AnimationStepLineDefault extends SampleView {
  /// Creates the stepline chart sample with dynamically updated data points.
  const AnimationStepLineDefault(Key key) : super(key: key);

  @override
  _AnimationStepLineDefaultState createState() =>
      _AnimationStepLineDefaultState();
}

class _AnimationStepLineDefaultState extends SampleViewState {
  _AnimationStepLineDefaultState();
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    _getChartData();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
      });
    });
    return _buildAnimationStepLineChart();
  }

  /// get the stepline chart sample with dynamically updated data points.
  SfCartesianChart _buildAnimationStepLineChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0),
            minimum: 0,
            maximum: 100),
        series: _getDefaultStepLineSeries());
  }

  /// Get the stepline series dynamically updated data points.
  List<StepLineSeries<_ChartData, num>> _getDefaultStepLineSeries() {
    return <StepLineSeries<_ChartData, num>>[
      StepLineSeries<_ChartData, num>(
          dataSource: _chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 0; i <= 10; i++) {
      _chartData.add(_ChartData(i, _getRandomInt(5, 95)));
    }
    _chartData[10] = _ChartData(10, _chartData[9].y);
    timer?.cancel();
  }
}

late List<_ChartData> _chartData;

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
