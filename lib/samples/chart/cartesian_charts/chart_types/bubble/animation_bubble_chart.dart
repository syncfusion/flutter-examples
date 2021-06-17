/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the bubble chart sample with dynamically updated data points.
class AnimationBubbleDefault extends SampleView {
  /// Creates the bubble chart sample with dynamically updated data points.
  const AnimationBubbleDefault(Key key) : super(key: key);

  @override
  _AnimationBubbleDefaultState createState() => _AnimationBubbleDefaultState();
}

class _AnimationBubbleDefaultState extends SampleViewState {
  _AnimationBubbleDefaultState();
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    _getChartData();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _getChartData();
      });
    });
    return _buildAnimationBubbleChart();
  }

  SfCartesianChart _buildAnimationBubbleChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0),
            minimum: 0,
            maximum: 100),
        series: _getDefaultBubbleSeries());
  }

  List<BubbleSeries<_ChartData, num>> _getDefaultBubbleSeries() {
    return <BubbleSeries<_ChartData, num>>[
      BubbleSeries<_ChartData, num>(
          dataSource: _chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          sizeValueMapper: (_ChartData sales, _) => sales.size)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  /// To get the random data and return to the chart data source.
  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    final Random randomValue = Random();
    _chartData[0] =
        _ChartData(1, _getRandomInt(10, 50), randomValue.nextDouble() * 0.9);
    _chartData[1] =
        _ChartData(2, _getRandomInt(50, 80), randomValue.nextDouble() * 1.6);
    _chartData[2] =
        _ChartData(3, _getRandomInt(15, 55), randomValue.nextDouble() * 1.2);
    _chartData[3] =
        _ChartData(4, _getRandomInt(60, 89), randomValue.nextDouble() * 1.5);
    _chartData[4] =
        _ChartData(5, _getRandomInt(20, 48), randomValue.nextDouble() * 1.3);
    _chartData[5] =
        _ChartData(6, _getRandomInt(60, 87), randomValue.nextDouble() * 1.6);
    _chartData[6] =
        _ChartData(7, _getRandomInt(15, 60), randomValue.nextDouble() * 0.9);
    timer?.cancel();
  }

  final List<_ChartData> _chartData = <_ChartData>[
    _ChartData(1, 11, 2.5),
    _ChartData(2, 24, 2.2),
    _ChartData(3, 36, 1.5),
    _ChartData(4, 54, 1.2),
    _ChartData(5, 57, 3),
    _ChartData(6, 70, 3.8),
    _ChartData(7, 78, 1)
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, this.size);
  final int x;
  final int y;
  final double size;
}
