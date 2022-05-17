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
  List<_ChartData>? _chartData;

  @override
  void initState() {
    _chartData = <_ChartData>[
      _ChartData(1, 11, 2.5),
      _ChartData(2, 24, 2.2),
      _ChartData(3, 36, 1.5),
      _ChartData(4, 54, 1.2),
      _ChartData(5, 57, 3),
      _ChartData(6, 70, 3.8),
      _ChartData(7, 78, 1)
    ];
    super.initState();
  }

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
          dataSource: _chartData!,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          sizeValueMapper: (_ChartData sales, _) => sales.size)
    ];
  }

  @override
  void dispose() {
    timer!.cancel();
    _chartData!.clear();
    super.dispose();
  }

  /// To get the random data and return to the chart data source.
  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    final Random randomValue = Random();
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 7; i++) {
      _chartData!.add(
          _ChartData(i, _getRandomInt(15, 90), randomValue.nextDouble() * 0.9));
    }
    timer?.cancel();
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.size);
  final int x;
  final int y;
  final double size;
}
