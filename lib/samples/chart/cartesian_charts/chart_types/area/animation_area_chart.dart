/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Render the animation Area Chart.
class AnimationAreaDefault extends SampleView {
  const AnimationAreaDefault(Key key) : super(key: key);

  @override
  _AnimationAreaDefaultState createState() => _AnimationAreaDefaultState();
}

/// State class of animation Area Chart.
class _AnimationAreaDefaultState extends SampleViewState {
  _AnimationAreaDefaultState();

  List<_ChartData>? _chartData;
  Timer? _timer;

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

  /// Return the Cartesian Chart with animation.
  SfCartesianChart _buildCartesianChart() {
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(
        interval: 1,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        majorTickLines: MajorTickLines(color: Colors.transparent),
        axisLine: AxisLine(width: 0),
        minimum: 0,
        maximum: 100,
      ),
      series: _buildAreaSeries(
        themeData.useMaterial3,
        themeData.brightness == Brightness.light,
      ),
    );
  }

  /// Returns the list of Cartesian Area series.
  List<AreaSeries<_ChartData, num>> _buildAreaSeries(
    bool isMaterial3,
    bool isLightMode,
  ) {
    final Color color = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(6, 174, 224, 1)
              : const Color.fromRGBO(255, 245, 0, 1))
        : const Color.fromRGBO(75, 135, 185, 1);
    return <AreaSeries<_ChartData, num>>[
      AreaSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
        color: color.withValues(alpha: 0.6),
        borderColor: color,
      ),
    ];
  }

  /// Return the random value in Area series.
  int _buildRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  void _buildChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 8; i++) {
      _chartData!.add(_ChartData(i, _buildRandomInt(10, 95)));
    }
    _timer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
    _chartData!.clear();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
