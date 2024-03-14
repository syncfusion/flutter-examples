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
  List<_ChartData>? _chartData;
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
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: const NumericAxis(
            interval: 1, majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: const NumericAxis(
            majorTickLines: MajorTickLines(color: Colors.transparent),
            axisLine: AxisLine(width: 0),
            minimum: 0,
            maximum: 100),
        series: _getDefaultAreaSeries(
            themeData.useMaterial3, themeData.brightness == Brightness.light));
  }

  /// Return the list of  area series which need to be animated.
  List<AreaSeries<_ChartData, num>> _getDefaultAreaSeries(
      bool isMaterial3, bool isLightMode) {
    final Color color = isMaterial3
        ? (isLightMode
            ? const Color.fromRGBO(6, 174, 224, 1)
            : const Color.fromRGBO(255, 245, 0, 1))
        : const Color.fromRGBO(75, 135, 185, 1);
    return <AreaSeries<_ChartData, num>>[
      AreaSeries<_ChartData, num>(
          dataSource: _chartData,
          color: color.withOpacity(0.6),
          borderColor: color,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
    _chartData!.clear();
  }

  /// Return the random value in area series.
  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 8; i++) {
      _chartData!.add(_ChartData(i, _getRandomInt(10, 95)));
    }
    _timer?.cancel();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
