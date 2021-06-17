/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the animation area chart.
class AnimationAreaDefault extends SampleView {
  /// Creates the animation area chart.
  const AnimationAreaDefault(Key key) : super(key: key);

  @override
  _AnimationAreaDefaultState createState() => _AnimationAreaDefaultState();
}

/// State class of animation area chart.
class _AnimationAreaDefaultState extends SampleViewState {
  _AnimationAreaDefaultState();
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
    return _buildAnimationAreaChart();
  }

  /// Return the cartesian chart with animation.
  SfCartesianChart _buildAnimationAreaChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(
            interval: 1, majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0),
            minimum: 0,
            maximum: 100),
        series: _getDefaultAreaSeries());
  }

  /// Return the list of  area series which need to be animated.
  List<AreaSeries<_ChartData, num>> _getDefaultAreaSeries() {
    return <AreaSeries<_ChartData, num>>[
      AreaSeries<_ChartData, num>(
          dataSource: _chartData,
          color: const Color.fromRGBO(75, 135, 185, 0.6),
          borderColor: const Color.fromRGBO(75, 135, 185, 1),
          borderWidth: 2,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  /// Return the random value in area series.
  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 8; i++) {
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
